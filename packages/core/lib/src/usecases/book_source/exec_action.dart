import 'dart:convert';

import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:core/src/services/book_source.dart';

class BookSourceExecActionUseCase<T extends dynamic>
    implements UseCase<BookSourceActionOptions, Future<T>> {
  final log = Logger('book_source_exec_action');
  @override
  Future<T> call(BookSourceActionOptions params) async {
    log.info("执行书源操作", params);
    final uuid = params.uuid;
    final action = params.action;
    final actionParams = jsonEncode(params.params ?? {});
    final res = await BookSourceService().runAction(
      BookSourceActionOptions(uuid: uuid, action: action, params: actionParams),
    );
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
