import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/widgets/atoms/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    return Scaffold(
      appBar: AppBar(title: Text(user?.email ?? '')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            UserAvatar(
              radius: 50,
              onTap: () => context.read<AppBloc>().add(const ChangeUserAvatar()),
            ),
            const SizedBox(height: 20),
            Text(user?.email ?? ''),
            const SizedBox(height: 20),
            Text(user?.id ?? ''),
            const Spacer(),
            SafeArea(
              child: ListTile(
                title: const Text('logout'),
                trailing: const Icon(Icons.exit_to_app),
                onTap: () {
                  context.read<SessionBloc>().add(const SessionLeave());
                  context.read<AppBloc>().add(AuthenticationLogoutRequested());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
