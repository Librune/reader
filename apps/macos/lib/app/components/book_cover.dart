import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookCover extends StatefulHookConsumerWidget {
  const BookCover(
    this.id, {
    super.key,
    required this.uuid,
    this.coverUrl,
    this.width,
    this.height,
  });
  final String id;
  final String uuid;
  final String? coverUrl;
  final double? width;
  final double? height;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookCoverState();
}

class _BookCoverState extends ConsumerState<BookCover> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          widget.coverUrl != null
              ? CachedNetworkImage(
                httpHeaders: {
                  "user-agent":
                      BookSourceService().bookCores[widget
                          .uuid]!['metadata']['userAgent'],
                },
                imageUrl: widget.coverUrl!,
                fit: BoxFit.cover,
                width: widget.width,
                height: widget.height,
              )
              : SizedBox.shrink(),
    );
  }
}
