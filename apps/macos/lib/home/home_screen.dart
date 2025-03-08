// import 'package:flutter/cupertino.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:macos_ui/macos_ui.dart';
// import 'package:reader/booksource_editor/booksource_editor_screen.dart';

// class HomeScreen extends StatefulHookConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final currentSidebarItem = useState(0);
//     final createSidebarItem = useCallback(({required String label, required String icon, bool selected = false}) {
//       return SidebarItem(
//         selectedColor: MacosColors.gridColor.withValues(alpha: .8),
//         leading: SvgPicture.asset(
//           "assets/svg/$icon.svg",
//           width: 18,
//           colorFilter: ColorFilter.mode(
//             selected ? MacosColors.white.withValues(alpha: .8) : MacosColors.black.withValues(alpha: .4),
//             BlendMode.srcIn,
//           ),
//         ),
//         label: Text(label, style: TextStyle(fontSize: 12)),
//       );
//     }, []);
//     return MacosWindow(
//       sidebar: Sidebar(
//         minWidth: 200,
//         topOffset: 46,
//         top: MacosSearchField(
//           decoration: BoxDecoration(
//             color: MacosColors.secondaryLabelColor.darkColor,
//             borderRadius: BorderRadius.circular(7.0),
//           ),
//           focusedDecoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7.0))),
//         ),
//         builder: (context, scrollController) {
//           return SidebarItems(
//             currentIndex: currentSidebarItem.value,
//             onChanged: (index) {
//               currentSidebarItem.value = index;
//             },
//             items: [
//               SidebarItem(label: Text('图书'), section: true),
//               createSidebarItem(label: '全部', icon: 'ic_books', selected: currentSidebarItem.value == 0),
//               SidebarItem(label: Text('探索'), section: true),
//               createSidebarItem(label: "刺猬猫", icon: 'ic_discover', selected: currentSidebarItem.value == 1),
//               createSidebarItem(label: "起点", icon: 'ic_discover', selected: currentSidebarItem.value == 2),
//               createSidebarItem(label: "红袖添香", icon: 'ic_discover', selected: currentSidebarItem.value == 3),
//               createSidebarItem(label: "微信读书", icon: 'ic_discover', selected: currentSidebarItem.value == 4),
//               SidebarItem(label: Text('工具'), section: true),
//               createSidebarItem(label: '编辑书源', icon: 'ic_booksource', selected: currentSidebarItem.value == 5),
//             ],
//           );
//         },
//       ),
//       endSidebar: Sidebar(
//         startWidth: 200,
//         minWidth: 200,
//         maxWidth: 300,
//         shownByDefault: false,
//         builder: (context, _) {
//           return const Center(child: Text('End Sidebar'));
//         },
//       ),
//       child: BooksourceEditorScreen(),
//     );
//   }
// }
