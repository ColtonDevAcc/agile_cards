import 'dart:async';
import 'dart:developer';
import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationRepository {
  final controller = StreamController<AuthStream>.broadcast();
  final storage = const FlutterSecureStorage();

  Stream<AuthStream> get status async* {
    yield AuthStream(user: null, status: AuthenticationStatus.unauthenticated);
    yield* controller.stream;
  }

  void persistUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) log('User is currently signed out!');
        controller.add(AuthStream(user: null, status: AuthenticationStatus.unauthenticated));
      } else {
        if (kDebugMode) log('User is signed in!');
        controller.add(AuthStream(user: Participant.fromUser(user), status: AuthenticationStatus.authenticated));
      }
    });
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) => value.user);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Error', toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, timeInSecForIosWeb: 3);
      if (kDebugMode) log(e.toString());
    }
  }

  Future<void> register({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Error', toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, timeInSecForIosWeb: 3);
      if (kDebugMode) log(e.toString());
    }
  }

  Future<void> logOut() async {
    FirebaseAuth.instance.signOut();
    controller.add(AuthStream(user: null, status: AuthenticationStatus.unauthenticated));
  }

  void dispose() => controller.close();
}

class AuthStream {
  Participant? user;
  AuthenticationStatus status;
  AuthStream({required this.user, required this.status});
}
