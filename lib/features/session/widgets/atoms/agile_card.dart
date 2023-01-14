import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/features/session/widgets/atoms/flip_card_front.dart';
import 'package:flutter/material.dart';

class AgileCard extends StatelessWidget {
  final Participant? participant;
  final bool? isOwnersCard;
  final String measurement;
  final bool? isRevealed;
  final Function(AnimationController)? cardController;

  const AgileCard({Key? key, required this.measurement, this.participant, this.cardController, this.isOwnersCard, this.isRevealed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isRevealed == true
        ? FlipCardFront(participant: participant, measurement: measurement)
        : FlipCardFront(measurement: '?', participant: participant);
  }
}
