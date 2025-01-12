import 'dart:convert';
import 'dart:io';

import 'package:reader/preference/data/model/preference.dart';

class PreferenceRepository {
  PreferenceRepository(this.preferencePath);
  final String preferencePath;
  PreferenceModel init() {
    File preferenceFile = File(preferencePath);
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
    return preference;
  }
}
