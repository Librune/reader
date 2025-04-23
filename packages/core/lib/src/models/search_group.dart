import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rc/rc.dart';

part 'search_group.freezed.dart';

@freezed
abstract class SearchGroupModel with _$SearchGroupModel {
  const factory SearchGroupModel({
    required String name,
    required String uuid,
    @Default([]) List<SearchBook> books,
  }) = _SearchGroupModel;

  const SearchGroupModel._();
}
