import 'package:reader/reader/data/model/config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config.g.dart';

@Riverpod(keepAlive: true)
class ReaderConfig extends _$ReaderConfig {
  @override
  ReaderConfigModel build() {
    return ReaderConfigModel();
  }
}
