import 'package:core/core.dart';

final bookStatus = ["连载中", "已完结", "已下架", '已断更'];

extension BookDetailExtension on BookDetail {
  List<String> get infoLines {
    final lines = <String>[];
    // 第一行
    final author = this.author ?? "未知作者";
    final status = this.status;
    final wordCount = this.wordCount;
    final infos = [author];
    if (status != null) {
      infos.add(bookStatus[status.index]);
    }
    if (wordCount != null) {
      infos.add("${formatReadableNumber(wordCount.toInt())}字");
    }
    lines.add(infos.take(3).join("\t\t|\t\t"));
    if (latestChapter != null) {
      final latestChapter = this.latestChapter!;
      lines.add("最新章节：${latestChapter.name}");
      if (latestChapter.updateTime != null) {
        lines.add("更新时间：${latestChapter.updateTime}");
      }
    }
    if (tags != null && tags!.isNotEmpty) {
      lines.add(tags!.join("、"));
    }
    if (copyRight != null && copyRight!.isNotEmpty) {
      lines.add(copyRight!);
    }

    return lines.take(4).toList();
  }
}

String formatReadableNumber(num number) {
  if (number < 10000) {
    return number.toString();
  } else {
    // 将数字除以10000
    double inWan = number / 10000;

    // 处理小数部分，如果是整数则不显示小数点
    if (inWan == inWan.truncate()) {
      return '${inWan.toInt()}万';
    } else {
      // 保留一位小数，并移除尾随的0
      String formatted = inWan.toStringAsFixed(1);
      if (formatted.endsWith('.0')) {
        formatted = formatted.substring(0, formatted.length - 2);
      }
      return '$formatted万';
    }
  }
}
