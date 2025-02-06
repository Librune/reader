import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reader/app/architecture/service/path.dart';

part 'config.g.dart';
part 'config.freezed.dart';

@freezed
class ReaderConfigModel with _$ReaderConfigModel {
  const factory ReaderConfigModel({
    @Default("System") String? fontFamily,
    @Default(18.0) double bodyTextFontSize,
    @Default(1.7) double bodyTextLineHeight,
    @Default(10.0) double edgePaddingDelta,
    @Default(22) double edgePaddingTop,
    @Default(10) double edgePaddingRight,
    @Default(18) double edgePaddingBottom,
    @Default(10) double edgePaddingLeft,
    @Default(6) double topInfoPaddingTop,
    @Default(20) double topInfoPaddingRight,
    @Default(72) double topInfoPaddingLeft,
    @Default(6) double bottomInfoPaddingBottom,
    @Default(20) double bottomInfoPaddingRight,
    @Default(20) double bottomInfoPaddingLeft,
    @Default(124) double titlePaddingTop,
    @Default(48) double titlePaddingBottom,
    @Default(0) int transition,
    @Default("landscape") String theme,
  }) = _ReaderConfigModel;

  factory ReaderConfigModel.defaultAndroid({EdgeInsets systemPadding = EdgeInsets.zero}) => ReaderConfigModel(
        fontFamily: "System",
        bodyTextFontSize: 20.0,
        bodyTextLineHeight: 1.7,
        edgePaddingDelta: 10.0,
        edgePaddingTop: systemPadding.top + 18,
        edgePaddingRight: 10,
        edgePaddingBottom: systemPadding.bottom + 18,
        edgePaddingLeft: 10,
        topInfoPaddingTop: systemPadding.top,
        topInfoPaddingRight: 20,
        topInfoPaddingLeft: 20,
        bottomInfoPaddingBottom: systemPadding.bottom,
        bottomInfoPaddingRight: 20,
        bottomInfoPaddingLeft: 20,
        titlePaddingTop: 124,
        titlePaddingBottom: 48,
        transition: 0,
      );
  const ReaderConfigModel._();
  factory ReaderConfigModel.fromJson(Map<String, dynamic> json) => _$ReaderConfigModelFromJson(json);

  TextStyle get textStyle => TextStyle(fontSize: bodyTextFontSize, height: bodyTextLineHeight, fontFamily: fontFamily);

  EdgeInsets get edgePadding => EdgeInsets.only(
      top: edgePaddingTop + edgePaddingDelta,
      right: edgePaddingRight + edgePaddingDelta,
      bottom: edgePaddingBottom + edgePaddingDelta,
      left: edgePaddingLeft + edgePaddingDelta);

  EdgeInsets get topInfoPadding =>
      EdgeInsets.only(top: topInfoPaddingTop, right: topInfoPaddingRight, left: topInfoPaddingLeft);

  EdgeInsets get bottomInfoPadding =>
      EdgeInsets.only(bottom: bottomInfoPaddingBottom, right: bottomInfoPaddingRight, left: bottomInfoPaddingLeft);

  TextStyle get bodyTextStyle =>
      TextStyle(fontSize: bodyTextFontSize, height: bodyTextLineHeight, fontFamily: fontFamily);

  String get customFontPath => "${PathService().appPath}/fonts/font.ttf";
}
