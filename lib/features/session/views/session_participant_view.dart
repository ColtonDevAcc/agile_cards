import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:flutter/material.dart';

class SessionParticipantView extends StatelessWidget {
  final Session session;
  const SessionParticipantView({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int notLockedInCount = session.selections?.where((element) => !element.lockedIn).length ?? 0;

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Waiting for $notLockedInCount participants'),
          ),
          if (session.cardsRevealed == false || session.cardsRevealed == null)
            Expanded(
              child: AgileCardSelector(
                selections: session.selections ?? [],
              ),
            )
          else
            Wrap(
              children: [
                for (final selection in session.selections ?? [])
                  AgileCard(
                    reveal: true,
                    shirt: tShirtSizes[selection.cardSelected],
                    participant: session.participants?.singleWhere(
                      (element) => element.id == selection.userId,
                      orElse: () => Participant.empty(),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
