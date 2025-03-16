import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PathService {
  static final PathService _instance = PathService._internal();
  factory PathService() => _instance;
  PathService._internal();

  // 基础文件夹目录
  late final String doc;
  late final String cache;
  late final String app;

  // 应用日志文件夹
  String get logsDir => join(app, 'logs');

  // 书源文件夹
  late final String bookSourceDir;

  // 书源清单文件路径
  // String get bookSourceManifest => join(bookSourceDir, 'manifest.json');

  // 阅读器配置文件路径
  String get readerConfig => join(app, 'reader_config.json');

  // 阅读器额外配置文件路径
  String get readerExtraConfig => join(app, 'reader_extra_config.json');

  // 应用配置文件路径
  String get appConfig => join(app, 'app_config.json');

  // 书籍缓存文件夹
  String bookCacheDir(String bookId) => join(cache, 'books', bookId);

  init() async {
    doc = (await getApplicationDocumentsDirectory()).path;
    cache = (await getApplicationCacheDirectory()).path;
    app = (await getApplicationSupportDirectory()).path;
    bookSourceDir = join(app, 'book_source');
    // 如果不存在则创建
    if (!Directory(bookSourceDir).existsSync()) {
      Directory(bookSourceDir).createSync(recursive: true);
    }
  }

  // Directory getBookCacheDir(BookModel book) {
  //   final dir = Directory(
  //       join(cachePath, 'books', "${book.bookSourceId!}-${book.bookId}"));
  //   if (!dir.existsSync()) {
  //     dir.createSync(recursive: true);
  //   }
  //   return dir;
  // }
}
