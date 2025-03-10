import 'dart:convert';

import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:rc/rc.dart';

class BookSourceExecActionOptions {
  final String uuid;
  final String action;
  final Map<String, dynamic>? params;

  BookSourceExecActionOptions({required this.uuid, required this.action, this.params});
}

class BookSourceExecAction<T extends dynamic> implements UseCase<BookSourceExecActionOptions, Future<T>> {
  final log = Logger('book_source_exec_action');
  @override
  Future<T> call(BookSourceExecActionOptions params) async {
    log.info("执行书源操作");
    final uuid = params.uuid;
    final action = params.action;
    final actionParams = jsonEncode(params.params ?? {});
    final res = await jsAction(uuid: uuid, method: action, args: actionParams);
    try {
      var dynamicRes = jsonDecode(res);
      if (dynamicRes is String) {
        return jsonDecode(dynamicRes) as T;
      } else {
        return dynamicRes as T;
      }
    } catch (e) {
      return res as T;
    }
  }
}
