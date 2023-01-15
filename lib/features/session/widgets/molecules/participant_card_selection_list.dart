import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipantCardSelectionList extends StatelessWidget {
  const ParticipantCardSelectionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final ownerSelection = state.session.selections
            ?.firstWhere((element) => element.userId == FirebaseAuth.instance.currentUser?.uid, orElse: () => Selection.empty());
        final ownerLockedIn = ownerSelection?.lockedIn == true;

        return ownerSelection == Selection.empty() || ownerLockedIn
            ? Wrap(
                children: [
                  for (final selection in state.session.selections ?? [])
                    AgileCard(
                      measurement: state.session.sessionMeasurementAverage,
                      participant: state.session.participants?.firstWhere((element) => element.id == selection.userId),
                      isOwnersCard: selection.userId == FirebaseAuth.instance.currentUser?.uid,
                      isRevealed: state.session.cardsRevealed,
                    ),
                ],
              )
            : const SizedBox();
      },
    );
  }
}
