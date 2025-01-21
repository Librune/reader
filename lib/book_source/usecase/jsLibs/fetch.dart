import 'dart:convert';

import 'package:dio/dio.dart';

Future<Map<String, dynamic>> dioFetch(dynamic args) async {
  Uri uri = Uri.parse(args['url']);
  Map options = args['options'];
  Map<String, String> headers =
      (options["headers"] as Map<dynamic, dynamic>).map((key, value) => MapEntry("$key", "$value"));
  late Response response;
  switch (options["method"].toString().toLowerCase()) {
    case "get":
      response =
          await Dio().get(uri.toString(), options: Options(headers: headers, contentType: options["contentType"]));
      break;
    case "post":
      response = await Dio().post(uri.toString(), data: options["body"], options: Options(headers: headers));
      break;
    case "put":
      response = await Dio().put(uri.toString(), data: options["body"], options: Options(headers: headers));
      break;
    case "delete":
      response = await Dio().delete(uri.toString(), options: Options(headers: headers));
      break;
    default:
      throw Exception("Unsupported method: ${options["method"]}");
  }

  final json = {
    "ok": response.statusCode != null && (response.statusCode! >= 200 && response.statusCode! < 300),
    "status": response.statusCode,
    "statusText": response.statusMessage,
    "headers": response.headers.map.map((key, value) => MapEntry(key, value.toString())),
    "body": response.data,
    "responseURL": response.requestOptions.uri.toString(),
    "responseText": response.headers.value("content-type").toString().contains(Headers.jsonContentType)
        ? jsonEncode(response.data)
        : response.data.toString()
  };
  return json;
}

const INJECT_FETCH = """
async function dio(url,options){
  options = options || {};
  return new Promise(async function(resolve,reject){
    let request = await sendMessage("invokeFetch",JSON.stringify({url,options}))
    const response = () => ({
      ok: ((request.status / 100) | 0) == 2, // 200-299
      statusText: request.statusText,
      status: request.status,
      url: request.responseURL,
      text:()=>Promise.resolve(request.responseText),
      json:()=>Promise.resolve(request.responseText).then(JSON.parse),
      blob:()=>Promise.resolve(new Blob([request.response])),
      clone:response,
      headers:request.headers
    })

    if(request.ok) resolve(response())
    else reject(response())
  });
}
""";
