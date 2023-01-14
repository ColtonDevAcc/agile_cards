import 'package:agile_cards/app/repositories/authentication_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository authenticationRepository;
  LoginCubit({required this.authenticationRepository})
      : super(
          const LoginState(
            isLogin: false,
            isRegister: false,
            email: '',
            password: '',
          ),
        );

  void login() {
    if (state.isLogin == true) {
      authenticationRepository.logIn(email: state.email, password: state.password);
    }
    emit(state.copyWith(isLogin: true));
  }

  void register() {
    if (state.isRegister == true) {
      authenticationRepository.register(email: state.email, password: state.password);
    }
    emit(state.copyWith(isRegister: true));
  }

  void reset() {
    emit(state.copyWith(isLogin: false, isRegister: false));
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }
}
