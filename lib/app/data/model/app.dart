import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reader/preference/data/model/preference.dart';

part 'app.freezed.dart';
part 'app.g.dart';

@freezed
class AppModel with _$AppModel {
  const factory AppModel({
    @Default(PreferenceModel()) PreferenceModel preference,
  }) = _AppModel;

  factory AppModel.fromJson(Map<String, dynamic> json) => _$AppModelFromJson(json);

  const AppModel._();
}
