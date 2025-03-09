import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Type { success, error, warning, info }

/// Toast 工具类，提供不同类型的提示信息
class ToastUtil {
  /// Toast 类型枚举

  /// 样式配置
  static const Map<Type, _ToastStyle> _styles = {
    Type.success: _ToastStyle(
      color: Color(0xFF10B981), // 绿色
      icon: Icons.check_circle_outlined,
      title: '成功',
    ),
    Type.error: _ToastStyle(
      color: Color(0xFFEF4444), // 红色
      icon: Icons.error_outline,
      title: '错误',
    ),
    Type.warning: _ToastStyle(
      color: Color(0xFFF59E0B), // 黄色
      icon: Icons.warning_amber_outlined,
      title: '警告',
    ),
    Type.info: _ToastStyle(
      color: Color(0xFF3B82F6), // 蓝色
      icon: Icons.info_outline,
      title: '提示',
    ),
  };

  /// 显示 Toast
  static void _show({required String message, required Type type, Duration? duration, String? title}) {
    final style = _styles[type]!;

    Widget toast = Container(
      constraints: const BoxConstraints(maxWidth: 420, minWidth: 240),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: .1), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(style.icon, color: style.color, size: 18),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? style.title,
                  style: TextStyle(color: style.color, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Color(0xFF64748B), // Slate 500
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              appToast.removeCustomToast();
            },
            child: const Icon(
              Icons.close,
              size: 16,
              color: Color(0xFF94A3B8), // Slate 400
            ),
          ),
        ],
      ),
    );

    appToast.showToast(
      child: toast,
      toastDuration: duration ?? const Duration(seconds: 5),
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(right: 16, bottom: 28, child: child);
      },
    );
  }

  /// 成功提示
  static void success(String message, {Duration? duration, String? title}) {
    _show(message: message, type: Type.success, duration: duration, title: title);
  }

  /// 错误提示
  static void error(String message, {Duration? duration, String? title}) {
    _show(message: message, type: Type.error, duration: duration, title: title);
  }

  /// 警告提示
  static void warning(String message, {Duration? duration, String? title}) {
    _show(message: message, type: Type.warning, duration: duration, title: title);
  }

  /// 信息提示
  static void info(String message, {Duration? duration, String? title}) {
    _show(message: message, type: Type.info, duration: duration, title: title);
  }
}

/// 辅助类，存储 toast 样式
class _ToastStyle {
  final Color color;
  final IconData icon;
  final String title;

  const _ToastStyle({required this.color, required this.icon, required this.title});
}
