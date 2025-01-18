import 'package:logging/logging.dart';

/// 日志工具类
class Log {
  // ANSI 颜色转义码
  static const String _reset = '\x1B[0m';
  static const String _blue = '\x1B[34m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _purple = '\x1B[35m';

  // 私有构造函数
  Log._internal(this._tag);

  // tag标记
  final String _tag;

  // 缓存不同tag的Logger实例
  static final Map<String, Log> _cache = {};

  /// 工厂构造函数 - 根据tag获取Logger实例
  factory Log(String tag) {
    return _cache.putIfAbsent(tag, () => Log._internal(tag));
  }

  // 获取logger实例
  Logger get _logger => Logger(_tag);

  /// 调试日志 - 蓝色
  void d(dynamic message) {
    _logger.fine('$_blue$message$_reset');
  }

  /// 信息日志 - 绿色
  void i(dynamic message) {
    _logger.info('$_green$message$_reset');
  }

  /// 警告日志 - 黄色
  void w(dynamic message) {
    _logger.warning('$_yellow$message$_reset');
  }

  /// 错误日志 - 红色
  void e(dynamic message) {
    _logger.severe('$_red$message$_reset');
  }

  /// 致命错误日志 - 紫色
  void f(dynamic message) {
    _logger.shout('$_purple$message$_reset');
  }

  /// 初始化日志配置
  static void init() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.time}: ${record.level.name}: ${record.loggerName}: ${record.message}');
    });
  }
}
