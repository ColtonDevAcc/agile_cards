import 'dart:async';
import 'dart:developer';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SessionRepository {
  DatabaseReference ref = FirebaseDatabase.instance.ref("sessions/${FirebaseAuth.instance.currentUser!.uid}}");

//user Session stream and ref
  final controller = StreamController<SessionStream>.broadcast();

  Stream<SessionStream> get status async* {
    yield SessionStream(stream: Session.empty());
    yield* controller.stream;
  }

  void listenForSessions(DatabaseReference? dbRef) {
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

  Future<List<Session>> getSessions() async {
    return [];
  }

  Future<void> createSession(Session session) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final updatedSession = session.copyWith(id: uid, owner: uid);
    await ref
        .child('$uid')
        .set(updatedSession.toJson())
        .onError((error, stackTrace) => log('error creating session: $error'))
        .whenComplete(() => log('session created'));

    listenForSessions(ref.child('$uid'));
  }

  Future<void> updateSession(Session session) async {
    await ref.update(session.toJson());
  }

  Future<Stream<DatabaseEvent>> joinSession(Session session) async {
    await ref.update(session.toJson());
    return ref.onValue;
  }
}

class SessionStream {
  Session? stream;
  SessionStream({required this.stream});
}
