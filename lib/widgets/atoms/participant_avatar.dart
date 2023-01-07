import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ParticipantAvatar extends StatelessWidget {
  final Participant? participant;

  const ParticipantAvatar({
    Key? key,
    this.participant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.pushNamed('profile_page'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: participant == null ? Text(state.user?.email.characters.first ?? '??') : Text(participant?.email.characters.first ?? '??'),
            ),
          ),
        );
      },
    );
  }
}
