part of 'session_bloc.dart';

class SessionState extends Equatable {
  final Session session;
  final Session? sessionSearch;
  const SessionState({this.sessionSearch, required this.session});

  @override
  List<Object?> get props => [session, sessionSearch];

  SessionState copyWith({
    Session? session,
    Session? sessionSearch,
  }) {
    return SessionState(
      session: session ?? this.session,
      sessionSearch: sessionSearch ?? this.sessionSearch,
    );
  }
}
