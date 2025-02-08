import 'package:freezed_annotation/freezed_annotation.dart';

part 'extra.freezed.dart';
part 'extra.g.dart';

@freezed
class ReaderExtraModal with _$ReaderExtraModal {
  const factory ReaderExtraModal({
    // 垂直滚动
    @Default(false) bool verticalScroll,
    // 横向滚动
    @Default(true) bool horizontalScroll,
    // 仿真翻页
    @Default(false) bool curlPage,
    // 拂动翻页
    @Default(false) bool flipPage,
    // 禅模式
    @Default(false) bool zenMode,
    // 全屏下一页
    @Default(false) bool fullScreenNext,
    // 点按动画
    @Default(true) bool tapAnimation,
    // 背景跟随
    @Default(false) bool backgroundFollow,
    // 下拉书签
    @Default(false) bool pullBookmark,
    // 音量键翻页
    @Default(false) bool volumeKeyPage,
    // 屏幕常亮
    @Default(false) bool keepScreenOn,
    // 显示时间电量
    @Default(false) bool showTimeBattery,
  }) = _ReaderExtraModal;
  const ReaderExtraModal._();
  factory ReaderExtraModal.fromJson(Map<String, dynamic> json) => _$ReaderExtraModalFromJson(json);
}
