import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'progress.g.dart';
part 'progress.freezed.dart';

@Collection(ignore: {"copyWith", "fromJson", "toJson"})
@freezed
class ProgressModel with _$ProgressModel {
  const factory ProgressModel({
    @Default(Isar.autoIncrement) int id,
    required String bookId,
    required String volumeId,
    required int volumeIndex,
    required String chapterId,
    required int chapterIndex,
    required int paragraphIndex,
    required int textLineIndex,
    int? flatIndex,
  }) = _ProgressModel;
  const ProgressModel._();
  factory ProgressModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressModelFromJson(json);

  @override
  // ignore: recursive_getters
  Id get id => id;
}
