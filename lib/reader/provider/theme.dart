import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@Riverpod(keepAlive: true)
class Theme extends _$Theme {
  @override
  int build() {
    return 1;
  }
}
