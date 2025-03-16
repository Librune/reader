import 'package:core/core.dart';
import 'package:core/src/usecases/book_source/add_from_file.dart';
import 'package:core/src/usecases/book_source/delete.dart';
import 'package:core/src/usecases/book_source/load_all_js.dart';
import 'package:core/src/usecases/book_source/update_manifest.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_source.g.dart';

@Riverpod(keepAlive: true)
class BookSource extends _$BookSource {
  final log = Logger('book_source_provider');
  @override
  Future<List<BookSourceModel>> build() async {
    log.info("加载书源");
    listenSelf(onSelfChange);
    return await BookSourceLoadAllJs().call();
  }

  addFromFile() async {
    final res = await BookSourceAddFromFileUseCase().call();
    if (res != null) {
      state = AsyncData([res, ...(state.value ?? [])]);
    }
  }

  delete(String uuid) async {
    final deleteRes = await BookSourceDeleteUseCase().call(uuid);
    if (deleteRes) {
      state = AsyncData(state.value?.where((element) => element.uuid != uuid).toList() ?? []);
    }
  }

  toggleEnabled(String uuid) async {
    final index = state.value!.indexWhere((element) => element.uuid == uuid);
    if (index == -1) return;
    final newList = [...state.value!];
    final bookSource = state.value![index];
    final newBookSource = bookSource.copyWith(enabled: !bookSource.enabled);
    newList[index] = newBookSource;
    log.info(newList);
    state = AsyncData(newList);
  }

  onSelfChange(AsyncValue<List<BookSourceModel>>? oldValue, AsyncValue<List<BookSourceModel>> newValue) {
    // BookSourceUpdateManifestUseCase().call(newValue.value ?? []);
  }
}
