import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/features/session/widgets/atoms/participant_card_selection_list.dart';
import 'package:agile_cards/features/session/widgets/atoms/session_average_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionOwnerView extends StatelessWidget {
  final Session session;
  const SessionOwnerView({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Selection> selections = session.selections ?? [];
    final int notLockedInCount = session.selectionsNotLockedIn;
    final Selection ownerSelection = selections.firstWhere((element) => element.userId == session.owner, orElse: () => Selection.empty());
    final bool cardsRevealed = session.cardsRevealed ?? false;
    final bool ownerLockedIn = ownerSelection.lockedIn ?? false;

    return Column(
      children: [
        if (notLockedInCount != 0)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Waiting for $notLockedInCount participants'),
          ),
        if (notLockedInCount == 0 && cardsRevealed == true) SessionAverageText(sessionMeasurementAverage: session.sessionMeasurementAverage),
        if (notLockedInCount == 0 && selections.isNotEmpty)
          PrimaryButton(
            title: cardsRevealed == false ? 'Reveal' : 'Hide',
            onPressed: () {
              // ignore: avoid_bool_literals_in_conditional_expressions
              context.read<SessionBloc>().add(SessionRevealCards(reveal: cardsRevealed == false ? true : false));
            },
          ),
        const SizedBox(height: 20),
        if (ownerSelection == Selection.empty() || ownerLockedIn) ParticipantCardSelectionList(session: session, cardsRevealed: cardsRevealed),
        if (session.participants?.contains(context.read<AppBloc>().state.user) ?? false)
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(ownerLockedIn ? 'you selected' : 'select your card'),
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
    );
  }
}
