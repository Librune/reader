import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_book_item.g.dart';
part 'search_book_item.freezed.dart';

@freezed
class SearchBookItemModel with _$SearchBookItemModel {
  const factory SearchBookItemModel({
    required String name,
    required String author,
    required String cover,
    required String description,
    required String bookId,
    required String chapterNum,
  }) = _SearchBookItemModel;
  factory SearchBookItemModel.fromJson(Map<String, dynamic> json) => _$SearchBookItemModelFromJson(json);
  const SearchBookItemModel._();
}
