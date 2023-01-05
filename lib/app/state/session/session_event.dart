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

  @override
  String toString() => 'SessionUpdated { session: $session }';
}

class SessionDeleted extends SessionEvent {
  final Session session;

  const SessionDeleted(this.session);

  @override
  List<Object> get props => [session];

  @override
  String toString() => 'SessionDeleted { session: $session }';
}

class SessionLoaded extends SessionEvent {
  final List<Session> sessions;

  const SessionLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];

  @override
  String toString() => 'SessionLoaded { sessions: $sessions }';
}

class SessionJoined extends SessionEvent {
  final String id;
  const SessionJoined(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'SessionJoined { session: $id }';
}

class SessionChanged extends SessionEvent {
  final SessionStream session;

  const SessionChanged(this.session);

  @override
  List<Object> get props => [session];

  @override
  String toString() => 'SessionChanged { session: $session }';
}
