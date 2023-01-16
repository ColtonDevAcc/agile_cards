part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileChangeName extends ProfileEvent {
  final String name;
  const ProfileChangeName({required this.name});
}

class ProfileChangeAvatar extends ProfileEvent {
  final String avatar;
  const ProfileChangeAvatar({required this.avatar});
}

class ProfileChangeEmail extends ProfileEvent {
  final String email;
  const ProfileChangeEmail({required this.email});
}

class ProfileChangePassword extends ProfileEvent {
  final String password;
  const ProfileChangePassword({required this.password});
}

class ProfileChangePhone extends ProfileEvent {
  final String phone;
  const ProfileChangePhone({required this.phone});
}

class ProfileChangeIsEditing extends ProfileEvent {
  final bool isEditing;
  const ProfileChangeIsEditing({required this.isEditing});
}

class ProfileChangeDisplayName extends ProfileEvent {
  final String displayName;
  const ProfileChangeDisplayName({required this.displayName});
}

class ProfileInitial extends ProfileEvent {}
