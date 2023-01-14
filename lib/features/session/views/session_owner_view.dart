import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/features/session/widgets/atoms/agile_card_selector.dart';
import 'package:agile_cards/features/session/widgets/atoms/flip_card_button.dart';
import 'package:agile_cards/features/session/widgets/molecules/participant_card_selection_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionOwnerView extends StatelessWidget {
  const SessionOwnerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        WaitingForParticipant(),
        FlipCardButton(),
        SizedBox(height: 20),
        ParticipantCardSelectionList(),
        // if (session.participants?.contains(context.read<AppBloc>().state.user) ?? false)
        Expanded(child: AgileCardSelector()),
      ],
    );
  }
}

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
