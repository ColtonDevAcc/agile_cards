import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/pages/primary_textfield.dart';
import 'package:agile_cards/widgets/atoms/participant_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SessionSettingsView extends StatelessWidget {
  const SessionSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final bool isOwner = state.session.owner == context.read<AppBloc>().state.user?.id;
        final bool isParticipant = state.session.participants?.any((p) => p.id == context.read<AppBloc>().state.user?.id) ?? false;
        final List<Participant> participants = state.session.participants ?? [];
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
                  onChanged: isOwner ? (s) => context.read<SessionBloc>().add(SessionNameChanged(s ?? '')) : (s) {},
                  suffixIcon: isOwner ? Icons.edit : Icons.lock,
                  title: state.session.name,
                ),
                const SizedBox(height: 20),
                PrimaryTextField(
                  width: double.infinity,
                  onChanged: isOwner ? (s) => context.read<SessionBloc>().add(SessionDescriptionChanged(s ?? '')) : (s) {},
                  suffixIcon: isOwner ? Icons.edit : Icons.lock,
                  title: state.session.description,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (participants.isNotEmpty) Text('Participants: ${state.session.participants!.length}'),
                    const SizedBox(height: 20),
                    if (participants.isNotEmpty)
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
                if (isOwner)
                  ListTile(
                    title: const Text('switch measurement'),
                    trailing: state.session.isShirtSizes ?? true ? const FaIcon(FontAwesomeIcons.shirt) : const FaIcon(FontAwesomeIcons.x),
                    onTap: () {
                      final bool isShirtSizes = state.session.isShirtSizes ?? true;
                      // ignore: avoid_bool_literals_in_conditional_expressions
                      context.read<SessionBloc>().add(SessionToggleUseShirtSizes(useShirtSizes: isShirtSizes ? false : true));
                    },
                  ),
                if (isOwner)
                  ListTile(
                    title: const Text('Participate in Session'),
                    trailing: isParticipant
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : const Icon(Icons.add),
                    onTap: () {
                      final Participant user = context.read<AppBloc>().state.user!;
                      if (isParticipant) {
                        context.read<SessionBloc>().add(SessionForceParticipantRemoved(user));
                      } else {
                        context.read<SessionBloc>().add(SessionForceParticipantAdded(user));
                      }
                    },
                  ),
                ListTile(
                  title: const Text('Copy Session Link'),
                  trailing: const Icon(Icons.copy),
                  onTap: () => Clipboard.setData(ClipboardData(text: 'https://agilecards.app/session/${state.session.id}')),
                ),
                SafeArea(
                  child: ListTile(
                    title: isOwner ? const Text('Delete Session') : const Text('Leave Session'),
                    trailing: isOwner ? const Icon(Icons.delete) : const Icon(Icons.exit_to_app),
                    onTap: () {
                      isOwner ? context.read<SessionBloc>().add(const SessionDeleted()) : context.read<SessionBloc>().add(const SessionLeave());
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
