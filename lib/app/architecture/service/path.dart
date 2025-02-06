import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
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

  late final String readerConfigPath;

  late final String readerThemesPath;

  init() async {
    docPath = (await getApplicationDocumentsDirectory()).path;
    cachePath = (await getApplicationCacheDirectory()).path;
    appPath = (await getApplicationSupportDirectory()).path;
    bookSourcePath = join(appPath, 'bks');
    bookSourceManifestPath = join(bookSourcePath, 'index.json');
    readerConfigPath = join(appPath, 'config.json');
    readerThemesPath = join(appPath, 'themes');

    await initReaderThemes();
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

  Future<void> initReaderThemes() async {
    final targetDir = Directory(readerThemesPath);
    if (!targetDir.existsSync()) {
      targetDir.createSync(recursive: true);
      // 加载 AssetManifest.json
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

      // 筛选 assets/themes 下的所有文件
      final themeAssets = manifestMap.keys.where((key) => key.startsWith('assets/themes/'));
      for (var assetPath in themeAssets) {
        // 获取相对路径
        final relativePath = assetPath.substring('assets/themes/'.length);
        final newPath = '${targetDir.path}/$relativePath';

        // 创建目标文件目录
        final file = File(newPath);
        file.parent.createSync(recursive: true);

        // 加载 asset 数据并写入文件
        final byteData = await rootBundle.load(assetPath);
        final bytes = byteData.buffer.asUint8List();
        await file.writeAsBytes(bytes);
      }
    }
  }
}
