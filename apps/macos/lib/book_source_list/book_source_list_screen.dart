import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class BookSourceListScreen extends StatefulHookConsumerWidget {
  const BookSourceListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookSourceListScreenState();
}

class _BookSourceListScreenState extends ConsumerState<BookSourceListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MacosColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, top: 26),
            child: Text("书源", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
