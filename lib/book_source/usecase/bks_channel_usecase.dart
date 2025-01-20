import 'package:flutter_js/flutter_js.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'bks_libs_usecase.dart';

class BookSourceChannelUsecase {
  static void inject(JavascriptRuntime jsRuntime) {
    jsRuntime.onMessage("invokeToast", _invokeToast);
    jsRuntime.onMessage("invokeRequire", _invokeRequire);
  }

  static void _invokeToast(dynamic message) {
    Fluttertoast.showToast(
        msg: message['data'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  static void _invokeRequire(dynamic message) {
    final lib = message['data'];
    // _invokeToast(message);
    // BookSourceLibsUsecase.fromBundle(this,name:lib);
  }
}
