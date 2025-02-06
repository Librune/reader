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

  ColorScheme get colorScheme => ColorScheme.fromSeed(seedColor: Color(0xff389494)).copyWith(
        surface: Color(light.surface),
        onSurface: Color(light.onSurface),
        primary: Color(light.primary),
        secondary: Color(light.secondary),
        tertiary: Color(light.tertiary),
        brightness: Brightness.light,
      );

  ColorScheme get darkColorScheme => ColorScheme.fromSeed(seedColor: Color(0xff389494)).copyWith(
        surface: Color(dark.surface),
        onSurface: Color(dark.onSurface),
        primary: Color(dark.primary),
        secondary: Color(dark.secondary),
        tertiary: Color(dark.tertiary),
        brightness: Brightness.dark,
      );
}

@freezed
class ReaderThemeColorScheme with _$ReaderThemeColorScheme {
  const factory ReaderThemeColorScheme({
    required int surface,
    required int onSurface,
    required int primary,
    required int secondary,
    required int tertiary,
  }) = _ReaderThemeColorScheme;
  const ReaderThemeColorScheme._();
  factory ReaderThemeColorScheme.fromJson(Map<String, dynamic> json) => _$ReaderThemeColorSchemeFromJson(json);
}
