import 'package:reader/preference/data/model/preference.dart';

class UpdatePreferenceKvUsecase {
  static PreferenceModel invoke(PreferenceModel preference,
      {required String key, required dynamic value}) {
    final Map<String, dynamic> json = preference.toJson();
    json[key] = value;
    return PreferenceModel.fromJson(json);
  }
}
