import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_source.g.dart';
part 'book_source.freezed.dart';

@freezed
class BookSourceModel with _$BookSourceModel {
  const factory BookSourceModel({
    String? favIcon,
    required String name,
    required String author,
    required List<dynamic> actions,
    required List<BookSourceFormModel> forms,
  }) = _BookSourceModel;
  factory BookSourceModel.fromJson(Map<String, dynamic> json) => _$BookSourceModelFromJson(json);
  const BookSourceModel._();
}

@freezed
class BookSourceFormModel with _$BookSourceFormModel {
  const factory BookSourceFormModel({
    required String title,
    required String? subtitle,
    required List<BookSourceFormItemGroup> form,
  }) = _BookSourceFormModel;
  factory BookSourceFormModel.fromJson(Map<String, dynamic> json) => _$BookSourceFormModelFromJson(json);
  const BookSourceFormModel._();
}

enum BookSourceFormItemType { input, button, checkbox, select }

@freezed
class BookSourceFormItemGroup with _$BookSourceFormItemGroup {
  const factory BookSourceFormItemGroup({
    required BookSourceFormItemType type,
    required String field,
    required String title,
    required String? placeholder,
  }) = _BookSourceFormItemGroup;
  factory BookSourceFormItemGroup.fromJson(Map<String, dynamic> json) => _$BookSourceFormItemGroupFromJson(json);
  const BookSourceFormItemGroup._();
}
