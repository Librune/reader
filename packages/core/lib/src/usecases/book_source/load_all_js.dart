import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:core/src/services/path.dart';
import 'package:core/src/usecases/book_source/get_info.dart';
import 'package:path/path.dart';
import 'package:rc/rc.dart';

class BookSourceLoadAllJs implements NoParamUseCase<Future<List<BookSourceModel>>> {
  final log = Logger('book_source_load_all_js');
  @override
  Future<List<BookSourceModel>> call() async {
    final bookSourceList = <BookSourceModel>[];
    if (!bookSourceManifest.existsSync()) bookSourceManifest.createSync(recursive: true);
    final json = jsonDecode(bookSourceManifest.readAsStringSync()) as List<dynamic>;
    for (var bookSource in json) {
      final uuid = bookSource["uuid"];
      final file = File(join(PathService().bookSourceDir, uuid, "index.js"));
      final jsCode = await file.readAsString();
      insertJsScript(uuid: uuid, code: jsCode);
      bookSourceList.add(BookSourceGetInfoUsecase().call(uuid));
    }
    return bookSourceList;
  }

  File get bookSourceManifest => File(PathService().bookSourceManifest);
}
