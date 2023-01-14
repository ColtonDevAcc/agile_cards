import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:flutter/material.dart';

class SessionParticipantView extends StatelessWidget {
  final Session session;
  const SessionParticipantView({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isShirtSizes = session.isShirtSizes ?? true;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            session.cardsRevealed != true
                ? 'Waiting for ${session.selectionsNotLockedIn} participants'
                : 'average score is ${session.sessionMeasurementAverage}',
          ),
        ),
        if (session.cardsRevealed == false || session.cardsRevealed == null)
          const Expanded(child: AgileCardSelector())
        else
          Wrap(
            children: [
              for (final selection in session.selections ?? [])
                AgileCard(
                  measurement: isShirtSizes ? tShirtSizes[selection.cardSelected] : taskSizes[selection.cardSelected],
                  participant: session.participants?.singleWhere(
                    (element) => element.id == selection.userId,
                    orElse: () => Participant.empty(),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
