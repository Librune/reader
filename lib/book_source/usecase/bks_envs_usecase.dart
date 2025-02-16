import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/book_source/usecase/bks_files_usecase.dart';

class BksEnvsUsecase {
  static save(GlobalKey<FormBuilderState> key, {required String uuid}) {
    key.currentState?.saveAndValidate();
    final data = key.currentState?.value;
    if (data == null) return;
    BookSourceService().updateEnvs(uuid, data.map((key, value) => MapEntry(key, value.toString())));
    BookSourceFilesUsecase.getEnvFile(uuid).writeAsStringSync(jsonEncode(data));
    Fluttertoast.showToast(
        msg: "保存成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  static read({required String uuid}) => jsonDecode(BookSourceFilesUsecase.getEnvFile(uuid).readAsStringSync());

  static Future syncValueToJs(GlobalKey<FormBuilderState> key, {required String uuid}) async {
    key.currentState?.saveAndValidate();
    final data = key.currentState?.value;
    if (data == null) return;
    await BookSourceService().updateEnvs(uuid, data.map((key, value) => MapEntry(key, value.toString())));
  }
}
