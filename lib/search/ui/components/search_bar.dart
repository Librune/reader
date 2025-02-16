import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';

class BookSearchBar extends HookConsumerWidget implements PreferredSizeWidget {
  const BookSearchBar(
      {super.key,
      this.keyword,
      this.onTap,
      this.autoFocus = true,
      this.showClear = false});

  final bool? autoFocus;
  final String? keyword;
  final void Function()? onTap;
  final bool? showClear;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final searchController = useTextEditingController(text: keyword);
    return AppTopBar(
        title: Row(
      children: [
        Expanded(
            child: SearchBar(
          autoFocus: autoFocus!,
          backgroundColor:
              WidgetStateProperty.all(colorScheme.inverseSurface.withAlpha(20)),
          controller: searchController,
          elevation: WidgetStatePropertyAll(0),
          constraints: BoxConstraints(minHeight: 38),
          textStyle: WidgetStatePropertyAll(textTheme.bodyMedium),
          padding: WidgetStatePropertyAll(EdgeInsets.only(right: 0, left: 10)),
          onTap: onTap,
          leading: Padding(
            padding: EdgeInsets.only(left: 4),
            child: SvgPicture.asset("assets/svg/ic_topbar_search.svg",
                colorFilter:
                    ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
                width: 16),
          ),
          trailing: [
            if (showClear!)
              ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 36),
                  child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        "assets/svg/ic_btn_close.svg",
                        width: 16,
                      ))),
            SizedBox(
              width: 0,
              height: 20,
              child: VerticalDivider(
                color: colorScheme.secondaryContainer,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 36),
              child: TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all(colorScheme.onSurface),
                  ),
                  child: Text(
                    "搜索",
                    style: TextStyle(fontSize: 14, height: 1),
                  )),
            )
          ],
        )),
        SizedBox(width: 16)
        // TextButton(onPressed: () {}, child: Text("搜索"))
      ],
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
