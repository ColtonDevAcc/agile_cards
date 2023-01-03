import 'package:agile_cards/app/services/analytics_service.dart';
import 'package:agile_cards/app/services/refresh_stream.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/pages/dashboard_page.dart';
import 'package:agile_cards/pages/login_page.dart';
import 'package:agile_cards/pages/registration_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final GlobalKey<NavigatorState>? navigatorKey;
  final AppBloc appBloc;
  AppRouter({required this.appBloc, required this.navigatorKey});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  late final router = GoRouter(
    navigatorKey: navigatorKey,
    refreshListenable: GoRouterRefreshStream(appBloc.stream),
    initialLocation: '/login',
    observers: [
      if (kDebugMode) GetIt.instance<AnalyticsService>(),
    ],
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const RegistrationPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
    redirect: (context, state) {
      final bool isAuthenticated = appBloc.state.status == AuthenticationStatus.authenticated;
      if (state.location != "/signup" && !isAuthenticated && state.location != "/login" && !isAuthenticated) {
        return "/login";
      } else if (state.location == "/login" && isAuthenticated || state.location == "/signup" && isAuthenticated) {
        return "/dashboard";
      } else {
        return null;
      }
    },
  );
}
