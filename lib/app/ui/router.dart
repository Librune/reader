import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:reader/home/ui/home_screen.dart';
import 'package:reader/preference/ui/preference_screen.dart';
import 'package:reader/shelf/ui/shelf_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    //  GoRoute(
    //   path: '/',
    //   builder: (context, state) => const ShelfScreen(),
    // ),
    // GoRoute(
    //   path: '/reader/:name/:aid/:cIndex',
    //   builder: (context, state) {
    //     final name = state.pathParameters["name"] as String;
    //     final aid = state.pathParameters["aid"] as String;
    //     final cIndex = int.parse(state.pathParameters["cIndex"] as String);
    //     return ReaderScreen(name: name, aid: aid, cIndex: cIndex);
    //   },
    // ),
    GoRoute(
        path: '/preference',
        builder: (context, state) {
          return const PreferenceScreen();
        }),
  ],
);
