import 'dart:ui'; // 需要引入 dart:ui 库来使用 Color 类
import 'dart:math'; // 需要引入 dart:math 库来使用 Random 类

Color colorFromString(String text) {
  // 使用字符串的 hashCode 作为随机种子
  final random = Random(text.hashCode);

  // 生成随机的 RGB 值
  // 使用 128 到 255 的范围可以确保颜色不会太暗
  final r = random.nextInt(128) + 128; // 128-255
  final g = random.nextInt(128) + 128; // 128-255
  final b = random.nextInt(128) + 128; // 128-255

  // 使用 ARGB 格式创建 Color 对象，Alpha 值设为 255 (不透明)
  return Color.fromARGB(255, r, g, b);
}
