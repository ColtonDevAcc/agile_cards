import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/features/login/cubit/login_cubit.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/pages/primary_textfield.dart';
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
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      if (!state.isLogin && !state.isRegister)
                        PrimaryButton(
                          title: 'Get Started',
                          onPressed: () {
                            context.read<LoginCubit>().register();
                          },
                        ),
                      if (state.isLogin || state.isRegister)
                        AnimatedOpacity(
                          opacity: state.isLogin || state.isRegister ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: AutofillGroup(
                            child: Column(
                              children: [
                                PrimaryTextField(
                                  title: 'Email',
                                  onChanged: (v) => context.read<LoginCubit>().emailChanged(v),
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                ),
                                const SizedBox(height: 10),
                                PrimaryTextField(
                                  title: 'Password',
                                  onChanged: (v) => context.read<LoginCubit>().passwordChanged(v),
                                  obscureText: true,
                                  autofillHints: const [AutofillHints.password],
                                  keyboardType: TextInputType.visiblePassword,
                                ),
                              ],
                            ),
                          ),
                        ),
                      PrimaryButton(
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
                      if (state.isLogin || state.isRegister)
                        GestureDetector(
                          onTap: () {
                            context.read<LoginCubit>().reset();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'back',
                              style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      const Spacer(),
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
