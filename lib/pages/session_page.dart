import 'package:agile_cards/app/services/dynamic_linking.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/session/views/session_owner_view.dart';
import 'package:agile_cards/features/session/views/session_participant_view.dart';
import 'package:agile_cards/features/session/widgets/atoms/create_session_bottom_sheet.dart';
import 'package:agile_cards/features/session/widgets/atoms/session_floating_action_button.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/main.dart';
import 'package:agile_cards/widgets/atoms/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class SessionPage extends StatelessWidget {
  const SessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    locator<DynamicLinkService>().listenForLinks(context);

    return Scaffold(
      floatingActionButton: const SessionFloatingActionButton(),
      appBar: AppBar(
        leading: const UserAvatar(),
        actions: [
          GestureDetector(child: const Icon(Icons.more_vert), onTap: () => context.pushNamed('session_settings_page')),
        ],
        title: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () async => FlutterClipboard.copy(state.session.id!).then(
                (value) => Fluttertoast.showToast(msg: 'Session ID copied to clipboard'),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.session.name ?? 'unnamed'),
                  const Icon(Icons.copy, size: 12, color: Colors.white),
                ],
              ),
            );
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: BlocBuilder<SessionBloc, SessionState>(
              builder: (context, state) {
                if (state.session.owner == context.read<AppBloc>().state.user?.id) {
                  return const SessionOwnerView();
                } else if (state.session.participants?.any((p) => p.id == context.read<AppBloc>().state.user?.id) ?? false) {
                  return const SessionParticipantView();
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('You are not apart of a session'),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => const CreateSessionBottomSheet(),
                            // shape: const RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.only(
                            //     topLeft: Radius.circular(20),
                            //     topRight: Radius.circular(20),
                            //   ),
                            // ),
                          ),
                          title: 'Create a session',
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
