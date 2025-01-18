import 'dart:convert';
import 'dart:io';

import 'package:flutter_js/flutter_js.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';

class BookSource {
  final appDirPath = PathService().appPath;
  final dynamic bks;
  final Log _log = Log("BksObj");
  final JavascriptRuntime javascriptRuntime = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false)
    ..setInspectable(true);
  late String jsStr;
  BookSource(this.bks) : assert(bks != null && ["String", "File", "Directory"].contains((bks.runtimeType.toString()))) {
    if (bks.runtimeType.toString() == "String") {
      try {
        jsonDecode(bks as String);
        jsStr = bks as String;
      } catch (err) {
        final file = File(join(appDirPath, "bks", bks as String, "index.js"));
        jsStr = file.readAsStringSync();
      }
    } else if (bks.runtimeType.toString() == "File") {
      jsStr = (bks as File).readAsStringSync();
    } else {
      jsStr = File(join((bks as Directory).path, "index.js")).readAsStringSync();
    }
    _log.i("jsStr: $jsStr");
  }
}
