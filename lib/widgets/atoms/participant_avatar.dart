import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipantAvatar extends StatelessWidget {
  final Participant? participant;
  final VoidCallback? onTap;
  final bool? isLockedIn;
  const ParticipantAvatar({Key? key, this.participant, this.onTap, this.isLockedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final user = context.read<AppBloc>().state.user;

        return GestureDetector(
          onTap: () => onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: participant == null ? Text(user?.email?.characters.first ?? '??') : Text(participant?.email?.characters.first ?? '??'),
                ),
                if (isLockedIn != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      isLockedIn ?? false ? Icons.check : Icons.close,
                      color: isLockedIn ?? false ? Colors.green : Colors.red,
                      size: 20,
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
