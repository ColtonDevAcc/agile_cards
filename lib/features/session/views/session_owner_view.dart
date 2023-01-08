import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionOwnerView extends StatelessWidget {
  final Session session;
  const SessionOwnerView({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Selection> selections = session.selections ?? [];
    final int notLockedInCount = selections.where((element) => !element.lockedIn!).length;
    final Selection ownerSelection = selections.firstWhere((element) => element.userId == session.owner, orElse: () => Selection.empty());
    final bool isShirtSizes = session.isShirtSizes ?? true;
    final int sessionAverage = session.selections?.map((e) => e.cardSelected).reduce((value, element) => value! + element!) ?? 0;
    final String sessionAverageString = const Session().sessionMeasurementAverage(average: sessionAverage, shirtSizes: isShirtSizes);
    final bool cardsRevealed = session.cardsRevealed ?? false;
    String measurementSize(int size) {
      if (isShirtSizes) {
        final length = tShirtSizes.length;
        return tShirtSizes[size > length ? length - 1 : size];
      } else {
        final length = taskSizes.length;
        return taskSizes[size > length ? length - 1 : size];
      }
    }

    return Expanded(
      child: Column(
        children: [
          if (notLockedInCount != 0)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Waiting for $notLockedInCount participants'),
            ),
          if (notLockedInCount == 0 && cardsRevealed == true)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('average score is $sessionAverageString'),
            ),
          if (notLockedInCount == 0 && selections.isNotEmpty)
            PrimaryButton(
              title: cardsRevealed == false ? 'Reveal' : 'Hide',
              onPressed: () {
                // ignore: avoid_bool_literals_in_conditional_expressions
                final bool reveal = cardsRevealed == false ? true : false;
                context.read<SessionBloc>().add(SessionRevealCards(reveal: reveal));
              },
            ),
          const SizedBox(height: 20),
          if (ownerSelection == Selection.empty() || ownerSelection.lockedIn!)
            Wrap(
              children: [
                for (final selection in session.selections ?? [])
                  AgileCard(
                    reveal: cardsRevealed == true,
                    measurement: measurementSize(selection.cardSelected),
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(ownerSelection.lockedIn! ? 'you selected' : 'select your card'),
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
