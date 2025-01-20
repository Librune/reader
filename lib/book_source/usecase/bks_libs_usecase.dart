import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class BookSourceLibsUsecase {
  // 实例方法
  static Future<void> fromBundle(JavascriptRuntime runtime, {required String name}) async {
    final js = await rootBundle.loadString('assets/js/$name.js');
    await runtime.evaluateAsync(js);
  }
}
