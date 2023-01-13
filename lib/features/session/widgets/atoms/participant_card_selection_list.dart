import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card.dart';
import 'package:flutter/material.dart';

class ParticipantCardSelectionList extends StatelessWidget {
  const ParticipantCardSelectionList({
    Key? key,
    required this.session,
    required this.cardsRevealed,
  }) : super(key: key);

  final Session session;
  final bool cardsRevealed;

  @override
  Widget build(BuildContext context) {
    final List<Selection> selections = session.selections ?? [];

    return Wrap(
      children: [
        for (final selection in selections)
          AgileCard(
            reveal: cardsRevealed == true,
            measurement: session.sessionMeasurementAverage,
            participant: session.participants?.singleWhere(
              (element) => element.id == selection.userId,
              orElse: () => Participant.empty(),
            ),
          ),
      ],
    );
  }
}
