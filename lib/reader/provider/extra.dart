import 'dart:convert';
import 'dart:io';

import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/data/model/extra.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'extra.g.dart';

@Riverpod(keepAlive: true)
class ReaderExtraConfig extends _$ReaderExtraConfig {
  @override
  ReaderExtraModal build() {
    late final ReaderExtraModal _extra;
    try {
      if (extraFile.existsSync()) {
        final extra = extraFile.readAsStringSync();
        _extra = ReaderExtraModal.fromJson(jsonDecode(extra));
      } else {
        throw Exception('extra file not found');
      }
    } catch (err) {
      Log.e(err);
      _extra = ReaderExtraModal();
    }
    listenSelf(_onSelfChange);
    return _extra;
  }

  updatePageTurning(String id) {
    final json = state.toJson();
    final turnings = [
      'verticalScroll',
      'horizontalScroll',
      'curlPage',
      'flipPage'
    ];
    for (var turning in turnings) {
      if (turning == id) {
        json[turning] = true;
      } else {
        json[turning] = false;
      }
    }
    state = ReaderExtraModal.fromJson(json);
  }

  updateBoolean(String id) {
    final json = state.toJson();
    final boolValue = json[id];
    json[id] = !boolValue;
    state = ReaderExtraModal.fromJson(json);
  }

  _onSelfChange(ReaderExtraModal? oldValue, ReaderExtraModal newValue) {
    extraFile.writeAsString(jsonEncode(newValue.toJson()));
  }

  File get extraFile => File(PathService().readerExtraConfigPath);
}
