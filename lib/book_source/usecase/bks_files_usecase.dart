import 'dart:io';

import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';

class BksFilesUsecase {
  static String get _bksPath => join(PathService().appPath, 'bks');
  static File getEnvFile(String uuid) {
    final file = File(join(_bksPath, uuid, "envs.json"));
    if (!file.existsSync()) {
      file.writeAsStringSync("{}");
    }
    return file;
  }
}
