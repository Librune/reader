// dart
import 'package:flutter/material.dart';

class DelayedSliverList extends StatefulWidget {
  final Duration delay;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  const DelayedSliverList({
    super.key,
    required this.delay,
    required this.itemBuilder,
    required this.itemCount,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DelayedSliverListState createState() => _DelayedSliverListState();
}

class _DelayedSliverListState extends State<DelayedSliverList> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (!_showContent) {
      // 返回一个空的 Sliver（也可以返回一个占位）
      return SliverToBoxAdapter(
          child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
        child: Text(
          '正在读取章节',
          style: TextStyle(fontSize: 16, color: colorScheme.secondary),
        ),
      ));
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        widget.itemBuilder,
        childCount: widget.itemCount,
      ),
    );
  }
}
