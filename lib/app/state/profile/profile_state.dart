part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final Participant user;
  final bool? isEditing;
  const ProfileState({this.isEditing, required this.user});

  @override
  List<Object?> get props => [user, isEditing];

  // copy with
  ProfileState copyWith({Participant? user, bool? isEditing}) {
    return ProfileState(user: user ?? this.user, isEditing: isEditing ?? this.isEditing);
  }
}
