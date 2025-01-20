import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class BookSourceLibsUsecase {
  final JavascriptRuntime runtime;
  static BookSourceLibsUsecase? _instance;

  // 私有构造函数
  BookSourceLibsUsecase._internal(this.runtime);

  // 工厂构造函数
  factory BookSourceLibsUsecase(JavascriptRuntime jsRuntime) {
    _instance ??= BookSourceLibsUsecase._internal(jsRuntime);
    return _instance!;
  }

  // 实例方法
  Future<void> fromBundle(String name) async {
    final js = await rootBundle.loadString('assets/js/$name.js');
    await runtime.evaluateAsync(js);
  }
}
