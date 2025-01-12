import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppTopBar extends HookConsumerWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.canPop = true,
    required this.title,
  });
  final String title;
  final bool canPop;
  @override
  PreferredSizeWidget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      backgroundColor: colorScheme.surfaceContainerLowest,
      title: Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      leading: canPop
          ? IconButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                backgroundColor: WidgetStateProperty.all(colorScheme.inverseSurface.withAlpha(20)),
                minimumSize: WidgetStateProperty.all(const Size(36, 36)),
              ),
              icon: const Icon(
                CupertinoIcons.back,
                size: 20,
              ),
              onPressed: () {
                context.pop();
              },
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
