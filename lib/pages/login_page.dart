import 'package:agile_cards/features/login/cubit/login_cubit.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: const Text('Agile Cards'),
                expandedHeight: MediaQuery.of(context).size.height * 0.5,
                flexibleSpace: Stack(
                  children: [
                    Positioned(
                      bottom: -1,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!state.isLogin && !state.isRegister)
                      Positioned(
                        top: 70,
                        child: PrimaryButton(
                          title: 'Get Started',
                          onPressed: () {
                            context.read<LoginCubit>().register();
                          },
                        ),
                      ),
                    if (state.isLogin || state.isRegister)
                      Positioned(
                        top: 5,
                        child: AnimatedOpacity(
                          opacity: state.isLogin || state.isRegister ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: AutofillGroup(
                            child: Column(
                              children: [
                                PrimaryTextField(
                                  title: 'Email',
                                  onPressed: (v) => context.read<LoginCubit>().emailChanged(v),
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                ),
                                const SizedBox(height: 10),
                                PrimaryTextField(
                                  title: 'Password',
                                  onPressed: (v) => context.read<LoginCubit>().passwordChanged(v),
                                  obscureText: true,
                                  autofillHints: const [AutofillHints.password],
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      top: state.isLogin || state.isRegister ? MediaQuery.of(context).size.height * 0.155 : MediaQuery.of(context).size.height * 0.15,
                      child: PrimaryButton(
                        title: !state.isLogin && !state.isRegister
                            ? 'Login'
                            : state.isLogin
                                ? 'Login'
                                : 'Register',
                        onPressed: () {
                          if (!state.isLogin && !state.isRegister) {
                            context.read<LoginCubit>().login();
                          } else if (state.isLogin) {
                            context.read<LoginCubit>().login();
                          } else {
                            context.read<LoginCubit>().register();
                          }
                        },
                        outlined: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: AutoSizeText.rich(
                          TextSpan(
                            text: 'By continuing, you agree to our\n',
                            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          maxFontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PrimaryTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? title;
  final TextInputType? keyboardType;
  final Function(String)? onPressed;
  final Iterable<String>? autofillHints;
  final bool? obscureText;
  const PrimaryTextField({
    super.key,
    required this.onPressed,
    this.hintText,
    this.labelText,
    this.title,
    this.autofillHints,
    this.keyboardType,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        onChanged: onPressed,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
