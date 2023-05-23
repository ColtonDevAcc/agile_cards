import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/profile/profile_bloc.dart';
import 'package:agile_cards/app/state/session/session_bloc.dart';
import 'package:agile_cards/features/login/widgets/atom/primary_button.dart';
import 'package:agile_cards/pages/primary_textfield.dart';
import 'package:agile_cards/widgets/atoms/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final formKey = GlobalKey<FormBuilderState>();

        final user = state.user;
        return Scaffold(
          appBar: AppBar(
            title: Text(user.email ?? ''),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.read<ProfileBloc>().add(ProfileChangeIsEditing(isEditing: !(state.isEditing ?? false))),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  UserAvatar(
                    radius: 50,
                    onTap: () => context.read<AppBloc>().add(const ChangeUserAvatar()),
                  ),
                  const SizedBox(height: 20),
                  PrimaryTextField(onChanged: (v) {}, hintText: 'id', title: user.id, labelText: user.id, canEdit: false),
                  const SizedBox(height: 20),
                  PrimaryTextField(
                    onSaved: (v) => context.read<ProfileBloc>().add(ProfileChangeEmail(email: v ?? '')),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.email(errorText: 'Email must be a valid email'),
                    ]),
                    hintText: 'email',
                    title: user.email,
                    labelText: user.email,
                    canEdit: state.isEditing == true,
                    suffixIcon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  PrimaryTextField(
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onSaved: (v) => context.read<ProfileBloc>().add(ProfileChangeName(name: v ?? '')),
                    hintText: 'display name',
                    title: user.name,
                    labelText: user.displayName == '' ? 'Name' : user.displayName,
                    canEdit: state.isEditing == true,
                    suffixIcon: Icons.person,
                    // use this regex /^[a-z ,.'-]+$/i for the validator
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.minLength(4, errorText: 'Name must be at least 4 characters'),
                      FormBuilderValidators.maxLength(15, errorText: 'Name must be less than 15 characters'),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  if (state.isEditing == true)
                    PrimaryButton(
                      title: 'Save',
                      onPressed: () {
                        if (formKey.currentState?.fields['display name']?.value != state.user.displayName) {
                          formKey.currentState?.fields['display name']?.save();
                        }

                        if (formKey.currentState?.fields['email']?.value != state.user.email) {
                          formKey.currentState?.fields['email']?.save();
                        }

                        context.read<ProfileBloc>().add(const ProfileChangeIsEditing(isEditing: false));
                      },
                    ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  SafeArea(
                    child: ListTile(
                      title: const Text('logout'),
                      trailing: const Icon(Icons.exit_to_app),
                      onTap: () {
                        context.read<SessionBloc>().add(const SessionLeave());
                        context.read<AppBloc>().add(AuthenticationLogoutRequested());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
