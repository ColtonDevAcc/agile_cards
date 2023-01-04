import 'package:agile_cards/app/repositories/authentication_repository.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StateProviders extends StatelessWidget {
  final Widget child;

  const StateProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthenticationRepository()),
        RepositoryProvider(create: (context) => SessionRepository()..listenForSessions(null)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (BuildContext context) =>
                AppBloc(authenticationRepository: context.read<AuthenticationRepository>())..add(AuthenticationPersistRequested()),
          ),
          BlocProvider<LoginCubit>(
            create: (BuildContext context) => LoginCubit(authenticationRepository: context.read<AuthenticationRepository>()),
          ),
          BlocProvider<SessionBloc>(
            create: (BuildContext context) => SessionBloc(sessionRepository: context.read<SessionRepository>()),
          ),
        ],
        child: child,
      ),
    );
  }
}
