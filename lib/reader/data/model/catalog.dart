import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'catalog.g.dart';
part 'catalog.freezed.dart';

@Collection(ignore: {
  "copyWith",
  "toJson",
  "fromJson",
})
@freezed
class CatalogModel with _$CatalogModel {
  const factory CatalogModel({
    required int id,
    required String bookId,
    required String bookSourceId,
    required String name,
    required List<VolumeModel> volumes,
    String? lastChapterId,
  }) = _CatalogModel;
  factory CatalogModel.fromJson(Map<String, dynamic> json) => _$CatalogModelFromJson(json);
  const CatalogModel._();

  @override
  // ignore: recursive_getters
  Id get id => id;

  List<ChapterModel> get flatChapterList => volumes.expand((v) => v.chapters).toList();
}

@Embedded(ignore: {
  "copyWith",
  "toJson",
  "fromJson",
})
@freezed
class VolumeModel with _$VolumeModel {
  const factory VolumeModel({
    @Default("") String vid,
    @Default("") String title,
    @Default([]) List<ChapterModel> chapters,
  }) = _VolumeModel;
  factory VolumeModel.fromJson(Map<String, dynamic> json) => _$VolumeModelFromJson(json);
  const VolumeModel._();
}

@Embedded(ignore: {
  "copyWith",
  "toJson",
  "fromJson",
})
@freezed
class ChapterModel with _$ChapterModel {
  const factory ChapterModel({
    @Default("") String cid,
    @Default("") String title,
    String? updateTime,
    String? wordNum,
    @Default(false) bool isVip,
    @Default(false) bool hasAccess,
  }) = _ChapterModel;
  factory ChapterModel.fromJson(Map<String, dynamic> json) => _$ChapterModelFromJson(json);
  const ChapterModel._();
}
