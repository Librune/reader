import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/discover/ui/components/fake_search_bar.dart';

class DiscoverScreen extends HookConsumerWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppTopBar(
        title: "探索书籍",
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 20, top: 0),
            sliver: SliverToBoxAdapter(child: FakeSearchBar()),
          ),
        ],
      ),
    );
  }
}
