import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
abstract class BookModel with _$BookModel {
  const factory BookModel({
    required String id,
    required String title,
    required String author,
    String? description,
    int? wordCount,
    int? chapterCount,
    @Default([]) List<String> tags,
  }) = _BookModel;

  const BookModel._();
  factory BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);
}
