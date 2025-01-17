import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/app/ui/components/gradual_label.dart';
import 'package:reader/discover/ui/components/fake_search_bar.dart';
import 'package:reader/discover/ui/components/rank_card.dart';
import 'package:reader/discover/ui/components/rank_card_grid.dart';

class DiscoverScreen extends HookConsumerWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
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
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 0),
          //   sliver: SliverToBoxAdapter(
          //       child: GradualLabel(
          //     label: "刺猬猫阅读",
          //     decorationColors: [Color(0xfff9a825), Color(0x20fdd835), Color(0x10fff59d)],
          //   )),
          // ),
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
          //   sliver: SliverToBoxAdapter(
          //       child: RankCard(
          //     favIcon:
          //         'https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://www.ciweimao.com&size=24',
          //     name: '刺猬猫阅读',
          //     rankNum: 4,
          //     subRankNum: 48,
          //   )),
          // ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverAnimatedGrid(
              initialItemCount: 10,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 1.2),
              itemBuilder: (context, index, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: RankCardGrid(
                    name: '起点读书',
                  ),
                );
              },
            ),
          )
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
          //   sliver: SliverToBoxAdapter(
          //       child: RankCard(
          //     favIcon:
          //         'https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://www.qidian.com&size=24',
          //     name: '起点读书',
          //     rankNum: 14,
          //     subRankNum: 72,
          //   )),
          // ),
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
          //   sliver: SliverToBoxAdapter(
          //       child: RankCard(
          //     favIcon:
          //         'https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://official.bkneng.com/&size=24',
          //     name: '不可能的世界',
          //     rankNum: 5,
          //     subRankNum: 25,
          //   )),
          // ),
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
          //   sliver: SliverToBoxAdapter(
          //       child: RankCard(
          //     favIcon:
          //         'https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://fanqienovel.com&size=24',
          //     name: '番茄小说',
          //     rankNum: 2,
          //     subRankNum: 42,
          //   )),
          // ),
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
          //   sliver: SliverToBoxAdapter(
          //       child: RankCard(
          //     favIcon:
          //         'https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://www.sfacg.com/&size=24',
          //     name: '菠萝包轻小说',
          //     rankNum: 6,
          //     subRankNum: 24,
          //   )),
          // ),
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
          //   sliver: SliverToBoxAdapter(
          //       child: RankCard(
          //     favIcon:
          //         'https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://motie.com/&size=24',
          //     name: '磨铁文学网',
          //     rankNum: 4,
          //     subRankNum: 12,
          //   )),
          // ),
        ],
      ),
    );
  }
}
