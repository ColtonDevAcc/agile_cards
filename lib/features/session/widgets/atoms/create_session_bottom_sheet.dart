import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/pages/primary_textfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

final formKey = GlobalKey<FormBuilderState>();

class CreateSessionBottomSheet extends StatelessWidget {
  const CreateSessionBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .6,
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
