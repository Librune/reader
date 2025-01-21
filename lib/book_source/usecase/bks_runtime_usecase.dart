import 'dart:convert';
import 'dart:io';

import 'package:flutter_js/extensions/fetch.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/book_source/usecase/bks_channel_usecase.dart';
import 'package:uuid/uuid.dart';

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
const INCLUDE = """
function include(lib){
  sendMessage('invokeRequire', JSON.stringify({data:lib}));
}
""";

const BOOK_SOURCE_SUPER_CLASS = """
class __BOOK_SOURCE__ {
  export(obj){
    return JSON.stringify(obj)
  }

  action=async(act,args)=>{
    return this[act](args);
  }

  toast=(message)=>{
    sendMessage('invokeToast', JSON.stringify({data:message}));
  }

  info=()=>{
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
""";

class BookSourceRuntimeUseCase {
  // 静态实例缓存Map
  static final Map<String, BookSourceRuntimeUseCase> _instances = {};
  // jsRuntime实例
  late final JavascriptRuntime jsRuntime;
  // uuid
  final String uuid;

  final String bksPath = join(PathService().appPath, 'bks');

  // 私有构造函数
  BookSourceRuntimeUseCase._internal(this.uuid) {
    jsRuntime = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false);
    jsRuntime.setInspectable(true);
    // jsRuntime.enableFetch();
  }

  // 工厂构造方法
  factory BookSourceRuntimeUseCase({File? file, String? uuid}) {
    uuid ??= Uuid().v4();
    return _instances.putIfAbsent(uuid, () {
      var instance = BookSourceRuntimeUseCase._internal(uuid!);
      BookSourceChannelUsecase.inject(instance.jsRuntime);
      instance._initRuntime(file: file, uuid: uuid);
      return instance;
    });
  }

  // 初始化runtime
  void _initRuntime({File? file, String? uuid}) {
    _super(jsRuntime);
    final js = file != null
        ? file.readAsStringSync()
        : File(join(PathService().appPath, "bks", uuid!, "index.js")).readAsStringSync();
    jsRuntime.evaluate("""$js
      var bks = new BookSource();""");
  }

  _super(JavascriptRuntime jsRuntime) {
    jsRuntime.evaluate("""
      $INCLUDE 
      $PRXOY_JS_OBJ
      $LOG_JS_OBJ
      $BOOK_SOURCE_SUPER_CLASS
    """);
  }

  // 执行JS代码
  Future<void> evaluate(String js) async {
    // await jsRuntime.evaluateAsync("""
    //   $js
    //   var bks = new BookSource();
    // """);
    // jsRuntime.executePendingJob();
  }

  // 获取书源信息
  Future<BookSourceModel> info() async {
    final res = await jsRuntime.evaluateAsync("""bks.info();""");
    return BookSourceModel.fromJson({...jsonDecode(res.stringResult), "uuid": uuid});
  }

  // 顶部菜单行为
  action(String act, {List<dynamic>? args}) async {
    jsRuntime.executePendingJob();
    final res = await jsRuntime.evaluateAsync("""
      bks.action('$act',${args != null ? jsonEncode(args) : ''});
    """);
    JsEvalResult asyncResult = await jsRuntime.handlePromise(res);
    return asyncResult.stringResult;
  }

  // 清除指定实例
  static void dispose(String uuid) {
    _instances.remove(uuid);
  }

  // 清除所有实例
  static void disposeAll() {
    _instances.clear();
  }
}
