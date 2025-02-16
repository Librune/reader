import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/preference/usecase/update_preference_kv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/model/preference.dart';

part 'preference_provider.g.dart';

@riverpod
class Preference extends _$Preference {
  String preferencePath = join(PathService().appPath, 'preference.json');

  @override
  PreferenceModel build() {
    late final PreferenceModel preference;
    try {
      if (preferenceFile.existsSync()) {
        final json = preferenceFile.readAsStringSync();
        preference = PreferenceModel.fromJson(jsonDecode(json));
      } else {
        throw Exception('File not found');
      }
    } catch (e) {
      preference = PreferenceModel();
    }
    listenSelf(_onSelfChange);
    return preference;
  }

  void updateAutoDarkMode(bool autoDarkMode) {
    state = UpdatePreferenceKvUsecase.invoke(state,
        key: 'autoDarkMode', value: autoDarkMode);
  }

  void updateColorSeed(int colorSeed) {
    state = UpdatePreferenceKvUsecase.invoke(state,
        key: 'colorSeed', value: colorSeed);
  }

  void updateIsDarkMode(bool isDarkMode) {
    state = UpdatePreferenceKvUsecase.invoke(state,
        key: 'isDarkMode', value: isDarkMode);
  }

  _onSelfChange(PreferenceModel? oldState, PreferenceModel newState) {
    preferenceFile.writeAsStringSync(jsonEncode(newState.toJson()));
  }

  File get preferenceFile => File(preferencePath);
}
