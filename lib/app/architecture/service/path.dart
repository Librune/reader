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

  init() async {
    docPath = (await getApplicationDocumentsDirectory()).path;
    cachePath = (await getApplicationCacheDirectory()).path;
    appPath = (await getApplicationSupportDirectory()).path;
  }
}
