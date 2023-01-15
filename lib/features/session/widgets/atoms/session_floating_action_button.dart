import 'package:agile_cards/app/models/session_model.dart';
import 'package:agile_cards/app/services/dynamic_linking.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/session/widgets/molecules/session_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionFloatingActionButton extends StatelessWidget {
  const SessionFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final isOwner = state.session.owner == context.read<AppBloc>().state.user?.id;
        final isEmpty = state.session == Session.empty();

        return isEmpty || isOwner
            ? FloatingActionButton(
                onPressed: !isOwner
                    ? () => context.read<SessionBloc>().add(SessionCreated(context.read<AppBloc>().state.user!))
                    : () {
                        DynamicLinkService().buildDynamicLink(
                          socialMediaTitle: 'Join my session',
                          content: 'you can join my agile cards sessions with my code: ${state.session.id}',
                          source: 'session_page',
                          routeToContent: '/session/${state.session.id}',
                          share: true,
                        );
                      },
                child: isOwner ? const Icon(Icons.send) : const SearchButton(),
              )
            : const SizedBox();
      },
    );
  }
}
