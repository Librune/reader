import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
}
