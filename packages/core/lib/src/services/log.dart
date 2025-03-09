import 'package:core/src/services/path.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import 'package:ubuntu_logger/ubuntu_logger.dart';

setupLogService() {
  final now = Jiffy.now().format(pattern: "yyyy_MM_dd_HH_mm_ss");
  final logPath = join(PathService().logsDir, "$now.log");
  Logger.setup(path: logPath, level: LogLevel.info);
}
