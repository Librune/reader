import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FakeSearchBar extends ConsumerWidget {
  const FakeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Container(
        height: 40,
        margin: EdgeInsets.only(top: 0, left: 16, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: colorScheme.secondaryFixed,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/svg/ic_topbar_search.svg",
              colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
              width: 18,
            ),
            const SizedBox(width: 8),
            Text(
              "搜索书籍",
              style: textTheme.bodyMedium?.copyWith(height: 1),
            ),
          ],
        ),
      ),
    );
  }
}
