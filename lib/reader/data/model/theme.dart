import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme.g.dart';
part 'theme.freezed.dart';

@freezed
class ReaderThemeModel with _$ReaderThemeModel {
  const factory ReaderThemeModel({
    required String id,
    required String name,
    @Default("佚名") String author,
    @Default(false) bool image,
    required ReaderThemeColorScheme light,
    required ReaderThemeColorScheme dark,
  }) = _ReaderThemeModel;
  const ReaderThemeModel._();
  factory ReaderThemeModel.fromJson(Map<String, dynamic> json) => _$ReaderThemeModelFromJson(json);

  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: Color(int.parse(light.primary, radix: 16))).copyWith(
        surface: Color(int.parse(light.surface, radix: 16)),
        onSurface: Color(int.parse(light.onSurface, radix: 16)),
        primary: Color(int.parse(light.primary, radix: 16)),
        secondary: Color(int.parse(light.secondary, radix: 16)),
        tertiary: Color(int.parse(light.tertiary, radix: 16)),
        brightness: Brightness.light,
      );

  ColorScheme get darkColorScheme =>
      ColorScheme.fromSeed(seedColor: Color(int.parse(light.primary, radix: 16))).copyWith(
        surface: Color(int.parse(dark.surface, radix: 16)),
        onSurface: Color(int.parse(dark.onSurface, radix: 16)),
        primary: Color(int.parse(dark.primary, radix: 16)),
        secondary: Color(int.parse(dark.secondary, radix: 16)),
        tertiary: Color(int.parse(dark.tertiary, radix: 16)),
        brightness: Brightness.dark,
      );
}

@freezed
class ReaderThemeColorScheme with _$ReaderThemeColorScheme {
  const factory ReaderThemeColorScheme({
    required String surface,
    required String onSurface,
    required String primary,
    required String secondary,
    required String tertiary,
  }) = _ReaderThemeColorScheme;
  const ReaderThemeColorScheme._();
  factory ReaderThemeColorScheme.fromJson(Map<String, dynamic> json) => _$ReaderThemeColorSchemeFromJson(json);
}
