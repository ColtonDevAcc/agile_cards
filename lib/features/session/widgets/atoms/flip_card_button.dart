import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlipCardButton extends StatelessWidget {
  const FlipCardButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final bool isParticipating = state.session.participants?.any((element) => element.id == FirebaseAuth.instance.currentUser?.uid) ?? false;
        final bool cardsRevealed = state.session.cardsRevealed ?? false;
        final bool? ownerCardLockedIn = state.session.selections?.any((element) {
          return element.userId == FirebaseAuth.instance.currentUser?.uid && element.lockedIn == true;
        });
        final bool sessionEmpty = state.session.participants != null && state.session.participants!.isEmpty;

        return !sessionEmpty && !isParticipating || (ownerCardLockedIn ?? false)
            ? PrimaryButton(
                title: cardsRevealed == false ? 'Reveal' : 'Hide',
                onPressed: () {
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  context.read<SessionBloc>().add(SessionToggleRevealCards(reveal: cardsRevealed == false ? true : false));
                },
              )
            : isParticipating && (ownerCardLockedIn ?? false) == false
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Your session is not ready yet. Please wait for your participants to join.", textAlign: TextAlign.center),
                  );
      },
    );
  }
}
