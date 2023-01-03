part of 'login_cubit.dart';

class LoginState extends Equatable {
  final bool isLogin;
  final bool isRegister;
  final String email;
  final String password;
  const LoginState({required this.email, required this.password, required this.isRegister, required this.isLogin});

  @override
  List<Object> get props => [isLogin, isRegister, email, password];

  //copy with factory
  LoginState copyWith({
    bool? isLogin,
    bool? isRegister,
    String? email,
    String? password,
  }) {
    return LoginState(
      isLogin: isLogin ?? this.isLogin,
      isRegister: isRegister ?? this.isRegister,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
