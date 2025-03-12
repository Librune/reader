import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:reader_macos/app/app_entry.dart';
import 'package:reader_macos/book_source_list/book_source_list_screen.dart';
import 'package:reader_macos/booksource_editor/booksource_editor_screen.dart';
import 'package:reader_macos/search/search_screen.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
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
            MacosSidebarItem(label: '搜索', icon: 'ic_search'),
            MacosSidebarItem(label: '探索', section: true),
            MacosSidebarItem(label: '书源列表', icon: 'ic_booksource'),
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
        StatefulShellBranch(routes: [GoRoute(path: '/search', builder: (context, state) => SearchScreen())]),
        StatefulShellBranch(
          routes: [GoRoute(path: '/book_source_list', builder: (context, state) => const BookSourceListScreen())],
        ),
      ],
    ),
  ],
);
