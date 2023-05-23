import 'dart:async';
import 'dart:developer';
import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/services/analytics_service.dart';
import 'package:agile_cards/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SessionRepository {
  DatabaseReference ref = FirebaseDatabase.instance.ref("sessions/${FirebaseAuth.instance.currentUser!.uid}");
  final controller = StreamController<Session>.broadcast();

  Stream<Session> get status async* {
    yield* controller.stream;
  }

  StreamSubscription<DatabaseEvent>? subscriptionEvent;

  Future<void> subscribeToSession({DatabaseReference? ref}) async {
    if (ref != null) {
      this.ref = ref;
    }
    subscriptionEvent = ref?.onValue.listen((event) {
      final session = Session.fromDocument(event.snapshot);
      if (session.participants?.any((element) => element.id == FirebaseAuth.instance.currentUser?.uid) == false &&
          session.owner != FirebaseAuth.instance.currentUser?.uid) {
        log('not a participant, cancelling subscription');
        controller.add(Session.empty());
        subscriptionEvent?.cancel();
        return;
      }

      controller.add(session);
    });
  }

  Future<void> updateSession(Session session) async {
    await ref.set(session.toDocument());
  }

  Future<void> createSession(Session session) async {
    await FirebaseDatabase.instance.ref("sessions").child(session.id!).set(session.toDocument());
    final newRef = FirebaseDatabase.instance.ref("sessions/${session.id}");
    if (session.participants != null && session.participants!.isNotEmpty) {
      await newRef.child('participants').child(FirebaseAuth.instance.currentUser!.uid).set(
            Participant.fromUser(FirebaseAuth.instance.currentUser!).toJson(),
          );
    }

    await subscribeToSession(ref: newRef);
  }

  Future<void> deleteSession() async {
    await ref.remove();
  }

  Future<void> joinSession({required String sessionId}) async {
    try {
      ref = FirebaseDatabase.instance.ref("sessions/$sessionId");
      await ref
          .child('participants/${FirebaseAuth.instance.currentUser!.uid}')
          .set(Participant.fromUser(FirebaseAuth.instance.currentUser!).toJson());
      await subscribeToSession(ref: ref);
    } catch (e, st) {
      await locator<AnalyticsService>().logError(exception: e.toString(), reason: 'join_session', stacktrace: st);
    }
  }

  Future<void> leaveSession({required String userId}) async {
    await ref.child('participants/$userId').remove();

    //remove all selections
    await ref.child('selections/$userId').remove();

    final DatabaseReference newRef = FirebaseDatabase.instance.ref("sessions/${FirebaseAuth.instance.currentUser!.uid}");

    await subscribeToSession(ref: newRef);
  }

  Future<void> updateAgileCard({required Selection selection}) async {
    await ref.child('selections/${selection.userId}').set(selection.toJson());
  }

  Future<void> updateSessionName({required String name}) async {
    await ref.child('name').set(name);
  }

  Future<void> updateSessionDescription({required String description}) async {
    await ref.child('description').set(description);
  }

  Future<void> addParticipant({required Participant participant}) async {
    await ref.child('participants/${participant.id}').set(participant.toJson());
  }

  Future<void> removeParticipant({required Participant participant}) async {
    await ref.child('participants/${participant.id}').remove();
    await ref.child('selections/${participant.id}').remove();
  }

  Future<Session> searchForSession(String sessionId) async {
    try {
      if (sessionId.isEmpty) {
        log('query is empty');
        return Session.empty();
      }

      final session = await FirebaseDatabase.instance.ref('sessions/$sessionId').once();
      return Session.fromDocument(session.snapshot);
    } catch (e, st) {
      await locator<AnalyticsService>().logError(exception: 'search_for_session', reason: e.toString(), stacktrace: st);
      return Session.empty();
    }
  }

  Future<void> toggleRevealCards() async {
    await ref
        .child('cardsRevealed')
        .once()
        .then((value) => value.snapshot.value == true ? ref.child('cardsRevealed').set(false) : ref.child('cardsRevealed').set(true));
  }

  Future<void> toggleSessionMeasurement() async {
    await ref
        .child('isShirtSizes')
        .once()
        .then((value) => value.snapshot.value == true ? ref.child('isShirtSizes').set(false) : ref.child('isShirtSizes').set(true));
  }
}

const List<String> tShirtSizes = [
  'XS',
  'S',
  'M',
  'L',
  'XL',
  'XXL',
  'XXXL',
];

const List<String> taskSizes = [
  '1',
  '2',
  '3',
  '5',
  '8',
  '13',
  '20',
  '40',
  '100',
  '∞',
];
