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
        final int lockedInCount = state.session.selectionsNotLockedIn;
        return lockedInCount != 0
            ? Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text('Waiting for $lockedInCount participants'),
              )
            : const SizedBox();
      },
    );
  }
}
