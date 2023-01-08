import 'dart:developer';

import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserAvatar extends StatelessWidget {
  final double? radius;
  final VoidCallback? onTap;
  const UserAvatar({Key? key, this.radius, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: GestureDetector(
            onTap: onTap ?? () => context.pushNamed('profile_page'),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundImage: state.user?.imageUrl == null || state.user!.imageUrl!.isEmpty ? null : NetworkImage(state.user!.imageUrl!),
              child: Text(
                state.user?.email?.characters.first ?? '??',
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        );
      },
    );
  }
}
