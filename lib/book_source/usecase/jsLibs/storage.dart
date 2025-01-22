import 'dart:convert';

import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';

localStorageSet(dynamic args) {
  Log.e("localStorageSet: $args");
  final uuid = args['uuid'];
  final key = args['key'];
  final value = args['value'];
  final destEnvsFile = PathService().getEnvFile(uuid);
  final envs = jsonDecode(destEnvsFile.readAsStringSync());
  final newEnvs = {
    ...envs,
    key: value,
  };
  destEnvsFile.writeAsStringSync(jsonEncode(newEnvs));
}

localStorageGet(dynamic args) {
  Log.e("localStorageGet: $args");
  final uuid = args['uuid'];
  final key = args['key'];
  final destEnvsFile = PathService().getEnvFile(uuid);
  final envs = jsonDecode(destEnvsFile.readAsStringSync());
  return envs[key];
}

const INJECT_LOCAL_STORAGE = """
globalThis.localStorage = {
  setItem: (key, value) => {
    sendMessage("invokeLocalStorageSet",JSON.stringify({key,value,uuid:this.uuid}))
  },
  getItem: (key) => {
    sendMessage("invokeLocalStorageGet",JSON.stringify({key,value,uuid:this.uuid}))
  },
};
""";
