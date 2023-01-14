import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
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
        final bool cardsRevealed = state.session.cardsRevealed ?? false;
        final bool? ownerCardLockedIn = state.session.selections?.any((element) {
          return element.keys.single == context.read<AppBloc>().state.user!.id && element.values.single.lockedIn == true;
        });

        return ownerCardLockedIn == null || ownerCardLockedIn
            ? PrimaryButton(
                title: cardsRevealed == false ? 'Reveal' : 'Hide',
                onPressed: () {
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  context.read<SessionBloc>().add(SessionRevealCards(reveal: cardsRevealed == false ? true : false));
                },
              )
            : const SizedBox();
      },
    );
  }
}
