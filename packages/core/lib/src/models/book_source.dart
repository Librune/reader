import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_source.g.dart';
part 'book_source.freezed.dart';

enum BookSourceFileType { js, ts, wasm, zip, bks }

@freezed
abstract class BookSourceModel with _$BookSourceModel {
  const factory BookSourceModel({
    required String? uuid,
    required String name,
    required String author,
    @Default(true) enabled,
    @Default([]) List<dynamic> actions,
    @Default([]) List<BookSourceFormModel> forms,
    String? favIcon,
  }) = _BookSourceModel;
  factory BookSourceModel.fromJson(Map<String, dynamic> json) => _$BookSourceModelFromJson(json);
  const BookSourceModel._();
}

@freezed
abstract class BookSourceFormModel with _$BookSourceFormModel {
  const factory BookSourceFormModel({
    required String title,
    required String? subtitle,
    required List<BookSourceFormItemGroup> form,
  }) = _BookSourceFormModel;
  factory BookSourceFormModel.fromJson(Map<String, dynamic> json) => _$BookSourceFormModelFromJson(json);
  const BookSourceFormModel._();
}

enum BookSourceFormItemType { input, button, checkbox, select, toggle }

@freezed
abstract class BookSourceFormItemGroup with _$BookSourceFormItemGroup {
  const factory BookSourceFormItemGroup({
    required BookSourceFormItemType type,
    required String field,
    required String title,
    required String? placeholder,
  }) = _BookSourceFormItemGroup;
  factory BookSourceFormItemGroup.fromJson(Map<String, dynamic> json) => _$BookSourceFormItemGroupFromJson(json);
  const BookSourceFormItemGroup._();
}
