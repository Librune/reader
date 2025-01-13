import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/shelf/ui/components/last_read.dart';

class ShelfScreen extends HookConsumerWidget {
  const ShelfScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppTopBar(
        title: "今日尚未阅读",
        canPop: false,
        titleLeftPadding: 20,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/ic_topbar_search.svg",
              width: 18,
            ),
          ),
          IconButton(
            onPressed: () {
              context.push("/preference");
            },
            icon: SvgPicture.asset(
              "assets/svg/ic_topbar_settings.svg",
              width: 18,
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: 14, right: 14, bottom: 16),
            sliver: SliverToBoxAdapter(
              child: LastRead(),
              // child: ShelfSwitcher(),
            ),
          )
        ],
      ),
    );
  }
}
