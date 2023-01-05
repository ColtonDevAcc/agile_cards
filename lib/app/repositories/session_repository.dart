import 'dart:async';
import 'dart:developer';
import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SessionRepository {
  DatabaseReference ref = FirebaseDatabase.instance.ref("sessions/${FirebaseAuth.instance.currentUser!.uid}");

  final controller = StreamController<SessionStream>.broadcast();

  Stream<SessionStream> get status async* {
    yield SessionStream(stream: Session.empty());
    yield* controller.stream;
  }

  void subscribeToSession(DatabaseReference? dbRef) {
    if (dbRef != null) {
      dbRef.onValue.listen(
        (event) {
          if (event.snapshot.value != null) {
            // ignore: cast_nullable_to_non_nullable
            final data = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
            log('something new changed');
            controller.add(SessionStream(stream: Session.fromJson(data)));
          }
        },
      );
    } else {
      ref.onValue.listen((event) {
        if (event.snapshot.value != null) {
          // ignore: cast_nullable_to_non_nullable
          final data = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
          log('something changed');
          controller.add(SessionStream(stream: Session.fromJson(data)));
        }
      });
    }
  }

  Future<Session?> searchForSession(String query) async {
    if (query.isEmpty) {
      log('query is empty');
      return null;
    }
    final sessionRef = FirebaseDatabase.instance.ref('sessions/$query');
    final DatabaseEvent session = await sessionRef.once();

    if (session.snapshot.value != null) {
      // ignore: cast_nullable_to_non_nullable
      final data = Map<String, dynamic>.from(session.snapshot.value as Map<dynamic, dynamic>);
      final Session sessionResult = Session.fromJson(data);
      log('session found $sessionResult');
      return sessionResult;
    } else {
      log('no session found');
    }

    return null;
  }

  Future<void> createSession(Session session) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final updatedSession = session.copyWith(id: uid, owner: uid);
    await ref
        .set(updatedSession.toJson())
        .onError((error, stackTrace) => log('error creating session: $error'))
        .whenComplete(() => log('session created'));

    subscribeToSession(ref);
  }

  Future<void> updateSession(Session session) async {
    await ref.update(session.toJson());
  }

  Future<void> joinSession(String sessionId) async {
    final sessionRef = FirebaseDatabase.instance.ref('sessions/$sessionId');
    final sessionResult = await sessionRef.get();

    final User user = FirebaseAuth.instance.currentUser!;
    // ignore: cast_nullable_to_non_nullable
    final data = sessionResult.value as Map<dynamic, dynamic>;
    final Session session = Session.fromJson(Map<String, dynamic>.from(data));

    if (user.uid == session.owner) {
      log('returning you to the session as the owner');
      return;
    }

    if (session.participants == null || session.participants!.isEmpty) {
      subscribeToSession(sessionRef);
      return;
    }

    for (final participant in session.participants ?? []) {
      if (participant.id == user.uid) {
        log('returning you to the session as a participant');
        subscribeToSession(sessionRef);
        return;
      }
    }

    final updatedSession = session.copyWith(
      participants: [
        ...session.participants ?? [],
        Participant.fromUser(user),
      ],
    );

    await sessionRef.update(updatedSession.toJson());

    subscribeToSession(sessionRef);
  }
}

class SessionStream {
  Session? stream;
  SessionStream({required this.stream});
}
