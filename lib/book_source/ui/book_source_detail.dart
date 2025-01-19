import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_js/javascript_runtime.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/app/ui/components/preference.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_source/data/model/book_source.dart';

class BookSourceDetail extends HookConsumerWidget {
  const BookSourceDetail({super.key, required this.model});
  final BookSourceModel model;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppTopBar(
        title: model.name,
      ),
    );
  }
}
