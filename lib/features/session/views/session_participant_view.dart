import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/features/session/widgets/atoms/waiting_for_participant.dart';
import 'package:agile_cards/features/session/widgets/molecules/participant_card_selection_list.dart';
import 'package:flutter/material.dart';

class SessionParticipantView extends StatelessWidget {
  const SessionParticipantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final isShirtSizes = session.isShirtSizes ?? true;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: const [
          WaitingForParticipant(),
          ParticipantCardSelectionList(),
          AgileCardSelector(),
        ],
      ),
    );
  }
}
