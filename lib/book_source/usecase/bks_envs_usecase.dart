import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reader/book_source/usecase/bks_files_usecase.dart';

class BksEnvsUsecase {
  static save(GlobalKey<FormBuilderState> key, {required String uuid}) {
    key.currentState?.saveAndValidate();
    final data = key.currentState?.value;
    BksFilesUsecase.getEnvFile(uuid).writeAsStringSync(jsonEncode(data));
    Fluttertoast.showToast(
        msg: "保存成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  static read({required String uuid}) => jsonDecode(BksFilesUsecase.getEnvFile(uuid).readAsStringSync());
}
