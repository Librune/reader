import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookSourceItem extends ConsumerWidget {
  const BookSourceItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "起点读书",
                  style: textTheme.titleSmall,
                ),
                Spacer(),
                SvgPicture.asset(
                  "assets/svg/ic_card_right.svg",
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(colorScheme.secondary, BlendMode.srcIn),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 2, bottom: 3),
              child: Row(
                children: [
                  Transform.scale(
                    scale: .74,
                    alignment: Alignment.centerLeft,
                    child: Chip(
                        labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        avatar: Icon(Icons.check, size: 18),
                        label: Text(
                          "已启用",
                          style: TextStyle(fontSize: 15, height: 1.25),
                        )),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 16),
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "JS 书源",
                          style: textTheme.bodySmall,
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return VerticalDivider(
                      width: 20,
                      indent: 3,
                      endIndent: 2,
                      thickness: .5,
                      color: colorScheme.secondary,
                    );
                  },
                  itemCount: 3),
            )
          ],
        ),
      ),
    );
  }
}
