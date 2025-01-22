import 'package:flutter_js/flutter_js.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reader/book_source/usecase/jsLibs/fetch.dart';
import 'package:reader/book_source/usecase/jsLibs/storage.dart';

import 'bks_libs_usecase.dart';

class BookSourceChannelUsecase {
  static void inject(JavascriptRuntime jsRuntime) {
    _injectFetch(jsRuntime);
    _injectStorage(jsRuntime);
    jsRuntime.onMessage("invokeToast", _invokeToast);
    jsRuntime.onMessage("invokeRequire", _invokeRequire(jsRuntime));
  }

  static _injectFetch(JavascriptRuntime runtime) async {
    runtime.onMessage("invokeFetch", dioFetch);
    runtime.evaluate(INJECT_FETCH);
  }

  static _injectStorage(JavascriptRuntime runtime) async {
    runtime.onMessage("invokeLocalStorageSet", localStorageSet);
    runtime.onMessage("invokeLocalStorageGet", localStorageGet);
    // 不需要执行 runtime.evaluate(INJECT_LOCAL_STORAGE);
    // 因为是挂载到对象内部的方法，初始化时已经被继承
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
