import 'package:freezed_annotation/freezed_annotation.dart';

part 'extra.freezed.dart';
part 'extra.g.dart';

@freezed
class ReaderExtraModal with _$ReaderExtraModal {
  const factory ReaderExtraModal({
    // 强制下一页
    @Default(false) bool forceNextPage,
    // 音量键翻页
    @Default(false) bool volumeKeyPage,
    // 显示时间电量
    @Default(false) bool showTimeBattery,
    // 屏幕常亮
    @Default(false) bool keepScreenOn,
    // 禅模式
    @Default(false) bool zenMode,
    // 下拉书签
    @Default(false) bool pullBookmark,
  }) = _ReaderExtraModal;
  const ReaderExtraModal._();
  factory ReaderExtraModal.fromJson(Map<String, dynamic> json) => _$ReaderExtraModalFromJson(json);
}
