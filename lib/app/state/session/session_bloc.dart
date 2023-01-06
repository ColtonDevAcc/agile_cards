import 'dart:async';
import 'dart:developer';

import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionRepository sessionRepository;
  late StreamSubscription sessionSubscription;
  SessionBloc({required this.sessionRepository})
      : super(
          SessionState(
            session: Session.empty(),
            cardSelection: const [],
          ),
        ) {
    on<SessionStarted>(_onSessionStarted);
    on<SessionCreated>(_onSessionCreated);
    on<SessionUpdated>(_onSessionUpdated);
    on<SessionDeleted>(_onSessionDeleted);
    on<SessionLoaded>(_onSessionLoaded);
    on<SessionJoined>(_onSessionJoined);
    on<SessionChanged>(_onSessionChanged);
    on<SessionSearched>(_onSessionSearched);
    on<SessionAgileCardSelected>(_onSessionAgileCardSelected);
    on<SessionAgileCardDeselected>(_onSessionAgileCardDeselected);
    sessionSubscription = sessionRepository.status.listen((status) => add(SessionChanged(status)));
  }

  Future<void> _onSessionCreated(SessionCreated event, Emitter<SessionState> emit) async {
    try {
      final Session session = Session(
        id: event.owner.id,
        name: 'test',
        description: 'description',
        owner: FirebaseAuth.instance.currentUser?.email,
        participants: [event.owner],
      );

      await sessionRepository.createSession(session);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onSessionStarted(SessionStarted event, Emitter<SessionState> emit) async {
    // final sessions = await sessionRepository.getSessions();
  }

  Future<void> _onSessionUpdated(SessionUpdated event, Emitter<SessionState> emit) async {
    await sessionRepository.updateSession(event.session);
  }

  Future<void> _onSessionDeleted(SessionDeleted event, Emitter<SessionState> emit) async {
    // await sessionRepository.deleteSession(event.session);
    // final sessions = await sessionRepository.getSessions();
    // emit(SessionState(sessions: sessions));
  }

  Future<void> _onSessionLoaded(SessionLoaded event, Emitter<SessionState> emit) async {}

  Future<void> _onSessionJoined(SessionJoined event, Emitter<SessionState> emit) async {
    sessionRepository.joinSession(event.id);
  }

  Future<void> _onSessionChanged(SessionChanged event, Emitter<SessionState> emit) async {
    emit(state.copyWith(session: event.session.stream ?? Session.empty()));
  }

  Future<void> _onSessionSearched(SessionSearched event, Emitter<SessionState> emit) async {
    final sessions = await sessionRepository.searchForSession(event.query);
    emit(state.copyWith(sessionSearch: sessions ?? Session.empty()));
  }

  Future<void> _onSessionAgileCardSelected(SessionAgileCardSelected event, Emitter<SessionState> emit) async {
    await sessionRepository.agileCardSelected(event.selection);
  }

  Future<void> _onSessionAgileCardDeselected(SessionAgileCardDeselected event, Emitter<SessionState> emit) async {
    await sessionRepository.agileCardDeselected();
  }

  @override
  Future<void> close() {
    sessionSubscription.cancel();
    return super.close();
  }
}
