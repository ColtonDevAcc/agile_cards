import 'dart:async';
import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository authenticationRepository;
  late StreamSubscription<AuthStream> authenticationStatusSubscription;

  AppBloc({required this.authenticationRepository}) : super(const AppState.unknown()) {
    on<AuthenticationStatusChanged>(onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(onLogoutRequested);
    on<AuthenticationPersistRequested>(onPersistRequested);
    authenticationStatusSubscription = authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  Future<void> onAuthenticationStatusChanged(AuthenticationStatusChanged event, Emitter<AppState> emit) async {
    switch (event.status.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AppState.unauthenticated());

      case AuthenticationStatus.authenticated:
        final user = event.status.user;
        return emit(AppState.authenticated(user!));

      case AuthenticationStatus.authenticating:
        return emit(const AppState.authenticating());

      case AuthenticationStatus.error:
        return emit(const AppState.unauthenticated());

      case AuthenticationStatus.initial:
        return emit(const AppState.unknown());
    }
  }

  void onLogoutRequested(AuthenticationLogoutRequested event, Emitter<AppState> emit) {
    authenticationRepository.logOut();
  }

  void onPersistRequested(AuthenticationPersistRequested event, Emitter<AppState> emit) {
    authenticationRepository.persistUser();
  }

  @override
  Future<void> close() {
    authenticationStatusSubscription.cancel();
    return super.close();
  }
}
