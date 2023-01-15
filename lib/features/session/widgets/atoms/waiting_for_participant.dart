import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitingForParticipant extends StatelessWidget {
  const WaitingForParticipant({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            state.session.cardsRevealed != true
                ? 'Waiting for ${state.session.selectionsNotLockedIn} participants'
                : 'average score is ${state.session.sessionMeasurementAverage}',
          ),
        );
      },
    );
  }
}
