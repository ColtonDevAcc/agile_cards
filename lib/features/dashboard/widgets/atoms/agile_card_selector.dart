import 'package:agile_cards/app/models/selection_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class AgileCardSelector extends StatelessWidget {
  const AgileCardSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final List<Selection> selections = state.session.selections ?? [];
        final Selection userSelection = selections.firstWhere(
          (element) => element.userId == context.read<AppBloc>().state.user!.id,
          orElse: () => Selection.empty(),
        );

        return userSelection == Selection.empty()
            ? StackedCardCarousel(
                spaceBetweenItems: 200,
                items: [
                  for (final shirt in tShirtSizes)
                    GestureDetector(
                      onTap: () {
                        context.read<SessionBloc>().add(
                              SessionAgileCardSelected(
                                Selection(
                                  cardSelected: tShirtSizes.indexOf(shirt),
                                  userId: context.read<AppBloc>().state.user!.id,
                                ),
                              ),
                            );
                      },
                      child: AgileCard(shirt: shirt),
                    ),
                ],
              )
            : Center(
                child: Column(
                  children: [
                    AgileCard(
                      shirt: tShirtSizes[userSelection.cardSelected],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => context.read<SessionBloc>().add(const SessionAgileCardDeselected()),
                      child: const Text('change selection'),
                    )
                  ],
                ),
              );
      },
    );
  }
}

class AgileCard extends StatelessWidget {
  const AgileCard({
    Key? key,
    required this.shirt,
  }) : super(key: key);

  final String shirt;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 200,
        child: Text(shirt),
      ),
    );
  }
}
