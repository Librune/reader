import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:uuid/uuid.dart';

part 'book_source.g.dart';
part 'book_source.freezed.dart';

enum BookSourceFileType { js, ts, wasm, zip, bks }

@freezed
class BookSourceModel with _$BookSourceModel {
  const factory BookSourceModel({
    required String js,
    required String uuid,
    required String name,
    required String author,
    @Default(true) enabled,
    @Default([]) List<dynamic> actions,
    @Default([]) List<BookSourceFormModel> forms,
    String? favIcon,
  }) = _BookSourceModel;
  factory BookSourceModel.fromJson(Map<String, dynamic> json) => _$BookSourceModelFromJson(json);
  const BookSourceModel._();

  JavascriptRuntime get jsRuntime => getJavascriptRuntime(forceJavascriptCoreOnAndroid: false)
    ..setInspectable(true)
    ..evaluate("""
$PRXOY_JS_OBJ
$LOG_JS_OBJ
class __BOOK_SOURCE__ {
  export(obj){
    return JSON.stringify(obj)
  }

  info(){
    return this.export({
      name: this.name,
      author: this.author,
    })
  }
};
""")
    ..evaluateAsync("""
$js
const instance = new BookSource();
""");

  String get bksPath => join(PathService().appPath, 'bks');

  File get envsFile {
    final file = File(join(bksPath, uuid, "envs.json"));
    if (!file.existsSync()) {
      file.writeAsStringSync("{}");
    }
    return file;
  }

  Map<String, dynamic> get envs => jsonDecode(envsFile.readAsStringSync());

  saveEnvs(GlobalKey<FormBuilderState> key) {
    key.currentState?.saveAndValidate();
    final data = key.currentState?.value;
    envsFile.writeAsStringSync(jsonEncode(data));
    Fluttertoast.showToast(
        msg: "保存成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  static Future<BookSourceModel> fromJs(File jsFile, {String? uuid}) async {
    uuid ??= Uuid().v4();
    JavascriptRuntime jsRuntime = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false)
      ..setInspectable(true)
      ..evaluate("""
$PRXOY_JS_OBJ
$LOG_JS_OBJ
class __BOOK_SOURCE__ {
  export(obj){
    return JSON.stringify(obj)
  }

  info(){
    if(this.proxyFeature){
      this.forms.push(proxyObj)
    }
    if(this.logFeature){
      this.forms.push(logObj)
    }
    return this.export({
      name: this.name,
      author: this.author,
      forms: this.forms,
      actions: this.actions
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
      return BookSourceModel.fromJson({...jsonDecode(jsResult.stringResult), "js": js, "uuid": uuid});
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

const PRXOY_JS_OBJ = """
const proxyObj = {
      title: '网络设置',
      subtitle: '设置代理，如果你需要通过代理访问，请设置代理',
      form: [
        {
          type: 'input',
          field: 'proxy',
          title: '代理',
          placeholder: '设定代理地址',
        },
        {
          type: 'input',
          field: 'proxy',
          title: '用户名',
          placeholder: '设定用户名',
        },
        {
          type: 'input',
          field: 'proxy',
          title: '密码',
          placeholder: '设定密码',
        },
      ],
    };
""";
const LOG_JS_OBJ = """
const logObj = {
      title: '杂项',
      subtitle: '一些额外的配置项目',
      form: [
        {
          type: 'toggle',
          field: 'log',
          title: '捕获日志',
          placeholder: '是否捕获并存储请求日志到本地',
        },
      ],
    };
""";
