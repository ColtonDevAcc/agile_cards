import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/pages/session_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionOwnerView extends StatelessWidget {
  final Session session;
  const SessionOwnerView({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Selection> selections = session.selections ?? [];
    final int notLockedInCount = selections.where((element) => !element.lockedIn).length;
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Waiting for $notLockedInCount participants'),
          ),
          const SizedBox(height: 20),
          // ParticipantAvatarList(
          //   verticalOffset: 0,
          //   participants: session.participants ?? [],
          //   selections: selections,
          // ),
          Wrap(
            children: [
              for (final selection in session.selections ?? [])
                AgileCard(
                  shirt: tShirtSizes[selection.cardSelected],
                  participant: session.participants?.singleWhere(
                    (element) => element.id == selection.userId,
                    orElse: () => Participant.empty(),
                  ),
                ),
            ],
          ),
          if (session.participants?.contains(context.read<AppBloc>().state.user) ?? false)
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('selected'),
                  ),
                  Expanded(
                    child: AgileCardSelector(
                      selections: session.selections ?? [],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
