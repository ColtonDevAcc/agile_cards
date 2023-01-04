import 'package:agile_cards/app/models/participant_model.dart';
import 'package:flutter/material.dart';

class ParticipantAvatarList extends StatelessWidget {
  final List<Participant> participants;
  const ParticipantAvatarList({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final participant in participants)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text('${participant.email?.characters.first}'),
            ),
          ),
      ],
    );
  }
}
