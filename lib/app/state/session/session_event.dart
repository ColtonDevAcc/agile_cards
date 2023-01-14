part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class SessionStarted extends SessionEvent {}

class SessionCreated extends SessionEvent {
  final Participant owner;
  const SessionCreated(this.owner);

  @override
  List<Object> get props => [owner];
}

class SessionSearched extends SessionEvent {
  final String query;
  const SessionSearched(this.query);

  @override
  List<Object> get props => [query];
}

class SessionUpdated extends SessionEvent {
  final Session session;

  const SessionUpdated({required this.session});

  @override
  List<Object> get props => [session];
}

class SessionDeleted extends SessionEvent {
  final Session session;

  const SessionDeleted(this.session);

  @override
  List<Object> get props => [session];
}

class SessionLoaded extends SessionEvent {
  final List<Session> sessions;

  const SessionLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];
}

class SessionJoined extends SessionEvent {
  final String id;
  const SessionJoined(this.id);

  @override
  List<Object> get props => [id];
}

class SessionChanged extends SessionEvent {
  final SessionStream session;

  const SessionChanged(this.session);

  @override
  List<Object> get props => [session];
}

class SessionAgileCardSelected extends SessionEvent {
  final Selection selection;
  const SessionAgileCardSelected(this.selection);

  @override
  List<Object> get props => [selection];
}

class SessionLeave extends SessionEvent {
  const SessionLeave();

  @override
  List<Object> get props => [];
}

class SessionAgileCardDeselected extends SessionEvent {
  const SessionAgileCardDeselected();

  @override
  List<Object> get props => [];
}

class SessionNameChanged extends SessionEvent {
  final String name;
  const SessionNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class SessionDescriptionChanged extends SessionEvent {
  final String description;
  const SessionDescriptionChanged(this.description);

  @override
  List<Object> get props => [description];
}

class SessionForceParticipantAdded extends SessionEvent {
  final Participant participant;
  const SessionForceParticipantAdded(this.participant);

  @override
  List<Object> get props => [participant];
}

class SessionRevealCards extends SessionEvent {
  final bool reveal;
  const SessionRevealCards({required this.reveal});

  @override
  List<Object> get props => [reveal];
}

class SessionForceParticipantRemoved extends SessionEvent {
  final Participant participant;
  const SessionForceParticipantRemoved(this.participant);

  @override
  List<Object> get props => [participant];
}

class SessionUseShirtSizes extends SessionEvent {
  final bool useShirtSizes;
  const SessionUseShirtSizes({required this.useShirtSizes});

  @override
  List<Object> get props => [useShirtSizes];
}
