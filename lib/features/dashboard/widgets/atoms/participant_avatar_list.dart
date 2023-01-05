import 'dart:developer';

import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/widgets/atoms/user_avatar.dart';
import 'package:flutter/material.dart';

class ParticipantAvatarList extends StatelessWidget {
  final List<Participant> participants;
  final double? verticalOffset;
  final double? paddingOffset;
  const ParticipantAvatarList({super.key, required this.participants, required this.paddingOffset, this.verticalOffset});

  @override
  Widget build(BuildContext context) {
    final List<Participant> part = participants;
    part.add(participants.first);
    part.add(participants.first);
    part.add(participants.first);
    part.add(participants.first);

    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalOffset ?? 10.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          // ignore: unnecessary_null_comparison
          children: participants != null
              ? participants.map((participant) {
                  return Positioned(
                    left: size.width / 2 - 25 + (paddingOffset! * participants.indexOf(participant)),
                    child: const UserAvatar(),
                  );
                }).toList()
              : const [],
        ),
      ),
    );
  }
}
