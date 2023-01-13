import 'package:agile_cards/app/routing/router.dart';
import 'package:agile_cards/app/services/analytics_service.dart';
import 'package:agile_cards/app/services/dynamic_linking.dart';
import 'package:agile_cards/app/state/app/app_bloc.dart';
import 'package:agile_cards/app/state/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';

GetIt locator = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: 'AgileCards', options: DefaultFirebaseOptions.currentPlatform);

  locator.registerLazySingleton(() => AnalyticsService(debug: kDebugMode));
  locator.registerLazySingleton(() => DynamicLinkService());

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  AppRouter? router;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return StateProviders(
      child: Builder(
        builder: (context) {
          router ??= AppRouter(navigatorKey: navigatorKey, appBloc: context.read<AppBloc>());

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router?.router,
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              backgroundColor: const Color.fromRGBO(33, 39, 58, 1),
              colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: Color.fromRGBO(255, 0, 73, 1),
                onPrimary: Color.fromRGBO(215, 221, 237, 1),
                secondary: Color.fromRGBO(63, 136, 197, 1),
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.white,
                background: Color.fromRGBO(32, 40, 56, 1),
                onBackground: Colors.white,
                surface: Color.fromRGBO(43, 50, 70, 1),
                onSurface: Colors.white,
                tertiary: Color.fromRGBO(237, 172, 98, 1),
              ),
            ),
          );
        },
      ),
    );
  }
}
