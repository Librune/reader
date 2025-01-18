import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBookSourceUsecase {
  static Future<bool> invoke() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
    } else {
      // User canceled the picker
      Fluttertoast.showToast(
          msg: "This is Center Short Toast",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }

    return true;
  }
}
