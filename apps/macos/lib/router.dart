import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:reader/app/app_entry.dart';
import 'package:reader/booksource_editor/booksource_editor_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: "/home",
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      restorationScopeId: "home",
      builder: (context, state, navigationShell) {
        return AppEntry(
          navigationShell,
          items: [
            MacosSidebarItem(label: '图书', section: true),
            MacosSidebarItem(label: '全部', icon: 'ic_books'),
            MacosSidebarItem(label: '探索', section: true),
            MacosSidebarItem(label: "刺猬猫", icon: 'ic_discover'),
            MacosSidebarItem(label: "起点", icon: 'ic_discover'),
            MacosSidebarItem(label: "红袖添香", icon: 'ic_discover'),
            MacosSidebarItem(label: "微信读书", icon: 'ic_discover'),
            MacosSidebarItem(label: '工具', section: true),
            MacosSidebarItem(label: '编辑书源', icon: 'ic_booksource'),
          ],
        );
      },
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => BooksourceEditorScreen())]),
        StatefulShellBranch(
          routes: [GoRoute(path: '/book_source_editor', builder: (context, state) => const BooksourceEditorScreen())],
        ),
      ],
    ),
  ],
);
