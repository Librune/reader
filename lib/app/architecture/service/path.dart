import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reader/app/architecture/utils/log.dart';
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
    final List _themes = ['clearnight', 'dawn', 'drift', 'landscape', 'serenity'];
    final targetDir = Directory(readerThemesPath);
    // if (targetDir.existsSync()) {
    //   targetDir.deleteSync(recursive: true);
    // }
    if (!targetDir.existsSync()) {
      targetDir.createSync(recursive: true);
      for (var themeKey in _themes) {
        final themeDir = Directory(join(readerThemesPath, '$themeKey'));
        final _themeJson = 'assets/themes/$themeKey.json';
        final _themePng = 'assets/themes/$themeKey.png';
        final themeJson = join(themeDir.path, 'index.json');
        final themePng = join(themeDir.path, 'image.png');
        themeDir.createSync(recursive: true);
        final themeJsonFile = File(themeJson);
        final themeJsonAsset = await rootBundle.loadString(_themeJson);
        themeJsonFile.writeAsStringSync(themeJsonAsset);
        final themePngFile = File(themePng);
        final themePngAsset = await rootBundle.load(_themePng);
        themePngFile.writeAsBytesSync(themePngAsset.buffer.asUint8List());
      }
      localStorage.setItem("themes", jsonEncode(_themes));
    }
  }
}
