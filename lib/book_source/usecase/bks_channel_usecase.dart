import 'package:flutter_js/flutter_js.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BksChannelUsecase {
  static void inject(JavascriptRuntime jsRuntime) {
    jsRuntime.onMessage("invokeToast", _invokeToast);
  }

  static void _invokeToast(dynamic message) {
    Fluttertoast.showToast(
        msg: message['data'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }
}
