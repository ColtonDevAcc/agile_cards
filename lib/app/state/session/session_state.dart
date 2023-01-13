part of 'session_bloc.dart';

class SessionState extends Equatable {
  final Session session;
  final Session? sessionSearch;
  final List<int> cardSelection;
  const SessionState({required this.cardSelection, this.sessionSearch, required this.session});

  @override
  List<Object?> get props => [session, sessionSearch];

  SessionState copyWith({
    Session? session,
    Session? sessionSearch,
  }) {
    return SessionState(
      cardSelection: cardSelection,
      session: session ?? this.session,
      sessionSearch: sessionSearch ?? this.sessionSearch,
    );
  }
}
