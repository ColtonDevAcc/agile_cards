import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class ParticipantAvatarList extends StatelessWidget {
  final List<Participant> participants;
  final List<Selection> selections;
  final double? verticalOffset;
  const ParticipantAvatarList({super.key, required this.participants, this.verticalOffset, required this.selections});

  @override
  Widget build(BuildContext context) {
    // participants.isNotEmpty
    return SizedBox(
      height: 100,
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          connectorTheme: const ConnectorThemeData(
            thickness: 3.0,
            color: Color(0xffd3d3d3),
          ),
          indicatorTheme: const IndicatorThemeData(
            size: 15.0,
          ),
        ),
        primary: false,
        builder: TimelineTileBuilder.connected(
          itemCount: participants.length,
          oppositeContentsBuilder: (context, index) {
            final participant = participants[index];
            final selection = selections.singleWhere((element) => element.userId == participant.id, orElse: () => Selection.empty());
            return DotIndicator(
              size: 25,
              child: Center(
                child: Text(
                  '${selection.cardSelected}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
