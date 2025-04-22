import 'dart:convert';

import 'package:core/core.dart';
import 'package:rc/rc.dart';

class BookSourceService {
  static final BookSourceService _instance = BookSourceService._internal();
  factory BookSourceService() => _instance;
  BookSourceService._internal();

  final Map<String, Map<String, dynamic>> bookCores = {};

  init() async {}

  add(String code) async {
    var metadata = await getCodeMetadata(code: code);
    return jsonDecode(metadata);
  }

  runAction(BookSourceActionOptions options) async {
    var uuid = options.uuid;
    String code = bookCores[uuid]!['code'];
    var res = await runCoreAction(
      code: code,
      action: options.action,
      envs: options.params,
    );
    return res.toString();
  }
}
