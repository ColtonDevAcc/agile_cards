import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/features/session/widgets/atoms/participant_avatar_list.dart';
import 'package:flutter/material.dart';

class SessionParticipantView extends StatelessWidget {
  final Session session;
  const SessionParticipantView({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (session.participants != null && session.participants!.isNotEmpty)
            ParticipantAvatarList(
              participants: session.participants!,
              selections: session.selections ?? [],
            ),
          Expanded(
            child: AgileCardSelector(
              selections: session.selections ?? [],
            ),
          ),
        ],
      ),
    );
  }
}
