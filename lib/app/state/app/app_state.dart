part of 'app_bloc.dart';

class AppState extends Equatable {
  final User? user;
  final AuthenticationStatus status;
  const AppState({this.status = AuthenticationStatus.initial, this.user});

  @override
  List<Object?> get props => [status, user];

  const AppState.unknown() : this();
  const AppState.authenticated(User user) : this(status: AuthenticationStatus.authenticated, user: user);
  const AppState.unauthenticated() : this(status: AuthenticationStatus.unauthenticated);
  const AppState.authenticating() : this(status: AuthenticationStatus.authenticating);

  AppState copyWith({
    AuthenticationStatus? status,
    User? user,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}

enum AuthenticationStatus { initial, authenticated, unauthenticated, error, authenticating }
