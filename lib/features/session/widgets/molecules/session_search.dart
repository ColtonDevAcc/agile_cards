import 'dart:developer';

import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () => showBottomSheet(
        context: context,
        builder: (context) => const SearchSessionBottomSheet(),
      ),
    );
  }
}

class SearchSessionBottomSheet extends StatelessWidget {
  const SearchSessionBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final form = GlobalKey<FormBuilderFieldState>();
        final ownerID = state.sessionSearch?.owner;
        final List<Participant> participants = state.sessionSearch?.participants ?? [];
        final participant = participants.firstWhere((p) => p.id == ownerID, orElse: () => Participant.empty());

        return Container(
          height: 350,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              FormBuilderTextField(
                key: form,
                name: 'search',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.match(r'^[a-zA-Z0-9_-]*$', errorText: 'must not include spaces, \$, [, ], or .'),
                ]),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) {
                  if (form.currentState!.isValid) {
                    context.read<SessionBloc>().add(SessionSearched(v ?? ''));
                  }
                },
              ),
              Expanded(
                child: ListView(
                  children: [
                    if (state.sessionSearch != null && state.sessionSearch != Session.empty())
                      GestureDetector(
                        onTap: () {
                          log('session joined: ${state.sessionSearch!.id}', name: 'SearchSessionBottomSheet');
                          context.read<SessionBloc>().add(SessionJoined(state.sessionSearch!.id!));
                          Navigator.of(context).pop();
                        },
                        child: ListTile(
                          title: Text(state.sessionSearch!.name!),
                          subtitle: Wrap(
                            spacing: 8,
                            children: participants.map((p) => Chip(label: Text(p.email!.split('@')[0]))).toList(),
                          ),
                          trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
                        ),
                      )
                    else
                      const ListTile(
                        title: Text('No results'),
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
