import 'dart:convert';
import 'dart:io';

import 'package:flutter_js/flutter_js.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_source.g.dart';
part 'book_source.freezed.dart';

enum BookSourceFileType { js, ts, wasm, zip, bks }

@freezed
class BookSourceModel with _$BookSourceModel {
  const factory BookSourceModel({
    required String js,
    required String name,
    required String author,
    @Default(true) enabled,
    @Default([]) List<dynamic> actions,
    @Default([]) List<BookSourceFormModel> forms,
    String? favIcon,
    String? uuid,
  }) = _BookSourceModel;
  factory BookSourceModel.fromJson(Map<String, dynamic> json) => _$BookSourceModelFromJson(json);
  const BookSourceModel._();

  JavascriptRuntime get jsRuntime => getJavascriptRuntime(forceJavascriptCoreOnAndroid: false)
    ..setInspectable(true)
    ..evaluate("""
class __BOOK_SOURCE__ {
  export(obj){
    return JSON.stringify(obj)
  }

  info(){
    return this.export({
      name: this.name,
      author: this.author
    })
  }
};
""")
    ..evaluateAsync("""
$js
const instance = new BookSource();
""");

  static Future<BookSourceModel> fromJs(File jsFile) async {
    JavascriptRuntime jsRuntime = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false)
      ..setInspectable(true)
      ..evaluate("""
class __BOOK_SOURCE__ {
  export(obj){
    return JSON.stringify(obj)
  }

  info(){
    return this.export({
      name: this.name,
      author: this.author
    })
  }
};
""");
    try {
      String js = await jsFile.readAsString();
      JsEvalResult jsResult = await jsRuntime.evaluateAsync("""
$js
const instance = new BookSource();
instance.info();
""");
      return BookSourceModel.fromJson({...jsonDecode(jsResult.stringResult), "js": js});
    } catch (e) {
      throw Exception('Failed to parse JS file: ${e.toString()}');
    }
  }
}

@freezed
class BookSourceFormModel with _$BookSourceFormModel {
  const factory BookSourceFormModel({
    required String title,
    required String? subtitle,
    required List<BookSourceFormItemGroup> form,
  }) = _BookSourceFormModel;
  factory BookSourceFormModel.fromJson(Map<String, dynamic> json) => _$BookSourceFormModelFromJson(json);
  const BookSourceFormModel._();
}

enum BookSourceFormItemType { input, button, checkbox, select, toggle }

@freezed
class BookSourceFormItemGroup with _$BookSourceFormItemGroup {
  const factory BookSourceFormItemGroup({
    required BookSourceFormItemType type,
    required String field,
    required String title,
    required String? placeholder,
  }) = _BookSourceFormItemGroup;
  factory BookSourceFormItemGroup.fromJson(Map<String, dynamic> json) => _$BookSourceFormItemGroupFromJson(json);
  const BookSourceFormItemGroup._();
}
