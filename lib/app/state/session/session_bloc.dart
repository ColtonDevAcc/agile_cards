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
          SessionState(session: Session.empty(), cardSelection: const []),
        ) {
    on<SessionStarted>(_onSessionStarted);
    on<SessionCreated>(_onSessionCreated);
    on<SessionUpdated>(_onSessionUpdated);
    on<SessionDeleted>(_onSessionDeleted);
    on<SessionLoaded>(_onSessionLoaded);
    on<SessionJoined>(_onSessionJoined);
    on<SessionChanged>(_onSessionChanged);
    on<SessionSearched>(_onSessionSearched);
    on<SessionUpdateAgileCard>(_onSessionUpdateAgileCard);
    on<SessionLeave>(_onSessionLeave);
    on<SessionNameChanged>(_onSessionNameChanged);
    on<SessionDescriptionChanged>(_onSessionDescriptionChanged);
    on<SessionForceParticipantAdded>(_onSessionParticipantAdded);
    on<SessionForceParticipantRemoved>(_onSessionForceParticipantRemoved);
    on<SessionToggleRevealCards>(_onSessionToggleCards);
    on<SessionToggleUseShirtSizes>(_onSessionToggleUseShirtSizes);
    sessionSubscription = sessionRepository.status.listen((session) {
      add(SessionChanged(session));
    });
  }

  Future<void> _onSessionCreated(SessionCreated event, Emitter<SessionState> emit) async {
    try {
      await sessionRepository.createSession(event.session);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _onSessionStarted(SessionStarted event, Emitter<SessionState> emit) async {}

  Future<void> _onSessionUpdated(SessionUpdated event, Emitter<SessionState> emit) async {
    await sessionRepository.updateSession(event.session);
  }

  Future<void> _onSessionDeleted(SessionDeleted event, Emitter<SessionState> emit) async {
    await sessionRepository.deleteSession();
  }

  Future<void> _onSessionLoaded(SessionLoaded event, Emitter<SessionState> emit) async {}

  Future<void> _onSessionJoined(SessionJoined event, Emitter<SessionState> emit) async {
    await sessionRepository.joinSession(sessionId: event.id);
  }

  Future<void> _onSessionChanged(SessionChanged event, Emitter<SessionState> emit) async {
    emit(state.copyWith(session: event.session));
  }

  Future<void> _onSessionSearched(SessionSearched event, Emitter<SessionState> emit) async {
    final sessions = await sessionRepository.searchForSession(event.query);
    emit(state.copyWith(sessionSearch: sessions));
  }

  Future<void> _onSessionUpdateAgileCard(SessionUpdateAgileCard event, Emitter<SessionState> emit) async {
    await sessionRepository.updateAgileCard(selection: event.selection);
  }

  Future<void> _onSessionLeave(SessionLeave event, Emitter<SessionState> emit) async {
    await sessionRepository.leaveSession(userId: FirebaseAuth.instance.currentUser!.uid);
    emit(state.copyWith(session: Session.empty()));
  }

  Future<void> _onSessionNameChanged(SessionNameChanged event, Emitter<SessionState> emit) async {
    await sessionRepository.updateSessionName(name: event.name);
  }

  Future<void> _onSessionDescriptionChanged(SessionDescriptionChanged event, Emitter<SessionState> emit) async {
    await sessionRepository.updateSessionDescription(description: event.description);
  }

  Future<void> _onSessionParticipantAdded(SessionForceParticipantAdded event, Emitter<SessionState> emit) async {
    await sessionRepository.addParticipant(participant: event.participant);
  }

  Future<void> _onSessionForceParticipantRemoved(SessionForceParticipantRemoved event, Emitter<SessionState> emit) async {
    await sessionRepository.removeParticipant(participant: event.participant);
  }

  Future<void> _onSessionToggleCards(SessionToggleRevealCards event, Emitter<SessionState> emit) async {
    await sessionRepository.toggleRevealCards();
  }

  Future<void> _onSessionToggleUseShirtSizes(SessionToggleUseShirtSizes event, Emitter<SessionState> emit) async {
    await sessionRepository.toggleSessionMeasurement();
  }

  @override
  Future<void> close() {
    sessionSubscription.cancel();
    return super.close();
  }
}
