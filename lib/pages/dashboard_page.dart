import 'dart:developer';

import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/dashboard/widgets/molecules/session_search.dart';
import 'package:agile_cards/features/dashboard/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/features/dashboard/widgets/atoms/participant_avatar_list.dart';
import 'package:agile_cards/widgets/atoms/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clipboard/clipboard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                  child: isOwner ? const Icon(Icons.send) : const Icon(Icons.add),
                )
              : const SizedBox();
        },
      ),
      appBar: AppBar(
        leading: const SearchButton(),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Center(child: Text('No session')),
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
                            final bool isOwner = context.read<SessionBloc>().state.session.owner == context.read<AppBloc>().state.user?.id;
                            log('isOwner: $isOwner');

                            return isOwner ? SizedBox.fromSize() : const AgileCardSelector();
                          },
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
