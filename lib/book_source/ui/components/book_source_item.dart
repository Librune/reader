import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_source/data/model/book_source.dart';

class BookSourceItem extends ConsumerWidget {
  const BookSourceItem({
    super.key,
    required this.source,
    this.onPressed,
    this.onActionPressed,
  });
  final void Function()? onPressed;
  final void Function()? onActionPressed;

  final BookSourceModel source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        child: Padding(
          padding: EdgeInsets.only(left: 18, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    source.name,
                    style: textTheme.titleSmall,
                  ),
                  Spacer(),
                  SvgBtn(
                    svgName: "ic_card_settings",
                    onPressed: onActionPressed,
                  ),
                ],
              ),
              Transform.translate(
                offset: Offset(0, -8),
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
      ),
    );
  }
}
