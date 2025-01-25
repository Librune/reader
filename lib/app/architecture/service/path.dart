import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reader/app/data/model/book.dart';

class PathService {
  static final PathService _instance = PathService._internal();

  factory PathService() {
    return _instance;
  }

  PathService._internal();

  late final String docPath;
  late final String cachePath;
  late final String appPath;

  late final String bookSourcePath;
  late final String bookSourceManifestPath;

  init() async {
    docPath = (await getApplicationDocumentsDirectory()).path;
    cachePath = (await getApplicationCacheDirectory()).path;
    appPath = (await getApplicationSupportDirectory()).path;
    bookSourcePath = join(appPath, 'bks');
    bookSourceManifestPath = join(bookSourcePath, 'index.json');
  }

  File getEnvFile(String uuid) {
    final file = File(join(bookSourcePath, uuid, "envs.json"));
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync("{}");
    }
    return file;
  }

  Directory getBookCacheDir(BookModel book) {
    final dir = Directory(join(cachePath, 'books', "${book.bookSourceId!}-${book.bookId}"));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }
}
