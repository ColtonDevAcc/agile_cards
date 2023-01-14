import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/repositories/session_repository.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class AgileCardSelector extends StatelessWidget {
  const AgileCardSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final Map<String, Selection> userSelection = state.session.selections?.singleWhere(
              (element) => element.values.single.userId == context.read<AppBloc>().state.user!.id,
              orElse: () => {'': Selection.empty()},
            ) ??
            {'': Selection.empty()};
        final bool isShirtSizes = context.read<SessionBloc>().state.session.isShirtSizes ?? true;
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              if (userSelection.values.single.lockedIn == false)
                Expanded(
                  child: StackedCardCarousel(
                    spaceBetweenItems: 200,
                    pageController: PageController(viewportFraction: 0.5, initialPage: userSelection.values.single.cardSelected ?? 0),
                    items: [
                      for (final selection in isShirtSizes ? tShirtSizes : taskSizes)
                        GestureDetector(
                          onTap: () {
                            context.read<SessionBloc>().add(
                                  SessionAgileCardSelected(
                                    Selection(
                                      cardSelected: isShirtSizes ? tShirtSizes.indexOf(selection) : taskSizes.indexOf(selection),
                                      userId: context.read<AppBloc>().state.user!.id,
                                      lockedIn: true,
                                    ),
                                  ),
                                );
                          },
                          child: AgileCard(measurement: selection),
                        ),
                    ],
                  ),
                ),
              if (context.read<SessionBloc>().state.session.cardsRevealed != true)
                TextButton(
                  onPressed: () => context.read<SessionBloc>().add(const SessionAgileCardDeselected()),
                  child: const Text('change selection'),
                ),
            ],
          ),
        );
      },
    );
  }
}
