String getBookCreationStatus(String status) {
  String result = "未知";
  switch (status) {
    case "0":
      result = "已完结";
      break;
    case "1":
      result = "连载中";
      break;
  }
  return result;
}

String formatReadableNumber(dynamic number, String label) {
  // 处理输入，确保转换为数字类型
  num value;
  if (number is String) {
    value = num.tryParse(number) ?? 0;
  } else if (number is num) {
    value = number;
  } else {
    return '0 $label';
  }

  // 定义数值单位，从万开始
  const units = ['', '万', '亿'];
  var index = 0;

  // 处理数值大小和对应单位
  while (value >= 10000 && index < units.length - 1) {
    value /= 10000;
    index += 1;
  }

  // 格式化数字，如果是整数则不显示小数点
  String formattedNumber;
  if (value == value.toInt()) {
    formattedNumber = value.toInt().toString();
  } else {
    formattedNumber = value.toStringAsFixed(1);
    // 移除末尾的.0
    if (formattedNumber.endsWith('.0')) {
      formattedNumber =
          formattedNumber.substring(0, formattedNumber.length - 2);
    }
  }

  // 拼接单位并返回
  return '$formattedNumber ${units[index]}$label';
}
