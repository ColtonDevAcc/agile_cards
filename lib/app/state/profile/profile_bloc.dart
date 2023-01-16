import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  ProfileBloc({required this.userRepository}) : super(ProfileState(user: Participant.empty())) {
    on<ProfileChangeName>(onProfileChangeName);
    on<ProfileChangeAvatar>(onProfileChangeAvatar);
    on<ProfileChangeEmail>(onProfileChangeEmail);
    on<ProfileChangePhone>(onProfileChangePhone);
    on<ProfileInitial>(onProfileInitial);
    on<ProfileChangeIsEditing>(onProfileChangeIsEditing);
    on<ProfileChangeDisplayName>(onProfileChangeDisplayName);
    // on<ProfileChangePassword>(onProfileChangePassword);
  }

  Future<void> onProfileChangeName(ProfileChangeName event, Emitter<ProfileState> emit) async {
    await userRepository.changeName(event.name);
    emit(state.copyWith(user: state.user.copyWith(name: event.name)));
  }

  Future<void> onProfileChangeAvatar(ProfileChangeAvatar event, Emitter<ProfileState> emit) async {
    await userRepository.changeAvatar(event.avatar);
    emit(state.copyWith(user: state.user.copyWith(imageUrl: event.avatar)));
  }

  Future<void> onProfileChangeEmail(ProfileChangeEmail event, Emitter<ProfileState> emit) async {
    await userRepository.changeEmail(event.email);
    emit(state.copyWith(user: state.user.copyWith(email: event.email)));
  }

  Future<void> onProfileChangePhone(ProfileChangePhone event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(user: state.user.copyWith(phone: event.phone)));
  }

  Future<void> onProfileInitial(ProfileInitial event, Emitter<ProfileState> emit) async {
    await userRepository.getUser().then((value) => emit(state.copyWith(user: value)));
  }

  Future<void> onProfileChangeIsEditing(ProfileChangeIsEditing event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isEditing: event.isEditing));
  }

  Future<void> onProfileChangeDisplayName(ProfileChangeDisplayName event, Emitter<ProfileState> emit) async {
    await userRepository.changeDisplayName(event.displayName);
    emit(state.copyWith(user: state.user.copyWith(displayName: event.displayName)));
  }
}
