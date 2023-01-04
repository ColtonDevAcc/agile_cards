import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/dashboard/widgets/atoms/participant_avatar_list.dart';
import 'package:agile_cards/widgets/atoms/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clipboard/clipboard.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<SessionBloc>().add(SessionCreated(context.read<AppBloc>().state.user!)),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                context.read<SessionBloc>().add(SessionUpdated(session: state.session.copyWith(description: 'updated')));
              },
            );
          },
        ),
        actions: const [
          UserAvatar(),
        ],
        title: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () async => FlutterClipboard.copy(state.session.id),
              child: Text(state.session.id),
            );
          },
        ),
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state.session == Session.empty())
                const Center(child: Text('No session'))
              else if (state.session.owner! == context.read<AppBloc>().state.user?.id)
                Expanded(
                  child: Column(
                    children: [
                      BlocBuilder<SessionBloc, SessionState>(
                        builder: (context, state) {
                          return state.session.participants != null
                              ? ParticipantAvatarList(participants: state.session.participants!)
                              : const SizedBox();
                        },
                      ),
                      Expanded(
                        child: StackedCardCarousel(
                          spaceBetweenItems: 200,
                          items: [
                            for (final shirt in tShirtSizes)
                              Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 200,
                                  height: 200,
                                  child: Text(shirt),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

const List<String> tShirtSizes = [
  'XS',
  'S',
  'M',
  'L',
  'XL',
  'XXL',
  'XXXL',
];

const List<String> taskSizes = [
  '1',
  '2',
  '3',
  '5',
  '8',
  '13',
  '20',
  '40',
  '100',
  '∞',
];
