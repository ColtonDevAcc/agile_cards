import 'dart:async';
import 'dart:developer';
import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/services/analytics_service.dart';
import 'package:agile_cards/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SessionRepository {
  DatabaseReference ref = FirebaseDatabase.instance.ref("sessions/${FirebaseAuth.instance.currentUser!.uid}");

  final controller = StreamController<SessionStream>.broadcast();

  Stream<SessionStream> get status async* {
    yield SessionStream(stream: Session.empty());
    yield* controller.stream;
  }

  void subscribeToSession(DatabaseReference? dbRef) {
    try {
      if (dbRef != null) {
        dbRef.onValue.listen(
          (event) {
            if (event.snapshot.value != null) {
              controller.add(SessionStream(stream: Session.fromDocument(event.snapshot)));
              ref = dbRef;
            } else {
              controller.add(SessionStream(stream: Session.empty()));
            }
          },
        );
      } else {
        ref.onValue.listen((event) {
          if (event.snapshot.value != null) {
            controller.add(SessionStream(stream: Session.fromDocument(event.snapshot)));
          }
        });
        ref = dbRef!;
      }
    } catch (e) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'subscribe_to_session', stacktrace: StackTrace.current);
    }
  }

  Future<Session?> searchForSession(String query) async {
    try {
      if (query.isEmpty) {
        log('query is empty');
        return null;
      }
      final sessionRef = FirebaseDatabase.instance.ref('sessions/$query');
      final DatabaseEvent session = await sessionRef.once();

      if (session.snapshot.value != null) {
        final Session sessionResult = Session.fromDocument(session.snapshot);
        log('session found $sessionResult');
        return sessionResult;
      } else {
        log('no session found');
      }
      await locator<AnalyticsService>().logEvent(
        name: 'search_for_session',
      );
    } catch (e) {
      await locator<AnalyticsService>().logError(exception: e.toString(), reason: 'search_for_session', stacktrace: StackTrace.current);
    }

    return null;
  }

  Future<void> createSession(Session session) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      final updatedSession = session.copyWith(id: uid, owner: uid);
      await ref.set(updatedSession.toDocument()).onError((error, stackTrace) => log('error creating session: $error'));
      await ref.child('participants').child(uid!).set(Participant.fromUser(FirebaseAuth.instance.currentUser!).toJson());
      subscribeToSession(ref);
      await locator<AnalyticsService>().logEvent(name: 'create_session');
    } catch (e) {
      await locator<AnalyticsService>().logError(exception: e.toString(), reason: 'create_session', stacktrace: StackTrace.current);
    }
  }

  Future<void> updateSession(Session session) async {
    await ref.update(session.toJson()).onError((error, stackTrace) {
      locator<AnalyticsService>().logError(exception: error.toString(), reason: 'update_session', stacktrace: stackTrace);
    }).whenComplete(() {
      locator<AnalyticsService>().logEvent(
        name: 'update_session',
      );
    });
  }

  Future<void> joinSession(String sessionId) async {
    try {
      final sessionRef = FirebaseDatabase.instance.ref('sessions/$sessionId');
      final User user = FirebaseAuth.instance.currentUser!;
      final DataSnapshot snapshot = await sessionRef.get();
      final Session session = Session.fromDocument(snapshot);

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

      await sessionRef.child('participants').child(user.uid).set(Participant.fromUser(user).toJson());

      subscribeToSession(sessionRef);
      await locator<AnalyticsService>().logEvent(
        name: 'joined_session',
      );
    } catch (e, st) {
      await locator<AnalyticsService>().logError(exception: e.toString(), reason: 'join_session', stacktrace: st);
    }
  }

  Future<void> updateCardSelection(Selection selection) async {
    try {
      final Session? session = await ref.get().then((value) => Session.fromDocument(value));
      final User user = FirebaseAuth.instance.currentUser!;

      if (session != null && session.participants != null && !session.participants!.contains(Participant.fromUser(user))) {
        await Fluttertoast.showToast(
          msg: 'you are not a participant of this session. Please rejoin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 3,
        );
        return;
      }

      await ref.child('selections').child(user.uid).set(selection.toJson()).whenComplete(() => log('added selection'));

      await locator<AnalyticsService>().logEvent(name: 'selected_agile_card', parameters: {'agile_card_selected': selection.cardSelected});
    } catch (e, st) {
      await locator<AnalyticsService>().logError(exception: e.toString(), reason: 'agile_card_selected', stacktrace: st);
    }
  }

  Future<void> leaveSession() async {
    try {
      final session = await ref.get();
      final User user = FirebaseAuth.instance.currentUser!;

      if (session.value != null) {
        final Session sessionResult = Session.fromDocument(session);

        if (sessionResult.owner == user.uid) {
          await ref.remove();
          return;
        }

        //remove participant
        await ref.child('participants').child(user.uid).remove();

        //remove selection
        if (sessionResult.selections != null) {
          await ref.child('selections').child(user.uid).remove();
        }
      }
      await locator<AnalyticsService>().logEvent(name: 'leave_session');
    } catch (e, st) {
      await locator<AnalyticsService>().logError(exception: e.toString(), reason: 'leave_session', stacktrace: st);
    }
  }

  Future<void> updateSessionName({required String name}) async {
    await ref.update({'name': name}).onError((error, stackTrace) {
      locator<AnalyticsService>().logError(exception: error.toString(), reason: 'update_session_name', stacktrace: stackTrace);
    }).whenComplete(() {
      locator<AnalyticsService>().logEvent(
        name: 'update_session_name',
      );
    });
  }

  Future<void> updateSessionDescription({required String description}) async {
    await ref.update({'description': description}).onError((error, stackTrace) {
      locator<AnalyticsService>().logError(exception: error.toString(), reason: 'update_session_description', stacktrace: stackTrace);
    }).onError((error, stackTrace) {
      locator<AnalyticsService>().logEvent(
        name: 'update_session_description',
      );
    });
  }

  Future<void> forceAddParticipant({required Participant participant}) async {
    final participantData = await ref.child('participants').get();
    final List<Participant> participants = const Participant().parseRawList(participantData.value);
    participants.add(participant);

    await ref.child('participants').set(participants.map((e) => e.toJson()).toList()).onError((error, stackTrace) {
      locator<AnalyticsService>().logError(exception: error.toString(), reason: 'force_add_participant', stacktrace: stackTrace);
    });

    await locator<AnalyticsService>().logEvent(
      name: 'force_add_participant',
      parameters: {'force_add_participant': participant.id},
    );
  }

  Future<void> forceRemoveParticipant({required Participant participant}) async {
    try {
      final participantData = await ref.child('participants').get();
      final List<Participant> participants = const Participant().parseRawList(participantData.value);
      participants.removeWhere((element) => element.id == participant.id);

      //if have selections remove them
      if (participants.isNotEmpty) {
        final participantData = await ref.child('selections').get();

        final List<Selection> selections = const Selection().parseRawList(participantData.value);
        selections.removeWhere((element) => element.userId == participant.id);
      }

      await ref.child('participants').set(participants.map((e) => e.toJson()).toList());

      await locator<AnalyticsService>().logEvent(
        name: 'force_remove_participant',
        parameters: {'force_removed_participant': participant.id},
      );
    } catch (e) {
      await locator<AnalyticsService>().logError(exception: e.toString(), reason: 'force_remove_participant', stacktrace: StackTrace.current);
    }
  }

  Future<void> changeCardReveal({required bool reveal}) async {
    await ref.update({'cardsRevealed': reveal}).onError((error, stackTrace) {
      locator<AnalyticsService>().logError(exception: error.toString(), reason: 'change_card_reveal', stacktrace: stackTrace);
    }).whenComplete(() {
      locator<AnalyticsService>().logEvent(
        name: 'reveal_card',
        parameters: {'reveal_card': reveal},
      );
    });
  }

  Future<void> useShirtSizes({required bool useShirtSizes}) async {
    await ref.update({'isShirtSizes': useShirtSizes}).onError((error, stackTrace) {
      locator<AnalyticsService>().logError(exception: error.toString(), reason: 'use_shirt_sizes', stacktrace: stackTrace);
    }).whenComplete(() {
      locator<AnalyticsService>().logEvent(
        name: 'use_shirt_sizes',
        parameters: {'use_shirt_sizes': useShirtSizes},
      );
    });
  }
}

class SessionStream {
  Session? stream;
  SessionStream({required this.stream});
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
