import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'book.g.dart';
part 'book.freezed.dart';

@Collection(ignore: {"copyWith"})
@freezed
class BookModel with _$BookModel {
  const factory BookModel({
    @Default(Isar.autoIncrement) int id,
    required String name,
    required String author,
    required String cover,
    required String bookId,
    String? bookSourceId,
    String? bookShelfId,
    String? chapterNum,
    String? wordNum,
    String? description,
    String? creationStatus,
    List<String?>? tags,
    String? lastReadChapterId,
  }) = _BookModel;
  factory BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);
  const BookModel._();

  @override
  // ignore: recursive_getters
  Id get id => id;

  String get creationStatusText {
    switch (creationStatus) {
      case "0":
        return "已完结";
      case "1":
        return "连载中";
      default:
        return "未知";
    }
  }
}
