import 'package:reader/reader/data/model/extra.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'extra.g.dart';

@Riverpod(keepAlive: true)
class ReaderExtraConfig extends _$ReaderExtraConfig {
  @override
  ReaderExtraModal build() {
    return ReaderExtraModal();
  }
}
