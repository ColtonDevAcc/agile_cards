import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
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
        final bool isParticipant = state.session.participants?.any((element) => element.id == FirebaseAuth.instance.currentUser?.uid) ?? false;

        return ownerSelection == Selection.empty() || ownerLockedIn || !isParticipant
            ? Expanded(
                flex: 10,
                child: SizedBox(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            for (final Selection selection in state.session.selections ?? [])
                              AgileCard(
                                measurement: sessionMeasurementForUser(
                                  userId: selection.userId,
                                  selections: state.session.selections,
                                  isShirtSizes: state.session.isShirtSizes,
                                ),
                                participant: state.session.participants?.firstWhere(
                                  (element) => element.id == selection.userId,
                                  orElse: () => Participant.empty(),
                                ),
                                isOwnersCard: selection.userId == FirebaseAuth.instance.currentUser?.uid,
                                isRevealed: state.session.cardsRevealed,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }

  String sessionMeasurementForUser({required String? userId, required List<Selection>? selections, required bool? isShirtSizes}) {
    if (userId == null) return '?';
    if (selections == null || selections.isEmpty) return '?';

    if (isShirtSizes == false) {
      final selection = selections.firstWhere((selection) => selection.userId == userId).cardSelected ?? 0;
      return taskSizes.length < selection ? taskSizes.last : taskSizes[selection];
    } else {
      final selection = selections.firstWhere((selection) => selection.userId == userId).cardSelected ?? 0;

      return tShirtSizes.length < selection ? tShirtSizes.last : tShirtSizes[selection];
    }
  }
}
