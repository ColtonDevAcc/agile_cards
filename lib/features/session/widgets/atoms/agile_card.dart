import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/widgets/atoms/participant_avatar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AgileCard extends StatelessWidget {
  final Participant? participant;
  final bool? reveal;
  const AgileCard({Key? key, required this.measurement, this.participant, this.reveal}) : super(key: key);
  final String measurement;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        width: 200,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (participant != null && participant != Participant.empty())
              Column(
                children: [
                  Center(child: ParticipantAvatar(participant: participant)),
                  const SizedBox(width: 8),
                  AutoSizeText(
                    participant?.name != null && participant!.name!.isNotEmpty ? participant!.name! : participant!.email!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            const Spacer(),
            Center(
              child: Text(
                reveal == null
                    ? measurement
                    : reveal == true
                        ? measurement
                        : '?',
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
