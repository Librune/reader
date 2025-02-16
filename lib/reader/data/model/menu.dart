import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu.g.dart';
part 'menu.freezed.dart';

enum ReaderBottomSheet { catalog, font, theme, config }

@freezed
class MenuModel with _$MenuModel {
  const factory MenuModel({
    @Default(false) bool bottom,
    @Default(false) bool top,
    @Default(false) bool sub,
    @Default(null) ReaderBottomSheet? subType,
  }) = _MenuModel;
  factory MenuModel.fromJson(Map<String, dynamic> json) =>
      _$MenuModelFromJson(json);
  const MenuModel._();

  bool get none => !bottom && !top && !sub;
}
