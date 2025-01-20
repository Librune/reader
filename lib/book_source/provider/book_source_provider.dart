import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/book_source/usecase/bks_new_usecase.dart';
import 'package:reader/book_source/usecase/bks_runtime_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_source_provider.g.dart';

@Riverpod(keepAlive: true)
class BookSource extends _$BookSource {
  final _log = Log('bksProvider');
  final bksPath = join(PathService().appPath, "bks");
  @override
  Future<List<BookSourceModel>> build() async {
    listenSelf(onSelfChange);
    if (bksManifest.existsSync()) {
      try {
        final json = jsonDecode(bksManifest.readAsStringSync());
        final List<BookSourceModel> list = [];
        for (var ele in json) {
          final bks = await BookSourceRuntimeUseCase(uuid: ele["uuid"]).info();
          list.add(bks);
        }
        return list;
      } catch (e) {
        return [];
      }
    } else {
      bksManifest.createSync(recursive: true);
      return [];
    }
  }

  pickNew({BookSourceFileType type = BookSourceFileType.js}) async {
    switch (type) {
      case BookSourceFileType.js:
        final data = state.value!;
        final bks = await BookSourceNewUsecase.js();
        final testExist = data.where((_bks) => _bks.name == bks.name && _bks.author == bks.author);
        if (testExist.isNotEmpty) {
          return;
        }
        state = AsyncData([bks, ...data]);
        return;
      default:
        return;
    }
  }

  delete(String uuid) {
    final data = state.value!;
    final index = data.indexWhere((element) => element.uuid == uuid);
    if (index != -1) {
      final bks = data[index];
      final dir = Directory(join(bksPath, bks.uuid));
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
      data.removeAt(index);
      state = AsyncData(data);
    }
  }

  onSelfChange(AsyncValue<List<BookSourceModel>>? oldVal, AsyncValue<List<BookSourceModel>> newVal) {
    final data = newVal.value;
    if (data == null) return;
    final arr = data.map((val) {
      return Map<String, dynamic>.from({
        "name": val.name,
        "author": val.author,
        "uuid": val.uuid,
        "enabled": true,
      });
    }).toList();
    final json = jsonEncode(arr);
    bksManifest.writeAsStringSync(json);
  }

  File get bksManifest => File(join(bksPath, "index.json"));
}
