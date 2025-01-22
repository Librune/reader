import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_book_item.g.dart';
part 'search_book_item.freezed.dart';

@freezed
class SearchBookItemModel with _$SearchBookItemModel {
  const factory SearchBookItemModel({
    required String name,
    required String author,
    required String cover,
    required String bookId,
    String? chapterNum,
    String? wordNum,
    String? description,
    // 状态，0：已完结，1：连载中
    String? creationStatus,
    String? tag,
  }) = _SearchBookItemModel;
  factory SearchBookItemModel.fromJson(Map<String, dynamic> json) => _$SearchBookItemModelFromJson(json);
  const SearchBookItemModel._();
}
