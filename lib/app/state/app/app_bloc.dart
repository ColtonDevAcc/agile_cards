import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository authenticationRepository;
  late StreamSubscription<AuthStream> authenticationStatusSubscription;

  AppBloc({required this.authenticationRepository}) : super(const AppState.unknown()) {
    on<AuthenticationStatusChanged>(onAuthenticationStatusChanged);
    on<AuthenticationLogoutRequested>(onLogoutRequested);
    on<AuthenticationPersistRequested>(onPersistRequested);
    on<ChangeUserAvatar>(onChangeUserAvatar);
    authenticationStatusSubscription = authenticationRepository.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  Future<void> onAuthenticationStatusChanged(AuthenticationStatusChanged event, Emitter<AppState> emit) async {
    switch (event.status.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AppState.unauthenticated());

      case AuthenticationStatus.authenticated:
        final user = event.status.user;
        return emit(AppState.authenticated(user!));

      case AuthenticationStatus.authenticating:
        return emit(const AppState.authenticating());

      case AuthenticationStatus.error:
        return emit(const AppState.unauthenticated());

      case AuthenticationStatus.initial:
        return emit(const AppState.unknown());
    }
  }

  void onLogoutRequested(AuthenticationLogoutRequested event, Emitter<AppState> emit) {
    authenticationRepository.logOut();
  }

  void onPersistRequested(AuthenticationPersistRequested event, Emitter<AppState> emit) {
    authenticationRepository.persistUserAuth();
  }

  Future<void> onChangeUserAvatar(ChangeUserAvatar event, Emitter<AppState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();

      await picker.pickImage(source: ImageSource.gallery, imageQuality: 25).then((image) async {
        if (image != null) {
          final User user = FirebaseAuth.instance.currentUser!;
          final storageRef = FirebaseStorage.instance.ref('${user.uid}/profilePicture/${image.name}');
          final imageBytes = await image.readAsBytes();

          final TaskSnapshot task = await storageRef.putData(imageBytes);
          final String downloadUrl = await task.ref.getDownloadURL();
          await FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl);

          final Participant participant = Participant.fromUser(user).copyWith(imageUrl: downloadUrl);
          emit(state.copyWith(user: participant));
        } else {
          log('image is null');
        }
      }).catchError((error) {
        log(error.toString());
      });
    } catch (e) {
      log('error changing image ${e.toString()}');
    }
  }

  @override
  Future<void> close() {
    authenticationStatusSubscription.cancel();
    return super.close();
  }
}
