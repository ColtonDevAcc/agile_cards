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
              // ignore: cast_nullable_to_non_nullable
              final data = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
              controller.add(SessionStream(stream: Session.fromJson(data)));
              ref = dbRef;
            } else {
              controller.add(SessionStream(stream: Session.empty()));
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
        // ignore: cast_nullable_to_non_nullable
        final data = Map<String, dynamic>.from(session.snapshot.value as Map);
        final Session sessionResult = Session.fromJson(data);
        log('session found $sessionResult');
        return sessionResult;
      } else {
        log('no session found');
      }
      locator<AnalyticsService>().logEvent(
        name: 'search_for_session',
      );
    } catch (e) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'search_for_session', stacktrace: StackTrace.current);
    }

    return null;
  }

  Future<void> createSession(Session session) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      final updatedSession = session.copyWith(id: uid, owner: uid);
      await ref
          .set(updatedSession.toJson())
          .onError((error, stackTrace) => log('error creating session: $error'))
          .whenComplete(() => log('session created'));

      subscribeToSession(ref);
      locator<AnalyticsService>().logEvent(
        name: 'create_session',
      );
    } catch (e) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'create_session', stacktrace: StackTrace.current);
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
      locator<AnalyticsService>().logEvent(
        name: 'joined_session',
      );
    } catch (e) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'join_session', stacktrace: StackTrace.current);
    }
  }

  Future<void> agileCardSelected(Selection selection) async {
    try {
      // ignore: cast_nullable_to_non_nullable
      final Session? session = await ref.get().then((value) => Session.fromJson(Map<String, dynamic>.from(value.value as Map)));
      final User user = FirebaseAuth.instance.currentUser!;
      final List<Selection> sessionSelection = session?.selections ?? [];

      if (session != null && session.participants != null && !session.participants!.contains(Participant.fromUser(user))) {
        Fluttertoast.showToast(
          msg: 'you are not a participant of this session. Please rejoin',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 3,
        );

        return;
      }

      int b = 0;
      int a = 0;
      if (sessionSelection.isNotEmpty) {
        for (final s in sessionSelection) {
          b++;
          if (s.userId == user.uid) {
            await ref.child('selections').child('$a').set(selection.toJson()).whenComplete(() => log('updated selection'));
            return;
          } else if (a - b != 1 && b != 0) {
            await ref.child('selections').child('$b').set(selection.toJson()).whenComplete(() => log('updated selection'));
            return;
          }
          a++;
        }
      }

      if (sessionSelection.isEmpty) {
        await ref.child('selections').set([selection.toJson()]).whenComplete(() => log('added first selection'));
      } else {
        await ref.child('selections').child('${sessionSelection.length}').set(selection.toJson()).whenComplete(() => log('added selection'));
      }
      locator<AnalyticsService>().logEvent(
        name: 'selected_agile_card',
        parameters: {'agile_card_selected': selection.cardSelected},
      );
    } catch (e, st) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'agile_card_selected', stacktrace: st);
    }
  }

  Future<void> agileCardDeselected() async {
    try {
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
      locator<AnalyticsService>().logEvent(name: 'deselect_agile_card');
    } catch (e) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'agile_card_deselected', stacktrace: StackTrace.current);
    }
  }

  Future<void> leaveSession() async {
    try {
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

        //remove participant
        sessionResult.participants?.removeWhere((element) => element.id == user.uid);

        //remove selection
        if (sessionResult.selections != null) {
          sessionResult.selections?.removeWhere((element) => element.userId == user.uid);
        }

        await ref.update(sessionResult.toJson()).whenComplete(
              () => ref = FirebaseDatabase.instance.ref("sessions/${FirebaseAuth.instance.currentUser!.uid}"),
            );
      }
      locator<AnalyticsService>().logEvent(
        name: 'leave_session',
      );
    } catch (e) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'leave_session', stacktrace: StackTrace.current);
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

    locator<AnalyticsService>().logEvent(
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

      locator<AnalyticsService>().logEvent(
        name: 'force_remove_participant',
        parameters: {'force_removed_participant': participant.id},
      );
    } catch (e) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'force_remove_participant', stacktrace: StackTrace.current);
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
