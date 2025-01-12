import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/app.dart';
import 'package:reader/preference/provider/preference_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.g.dart';

@riverpod
AppModel app(Ref ref) {
  return AppModel(preference: ref.watch(preferenceProvider));
}
