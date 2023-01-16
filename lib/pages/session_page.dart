import 'dart:developer';

import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/services/dynamic_linking.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/session/views/session_owner_view.dart';
import 'package:agile_cards/features/session/views/session_participant_view.dart';
import 'package:agile_cards/features/session/widgets/atoms/session_floating_action_button.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/main.dart';
import 'package:agile_cards/pages/primary_textfield.dart';
import 'package:agile_cards/widgets/atoms/user_avatar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
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

class CreateSessionBottomSheet extends StatelessWidget {
  const CreateSessionBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: FormBuilder(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              const AutoSizeText('Create a session'),
              const SizedBox(height: 20),
              const PrimaryTextField(
                hintText: 'Session name',
              ),
              FormBuilderCheckbox(
                name: 'participate',
                initialValue: true,
                title: const AutoSizeText('Participate in session'),
                subtitle: const AutoSizeText('You will be added as a participant to the session'),
              ),
              FormBuilderCheckbox(
                name: 'lock session',
                initialValue: false,
                subtitle: const AutoSizeText('Locking a session will prevent anyone from joining through a public link'),
                title: const AutoSizeText('lock session'),
              ),
              FormBuilderCheckbox(
                initialValue: false,
                name: 'tShirt sizes',
                subtitle: const AutoSizeText('T-Shirt sizes will be used to estimate the size of a task'),
                title: const AutoSizeText('T-Shirt sizes'),
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () {
                  final User user = FirebaseAuth.instance.currentUser!;
                  log('creating session with name: ${formKey.currentState?.fields['name']?.value ?? 'unnamed'}');
                  context.read<SessionBloc>().add(
                        SessionCreated(
                          Session(
                            id: user.uid,
                            name: formKey.currentState?.fields['Session name']?.value ?? 'unnamed',
                            isShirtSizes: formKey.currentState?.fields['tShirt sizes']?.value ?? false,
                            owner: FirebaseAuth.instance.currentUser!.uid,
                            participants: formKey.currentState?.fields['participate']?.value ?? false ? [Participant.fromUser(user)] : [],
                          ),
                        ),
                      );
                  context.pop();
                },
                title: 'Create',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
