import 'dart:async';
import 'dart:developer';
import 'package:agile_cards/app/models/participant_model.dart';
import 'package:agile_cards/app/services/analytics_service.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/main.dart';
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

  void persistUserAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) log('User is currently signed out!');
        controller.add(AuthStream(user: null, status: AuthenticationStatus.unauthenticated));
      } else {
        if (kDebugMode) log('User is signed in!');
        controller.add(AuthStream(user: Participant.fromUser(user), status: AuthenticationStatus.authenticated));
      }
    }).onError((e) {
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'persist_user_authentication', stacktrace: StackTrace.current);
    });
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) => value.user);
      locator<AnalyticsService>().logLoggedIn(loggedInMethod: 'email');
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Error', toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, timeInSecForIosWeb: 3);
      if (kDebugMode) {
        log(e.toString());
      } else {
        locator<AnalyticsService>().logError(exception: e.toString(), reason: 'log_in_email_password', stacktrace: StackTrace.current);
      }
    }
  }

  Future<void> register({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? 'Error', toastLength: Toast.LENGTH_LONG, backgroundColor: Colors.red, timeInSecForIosWeb: 3);
      if (kDebugMode) log(e.toString());
      locator<AnalyticsService>().logError(exception: e.toString(), reason: 'register_email_pass', stacktrace: StackTrace.current);
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
