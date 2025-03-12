import 'dart:io';

import 'package:core/src/interfaces/use_case.dart';
import 'package:core/src/services/path.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:path/path.dart';

class BookSourceDeleteUseCase implements UseCase<String, Future<bool>> {
  @override
  Future<bool> call(String uuid) async {
    final result = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: '删除书源',
      text: '确定要删除书源吗？脚本和数据将一起被移除，无法恢复',
      positiveButtonTitle: "删除",
      negativeButtonTitle: "取消",
    );
    switch (result) {
      case CustomButton.positiveButton:
        // 删除书源
        final bookSourceDir = Directory(join(PathService().bookSourceDir, uuid));
        if (await bookSourceDir.exists()) {
          await bookSourceDir.delete(recursive: true);
          return true;
        }
        break;
      default:
        break;
    }
    return false;
  }
}
