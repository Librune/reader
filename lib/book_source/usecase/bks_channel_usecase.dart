import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reader/book_source/usecase/jsLibs/fetch.dart';

import 'bks_libs_usecase.dart';

class BookSourceChannelUsecase {
  static void inject(JavascriptRuntime jsRuntime) {
    _injectFetch(jsRuntime);
    jsRuntime.onMessage("invokeToast", _invokeToast);
    jsRuntime.onMessage("invokeRequire", _invokeRequire(jsRuntime));
    jsRuntime.onMessage("invokeToMd5", _invokeToMd5);
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
    // _invokeToast(message);
    // BookSourceLibsUsecase.fromBundle(this,name:lib);
    return (dynamic message) {
      BookSourceLibsUsecase.fromBundle(jsRuntime, name: message['data']);
    };
  }

  static _invokeToMd5(dynamic message) {
    // _invokeToast(message);
    // BookSourceLibsUsecase.fromBundle(this,name:lib);
    // return FlutterMd5().convert(message['data']);
    var bytes = utf8.encode(message['data']); // data being hashed
    md5.convert(bytes).toString();
  }
}
