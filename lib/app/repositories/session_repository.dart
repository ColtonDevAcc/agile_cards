import 'dart:async';
import 'dart:developer';
import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
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
            ref = dbRef;
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
      ref = dbRef!;
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
      final data = Map<String, dynamic>.from(session.snapshot.value as Map);
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

    for (final p in session.participants ?? []) {
      final participant = p as Participant;
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

  Future<void> agileCardSelected(Selection selection) async {
    final ref = this.ref.child('selections');
    final Object? data = await ref.get().then((value) => value.child('selections').value);
    final sessionSelection = selection.toJson();
    final User user = FirebaseAuth.instance.currentUser!;

    final int length = data == null ? 0 : (data as List).length;

    int b = 0;
    int a = 0;
    if (data != null) {
      for (final s in data as List) {
        b++;
        final selection = Selection.fromJson(Map<String, dynamic>.from(s as Map));
        if (selection.userId == user.uid) {
          await ref
              .child('$a')
              .set(sessionSelection)
              .onError((error, stackTrace) => log('error updating card selection $error'))
              .whenComplete(() => log('updated selection'));
          return;
        } else if (a - b != 1 && b != 0) {
          log("missing item in list $b");
          await ref
              .child('$b')
              .set(sessionSelection)
              .onError((error, stackTrace) => log('error updating card selection $error'))
              .whenComplete(() => log('updated selection'));
          return;
        }
        a++;
      }
    }

    if (data == null || length == 0) {
      await ref
          .set([sessionSelection])
          .onError((error, stackTrace) => log('error adding card selection $error'))
          .whenComplete(() => log('added first selection'));
    } else {
      await ref
          .child('$length')
          .set(sessionSelection)
          .onError((error, stackTrace) => log('error adding card selection $error'))
          .whenComplete(() => log('added selection'));
    }
  }

  Future<void> agileCardDeselected() async {
    final ref = this.ref.child('selections');
    final Object? data = await ref.get().then((value) => value.child('selections').value);
    final User user = FirebaseAuth.instance.currentUser!;

    if (data != null) {
      int i = 0;
      for (final s in data as List) {
        i++;
        final selection = Selection.fromJson(Map<String, dynamic>.from(s as Map));
        if (selection.userId == user.uid) {
          await ref
              .child('${i - 1}')
              .update(selection.copyWith(lockedIn: false).toJson())
              .onError((error, stackTrace) => log('error removing card selection $error'))
              .whenComplete(() => log('removed selection'));
          return;
        }
      }
    }
  }

  Future<void> leaveSession() async {
    final session = await ref.get();
    final User user = FirebaseAuth.instance.currentUser!;

    if (session.value != null) {
      // ignore: cast_nullable_to_non_nullable
      final data = Map<String, dynamic>.from(session.value as Map);
      final Session sessionResult = Session.fromJson(data);

      if (sessionResult.owner == user.uid) {
        await ref.remove();
        return;
      }

      if (sessionResult.participants == null || sessionResult.participants!.isEmpty) {
        return;
      }

      for (final p in sessionResult.participants ?? []) {
        final participant = p as Participant;
        if (participant.id == user.uid) {
          final updatedSession = sessionResult.copyWith(
            participants: sessionResult.participants!.where((element) => element.id != user.uid).toList(),
          );

          await ref.update(updatedSession.toJson());
          return;
        }
      }
    }
  }

  Future<void> updateSessionName({required String name}) async {
    await ref.update({'name': name});
  }

  Future<void> updateSessionDescription({required String description}) async {
    await ref.update({'description': description});
  }
}

class SessionStream {
  Session? stream;
  SessionStream({required this.stream});
}
