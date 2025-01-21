import 'package:flutter_js/flutter_js.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reader/book_source/usecase/jsLibs/fetch.dart';

import 'bks_libs_usecase.dart';

class BookSourceChannelUsecase {
  static void inject(JavascriptRuntime jsRuntime) {
    _injectFetch(jsRuntime);
    jsRuntime.onMessage("invokeToast", _invokeToast);
    jsRuntime.onMessage("invokeRequire", _invokeRequire(jsRuntime));
  }

  static _injectFetch(JavascriptRuntime runtime) async {
    runtime.onMessage("invokeFetch", dioFetch);
    runtime.evaluate(INJECT_FETCH);
  }

  static void _invokeToast(dynamic message) {
    Fluttertoast.showToast(
        msg: message['data'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  static _invokeRequire(JavascriptRuntime jsRuntime) {
    return (dynamic message) {
      BookSourceLibsUsecase.fromBundle(jsRuntime, name: message['data']);
    };
  }
}
