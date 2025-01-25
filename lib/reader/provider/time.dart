import 'dart:async';

import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'time.g.dart';

@Riverpod(keepAlive: true)
class ReaderTime extends _$ReaderTime {
  final DateFormat formatter = DateFormat('HH:mm');
  @override
  String build() {
    final now = DateTime.now();
    Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      state = formatter.format(now);
    });
    return formatter.format(now);
  }
}
