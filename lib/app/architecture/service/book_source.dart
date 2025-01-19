// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter_js/flutter_js.dart';
// import 'package:path/path.dart';
// import 'package:reader/app/architecture/service/path.dart';
// import 'package:reader/app/architecture/utils/log.dart';
// import 'package:reader/book_source/data/model/book_source.dart';

// enum BookSourceFileType { js, ts, wasm, zip, bks }

// class BookSource {
//   final _appDirPath = PathService().appPath;
//   final Log _log = Log("BksObj");
//   late final BookSourceModel model;
//   final dynamic bks;

//   final JavascriptRuntime javascriptRuntime = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false)
//     ..setInspectable(true)
//     ..evaluate("""
// class __BOOK_SOURCE__ {
//   export(obj){
//     return JSON.stringify(obj)
//   }

//   info(){
//     return this.export({
//       name: this.name,
//       author: this.author
//     })
//   }
// };
// """);
//   late String jsStr;

//   BookSource(this.bks)
//       : assert(bks != null && ["String", "_File", "Directory"].contains((bks.runtimeType.toString()))) {
//     if (bks.runtimeType.toString() == "String") {
//       try {
//         jsonDecode(bks as String);
//         jsStr = bks as String;
//       } catch (err) {
//         final file = File(join(_appDirPath, "bks", bks as String, "index.js"));
//         jsStr = file.readAsStringSync();
//       }
//     } else if (bks.runtimeType.toString() == "_File") {
//       jsStr = (bks as File).readAsStringSync();
//     } else {
//       jsStr = File(join((bks as Directory).path, "index.js")).readAsStringSync();
//     }
//   }

//   factory BookSource.fromManifest(dynamic manifest) {
//     return BookSource(manifest["uuid"])..model = BookSourceModel.fromJson(manifest);
//   }

//   Future<BookSourceModel> info() async {
//     JsEvalResult jsResult = await javascriptRuntime.evaluateAsync("""
// $jsStr
// const instance = new BookSource();
// instance.info();
// """);
//     model = BookSourceModel.fromJson(jsonDecode(jsResult.stringResult));
//     return model;
//   }
// }
