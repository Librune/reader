import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:reader/app/ui/components/bottom_nav.dart';
import 'package:reader/book_detail/ui/book_detail_screen.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/book_source/ui/book_source_detail.dart';
import 'package:reader/book_source/ui/book_source_list_screen.dart';
import 'package:reader/book_source/ui/book_source_preference.dart';
import 'package:reader/book_source/ui/book_source_test_screen.dart';
import 'package:reader/discover/ui/discover_screen.dart';

import 'package:reader/preference/ui/preference_screen.dart';
import 'package:reader/search/ui/search_result_screen.dart';
import 'package:reader/search/ui/search_screen.dart';
import 'package:reader/shelf/ui/shelf_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CustomNavigationHelper {
  static final CustomNavigationHelper _instance = CustomNavigationHelper._internal();

  static CustomNavigationHelper get instance => _instance;
  factory CustomNavigationHelper() {
    return _instance;
  }

  CustomNavigationHelper._internal() {
    // Router initialization happens here.
  }
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(navigatorKey: rootNavigatorKey, initialLocation: "/shelf", routes: <RouteBase>[
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BottomNav(navigationShell, items: [
          BottomBarItem(svgPath: "assets/svg/ic_bottom_books", label: "书架"),
          BottomBarItem(svgPath: "assets/svg/ic_bottom_discover", label: "发现"),
          BottomBarItem(svgPath: "assets/svg/ic_bottom_ext", label: "设置"),
        ]);
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/shelf',
            builder: (context, state) => const ShelfScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/discover',
            builder: (context, state) => const DiscoverScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/preference',
            builder: (context, state) => const PreferenceScreen(),
          ),
        ])
      ]),
  GoRoute(
    path: "/search",
    builder: (context, state) {
      final keyword = state.extra as String?;
      return SearchScreen(keyword: keyword);
    },
  ),
  GoRoute(
    path: "/book_search_result/:keyword",
    builder: (context, state) {
      final keyword = state.pathParameters['keyword']!;
      return SearchResultScreen(keyword: keyword);
    },
  ),
  GoRoute(
    path: "/book_detail/:bks/:id",
    builder: (context, state) {
      final bks = state.pathParameters['bks']!;
      final id = state.pathParameters['id']!;
      return BookDetailScreen();
    },
  ),
  GoRoute(
    path: "/book_source",
    builder: (context, state) {
      return BookSourceListScreen();
    },
  ),
  GoRoute(
    path: "/book_source/preference",
    builder: (context, state) {
      final BookSourceModel model = state.extra! as BookSourceModel;
      return BookSourcePreference(
        model: model,
      );
    },
  ),
  GoRoute(
    path: "/book_source/detail",
    builder: (context, state) {
      final BookSourceModel model = state.extra! as BookSourceModel;
      return BookSourceDetail(
        model: model,
      );
    },
  ),
  GoRoute(
    path: "/book_source_test/:uuid",
    builder: (context, state) {
      final uuid = state.pathParameters['uuid']!;
      return BookSourceTestScreen(
        uuid: uuid,
      );
    },
  )
]);
