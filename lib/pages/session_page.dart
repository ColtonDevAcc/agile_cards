import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/features/session/widgets/atoms/participant_avatar_list.dart';
import 'package:agile_cards/features/session/widgets/molecules/session_search.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/widgets/atoms/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clipboard/clipboard.dart';
import 'package:go_router/go_router.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          final isOwner = state.session.owner == context.read<AppBloc>().state.user?.id;
          final isEmpty = state.session == Session.empty();

          return isEmpty || isOwner
              ? FloatingActionButton(
                  onPressed: () => isEmpty ? context.read<SessionBloc>().add(SessionCreated(context.read<AppBloc>().state.user!)) : {},
                  child: isOwner ? const Icon(Icons.send) : const SearchButton(),
                )
              : const SizedBox();
        },
      ),
      appBar: AppBar(
        leading: const UserAvatar(),
        actions: [
          GestureDetector(
            child: const Icon(Icons.more_vert),
            onTap: () => context.pushNamed('session_settings_page'),
          ),
        ],
        title: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            return GestureDetector(onTap: () async => FlutterClipboard.copy(state.session.id), child: Text(state.session.id));
          },
        ),
      ),
      body: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: state.session == Session.empty() ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              if (state.session == Session.empty())
                Center(
                  child: PrimaryButton(
                    title: 'Create Session',
                    onPressed: () => context.read<SessionBloc>().add(SessionCreated(context.read<AppBloc>().state.user!)),
                  ),
                )
              else if (state.session.owner! != context.read<AppBloc>().state.user?.id)
                Expanded(
                  child: Column(
                    children: [
                      BlocBuilder<SessionBloc, SessionState>(
                        builder: (context, state) {
                          return state.session.participants != null
                              ? ParticipantAvatarList(participants: state.session.participants!, paddingOffset: 30)
                              : const SizedBox();
                        },
                      ),
                      Expanded(
                        child: BlocBuilder<SessionBloc, SessionState>(
                          builder: (context, state) {
                            return const AgileCardSelector();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Center(child: Text('Selected')),
                    const SizedBox(height: 20),
                    Wrap(
                      children: [
                        for (final selection in state.session.selections ?? [])
                          AgileCard(
                            shirt: tShirtSizes[selection.cardSelected],
                            participant: state.session.participants?.singleWhere(
                              (element) => element.id == selection.userId,
                              orElse: () => Participant.empty(),
                            ),
                          ),
                      ],
                    ),
                  ],
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
