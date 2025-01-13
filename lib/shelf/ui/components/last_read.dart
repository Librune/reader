import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LastRead extends HookConsumerWidget {
  const LastRead({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Card.filled(
          elevation: 0,
          color: colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text("额尔古纳河右岸",
                        style: TextStyle(color: colorScheme.onSecondary, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                )),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnKoweh-PQ4QqVdN68jGWZXe4eRi1BXIwJ9g&s",
                    fit: BoxFit.cover,
                    width: 72,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
