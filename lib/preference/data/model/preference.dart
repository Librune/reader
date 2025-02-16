import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preference.g.dart';
part 'preference.freezed.dart';

@freezed
class PreferenceModel with _$PreferenceModel {
  const factory PreferenceModel({
    @Default(0xff009688) int colorSeed,
    @Default(false) bool isDarkMode,
    @Default(true) bool autoDarkMode,
  }) = _PreferenceModel;

  factory PreferenceModel.fromJson(Map<String, dynamic> json) =>
      _$PreferenceModelFromJson(json);

  const PreferenceModel._();

  ThemeMode get colorMode => autoDarkMode
      ? ThemeMode.system
      : isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light;
}
