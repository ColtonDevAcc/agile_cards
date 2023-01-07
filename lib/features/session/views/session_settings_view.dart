import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/pages/primary_textfield.dart';
import 'package:agile_cards/widgets/atoms/participant_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SessionSettingsView extends StatelessWidget {
  const SessionSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final bool isOwner = state.session.owner == context.read<AppBloc>().state.user!.id;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Session Settings'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20, width: double.infinity),
                PrimaryTextField(
                  width: double.infinity,
                  onChanged: isOwner ? (s) => context.read<SessionBloc>().add(SessionNameChanged(s)) : (s) {},
                  suffixIcon: isOwner ? Icons.edit : Icons.lock,
                  title: state.session.name,
                ),
                const SizedBox(height: 20),
                PrimaryTextField(
                  width: double.infinity,
                  onChanged: isOwner ? (s) => context.read<SessionBloc>().add(SessionDescriptionChanged(s)) : (s) {},
                  suffixIcon: isOwner ? Icons.edit : Icons.lock,
                  title: state.session.description,
                ),
                const SizedBox(height: 20),
                if (state.session.participants!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Participants: ${state.session.participants!.length}'),
                      const SizedBox(height: 20),
                      Wrap(
                        children: state.session.participants!
                            .map(
                              (participant) => ParticipantAvatar(
                                participant: participant,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                const Spacer(),
                SafeArea(
                  child: ListTile(
                    title: isOwner ? const Text('Delete Session') : const Text('Leave Session'),
                    trailing: isOwner ? const Icon(Icons.delete) : const Icon(Icons.exit_to_app),
                    onTap: () {
                      context.read<SessionBloc>().add(const SessionLeave());
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
