part of 'session_bloc.dart';

class SessionState extends Equatable {
  final Session session;
  const SessionState({required this.session});

  @override
  List<Object> get props => [session];

  SessionState copyWith({
    Session? session,
  }) {
    return SessionState(
      session: session ?? this.session,
    );
  }
}
