import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class ImportJsLibUsecase {
  final JavascriptRuntime runtime;
  static ImportJsLibUsecase? _instance;

  // 私有构造函数
  ImportJsLibUsecase._internal(this.runtime);

  // 工厂构造函数
  factory ImportJsLibUsecase(JavascriptRuntime jsRuntime) {
    _instance ??= ImportJsLibUsecase._internal(jsRuntime);
    return _instance!;
  }

  // 实例方法
  Future<void> fromBundle(String name) async {
    final js = await rootBundle.loadString('assets/js/$name.js');
    await runtime.evaluateAsync(js);
  }
}
