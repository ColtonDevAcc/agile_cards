import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/widgets/atoms/participant_avatar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class FlipCardFront extends StatelessWidget {
  final Participant? participant;
  final String measurement;
  const FlipCardFront({super.key, this.participant, required this.measurement});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.45,
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
              child: AutoSizeText(
                measurement,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                maxFontSize: 30,
                minFontSize: 20,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
