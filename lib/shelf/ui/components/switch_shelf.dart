import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SwitchShelf extends StatefulHookConsumerWidget {
  const SwitchShelf({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SwitchShelfState();
}

class _SwitchShelfState extends ConsumerState<SwitchShelf> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(left: 20, right: 0),
      child: Row(
        spacing: 12,
        children: [
          OutlinedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(60, 32)),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 4)),
              ),
              onPressed: () {},
              child: SvgPicture.asset(
                "assets/svg/ic_shelf_settings.svg",
                width: 18,
                colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
              )),
          FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(colorScheme.tertiary),
                minimumSize: WidgetStateProperty.all(Size(60, 32)),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
              ),
              onPressed: () {},
              child: Text(
                "全部书籍",
                style: TextStyle(fontSize: 12, height: 1),
              )),
          OutlinedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(Size(60, 32)),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16)),
              ),
              onPressed: () {},
              child: Text(
                "轻小说文库",
                style: TextStyle(fontSize: 12, height: 1),
              ))
        ],
      ),
    );
  }
}
