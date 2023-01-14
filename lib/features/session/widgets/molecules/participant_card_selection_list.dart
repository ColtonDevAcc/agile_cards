import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/session/cubits/agile_card/agile_card_cubit.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

class ParticipantCardSelectionList extends StatelessWidget {
  const ParticipantCardSelectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        context.read<AgileCardCubit>().setReveal(reveal: state.session.cardsRevealed == true);
        final ownerSelection = state.session.selections?.singleWhere(
          (element) => element.values.single.userId == state.session.owner,
          orElse: () => {'': Selection.empty()},
        );
        final ownerLockedIn = ownerSelection?.values.single.lockedIn == true;

        final List<Map<String, Selection>> selections = state.session.selections ?? [];
        return ownerSelection == {"": Selection.empty()} || ownerLockedIn
            ? Wrap(
                children: [
                  for (final selection in selections)
                    BlocBuilder<AgileCardCubit, AgileCardState>(
                      builder: (context, cardState) {
                        return AgileCard(
                          cardKey: cardKey,
                          measurement: state.session.sessionMeasurementAverage,
                          participant: state.session.participants?.singleWhere(
                            (element) => element.id == selection.values.single.userId,
                            orElse: () => Participant.empty(),
                          ),
                          controller: cardState.controller,
                        );
                      },
                    ),
                ],
              )
            : const SizedBox();
      },
    );
  }
}
