import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/features/session/widgets/atoms/flip_card_button.dart';
import 'package:agile_cards/features/session/widgets/atoms/waiting_for_participant.dart';
import 'package:agile_cards/features/session/widgets/molecules/participant_card_selection_list.dart';
import 'package:flutter/material.dart';

class SessionOwnerView extends StatelessWidget {
  const SessionOwnerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        WaitingForParticipant(),
        FlipCardButton(),
        SizedBox(height: 20),
        ParticipantCardSelectionList(),
        AgileCardSelector(),
      ],
    );
  }
}
