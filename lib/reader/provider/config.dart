import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/data/model/config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config.g.dart';

@Riverpod(keepAlive: true)
class ReaderConfig extends _$ReaderConfig {
  final File configFile = File(PathService().readerConfigPath);
  @override
  ReaderConfigModel build(BuildContext context) {
    late final ReaderConfigModel _config;
    try {
      if (File(PathService().readerConfigPath).existsSync()) {
        final config = configFile.readAsStringSync();
        _config = ReaderConfigModel.fromJson(jsonDecode(config));
      } else {
        throw Exception('config file not found');
      }
    } catch (err) {
      Log.e(err);
      _config = ReaderConfigModel.defaultAndroid(
          systemPadding: MediaQuery.of(context).padding);
    }
    listenSelf(_onSelfChange);
    return _config;
  }

  updateBodyFontSize(int fontSize) {
    state = state.copyWith(bodyTextFontSize: fontSize * 1.0);
  }

  updateBodyLineHeight(double lineHeight) {
    state = state.copyWith(bodyTextLineHeight: lineHeight);
  }

  updateEdgePaddingDelta(int delta) {
    state = state.copyWith(edgePaddingDelta: delta * 1.0);
  }

  updateTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  _onSelfChange(ReaderConfigModel? oldValue, ReaderConfigModel newValue) {
    configFile.writeAsString(jsonEncode(newValue.toJson()));
  }
}
