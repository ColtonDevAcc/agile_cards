part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AppEvent {
  final AuthStream status;
  const AuthenticationStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}

class AuthenticationLogoutRequested extends AppEvent {}

class AuthenticationPersistRequested extends AppEvent {}

class AuthenticationPersisted extends AppEvent {}

class ChangeUserAvatar extends AppEvent {
  const ChangeUserAvatar();

  @override
  List<Object> get props => [];
}
