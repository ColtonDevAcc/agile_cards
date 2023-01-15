import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/session/widgets/atoms/flip_card_front.dart';
import 'package:agile_cards/features/session/widgets/molecules/participant_card_selection_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class AgileCardSelector extends StatelessWidget {
  const AgileCardSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final Selection userSelection = state.session.selections!
            .firstWhere((element) => element.userId == FirebaseAuth.instance.currentUser?.uid, orElse: () => Selection.empty());
        final bool isParticipant = state.session.participants!.any((element) => element.id == FirebaseAuth.instance.currentUser?.uid);

        final bool isShirtSizes = context.read<SessionBloc>().state.session.isShirtSizes ?? true;
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              if (userSelection.lockedIn == false && isParticipant)
                Expanded(
                  child: StackedCardCarousel(
                    spaceBetweenItems: 200,
                    pageController: PageController(viewportFraction: 0.5, initialPage: userSelection.cardSelected ?? 0),
                    items: [
                      for (final selection in isShirtSizes ? tShirtSizes : taskSizes)
                        GestureDetector(
                          onTap: () {
                            context.read<SessionBloc>().add(
                                  SessionUpdateAgileCard(
                                    Selection(
                                      cardSelected: isShirtSizes ? tShirtSizes.indexOf(selection) : taskSizes.indexOf(selection),
                                      userId: context.read<AppBloc>().state.user!.id,
                                      lockedIn: true,
                                    ),
                                  ),
                                );
                          },
                          child: FlipCardFront(measurement: selection),
                        ),
                    ],
                  ),
                ),
              if (context.read<SessionBloc>().state.session.cardsRevealed != true && isParticipant)
                TextButton(
                  onPressed: () => context.read<SessionBloc>().add(
                        SessionUpdateAgileCard(
                          Selection(
                            cardSelected: userSelection.cardSelected,
                            userId: context.read<AppBloc>().state.user!.id,
                            lockedIn: false,
                          ),
                        ),
                      ),
                  child: const Text('change selection'),
                ),
            ],
          ),
        );
      },
    );
  }
}
