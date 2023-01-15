import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/features/session/widgets/molecules/participant_card_selection_list.dart';
import 'package:flutter/material.dart';

class SessionParticipantView extends StatelessWidget {
  final Session session;
  const SessionParticipantView({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isShirtSizes = session.isShirtSizes ?? true;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              session.cardsRevealed != true
                  ? 'Waiting for ${session.selectionsNotLockedIn} participants'
                  : 'average score is ${session.sessionMeasurementAverage}',
            ),
          ),
          const ParticipantCardSelectionList(),
          const Expanded(child: AgileCardSelector()),
        ],
      ),
    );
  }
}
