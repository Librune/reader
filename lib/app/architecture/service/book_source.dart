import 'dart:convert';
import 'dart:io';

import 'package:flutter_js/flutter_js.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/book_source/usecase/bks_channel_usecase.dart';
import 'package:uuid/uuid.dart';

class BookSourceService {
  // jsRuntime实例
  late final JavascriptRuntime runtime;
  final List<BookSourceModel> bookSourceList = [];
  static final BookSourceService _instance = BookSourceService._internal();
  BookSourceService._internal();
  factory BookSourceService() {
    return _instance;
  }

  init() async {
    _initJsRuntime();
  }

  _initJsRuntime() async {
    runtime = getJavascriptRuntime(forceJavascriptCoreOnAndroid: false)..setInspectable(true);
    await _bootstrap();
    await _initBookSourceObjects();
  }

  _bootstrap() async {
    await runtime.evaluateAsync("""
      $INCLUDE 
      $PRXOY_JS_OBJ
      $LOG_JS_OBJ
      $BOOK_SOURCE_SUPER_CLASS
    """);
    BookSourceChannelUsecase.inject(runtime);
  }

  _initBookSourceObjects() async {
    final bksList = [];
    try {
      if (!bksManifest.existsSync()) {
        bksManifest.createSync(recursive: true);
      } else {
        final json = jsonDecode(bksManifest.readAsStringSync()) as List<dynamic>;
        bksList.addAll(json.where(((bks) => bks["enabled"] == true)));
      }
    } catch (e) {
      bksManifest.writeAsStringSync("[]");
    }
    for (var bks in bksList) {
      await injectBookSource(bks["uuid"]);
    }
  }

  injectBookSource(String uuid) async {
    final bksFile = File(join(PathService().bookSourcePath, uuid, "index.js"));
    final js = bksFile.readAsStringSync();
    final isInjected = await runtime.evaluateAsync("""
      __BOOK_SOURCE_MAP__.hasOwnProperty('$uuid')
    """);
    if (isInjected.stringResult == "false") {
      final bookSourceEnvs = PathService().getEnvFile(uuid);
      final envs = bookSourceEnvs.readAsStringSync();
      await runtime.evaluateAsync("""
        __BOOK_SOURCE_MAP__['$uuid'] = (()=>{
          $js
          return new BookSource('$uuid','$envs');
        })()
      """);
    }
    bookSourceList.add(await getBookSourceInfo(uuid));
  }

  Future<BookSourceModel> injectBookSourceFromFile(File file) async {
    final js = file.readAsStringSync();
    final uuid = Uuid().v4();
    final realUuid = await runtime.evaluateAsync("""
        const obj = (()=>{
          $js
          return new BookSource();
        })()
        const realUuid = obj.uuid || '$uuid';
        __BOOK_SOURCE_MAP__[realUuid] = obj;
        realUuid
      """);
    final bookSource = await getBookSourceInfo(realUuid.stringResult);
    if (!bookSourceList.any((element) => element.uuid == bookSource.uuid)) {
      bookSourceList.add(bookSource);
    }
    return bookSource;
  }

  Future<BookSourceModel> getBookSourceInfo(String uuid) async {
    final res = await runtime.evaluateAsync("""
      __BOOK_SOURCE_MAP__['$uuid'].info();
    """);
    return BookSourceModel.fromJson({...jsonDecode(res.stringResult), "uuid": uuid});
  }

  updateEnvs(String uuid, Map<String, dynamic> envs) async {
    await runtime.evaluateAsync("""
      __BOOK_SOURCE_MAP__['$uuid'].__envs__ = JSON.parse('${jsonEncode(envs)}');
    """);
  }

  remove(String uuid) async {
    await runtime.evaluateAsync("""
      delete __BOOK_SOURCE_MAP__['$uuid']
    """);
    bookSourceList.removeWhere((element) => element.uuid == uuid);
  }

  lsitAll() async {
    final res = await runtime.evaluateAsync("""
      Object.keys(__BOOK_SOURCE_MAP__)
    """);
    Log.d("listAll: ${res.stringResult}");
  }

  action({required String uuid, required String act, List<dynamic>? args}) async {
    runtime.executePendingJob();
    final res = await runtime.evaluateAsync("""
       __BOOK_SOURCE_MAP__['$uuid'].action('$act', ${args != null ? jsonEncode(args) : ''});
    """);
    JsEvalResult asyncResult = await runtime.handlePromise(res);
    return asyncResult.rawResult;
  }

  File get bksManifest => File(PathService().bookSourceManifestPath);
}

const INCLUDE = """
const __INCLUEDED_LIBS__ = [];
async function include(lib){
  if(__INCLUEDED_LIBS__.includes(lib)){
    return;
  }
  await sendMessage('invokeRequire', JSON.stringify({data:lib}));
}
""";
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
const BOOK_SOURCE_SUPER_CLASS = """
const __BOOK_SOURCE_MAP__ = {};
class __BOOK_SOURCE__ {
  uuid = '';
  __envs__ = {};

  constructor(uuid,envs) {
    this.uuid = uuid;
    this.__envs__ = JSON.parse(envs??'{}');
  }

  export(obj){
    return JSON.stringify(obj)
  }

  action=async(act,args)=>{
    return this[act](args);
  }

  toast=(message)=>{
    sendMessage('invokeToast', JSON.stringify({data:message}));
  }

  setLocalStorage=(key,value)=>{
    this.__envs__[key] = value;
    sendMessage('invokeLocalStorageSet', JSON.stringify({key,value,uuid:this.uuid}));
  }

  getLocalStorage=(key)=>{
    return sendMessage('invokeLocalStorageGet', JSON.stringify({key,uuid:this.uuid}));
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
