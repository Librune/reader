import 'dart:convert';

import 'package:core/core.dart';
import 'package:core/src/providers/book_catalog.dart';
import 'package:rc/rc.dart';

import 'wk8.dart';

class BookSourceService {
  final log = Logger('book_source_service');
  static final BookSourceService _instance = BookSourceService._internal();
  factory BookSourceService() => _instance;
  BookSourceService._internal();

  final Map<String, Map<String, dynamic>> bookCores = {
    '352561f8-281c-4953-81f7-3772c6285c1c': {
      'code': wk8,
      'metadata': {
        'name': '轻小说文库',
        'uuid': '352561f8-281c-4953-81f7-3772c6285c1c',
        'baseUrl': 'http://app.wenku8.com/android.php',
        'userAgent':
            ' Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36(KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36',
        'author': 'Nexw',
      },
    },
  };

  init() async {}

  add(String code) async {
    var metadata = await getCodeMetadata(code: code);
    return metadata;
  }

  runAction(BookSourceActionOptions options) async {
    var uuid = options.uuid;
    String code = bookCores[uuid]!['code'];
    var res = await runCoreAction(
      code: code,
      action: options.action,
      envs: options.params,
    );
    return res.toString();
  }

  Future<List<SearchBook>> searchBooks(BookSourceActionOptions options) async {
    var uuid = options.uuid;
    String code = bookCores[uuid]!['code'];
    var params = options.params;
    try {
      return await coreSearchBooks(
        code: code,
        page: params['page'] ?? 1,
        key: params['key'],
        count: params['count'] ?? 10,
      );
    } catch (e) {
      log.error("搜索失败", e);
      return [];
    }
  }

  Future<BookDetail> bookDetail(BookSourceActionOptions options) async {
    var uuid = options.uuid;
    String code = bookCores[uuid]!['code'];
    return coreBookDetail(code: code, bid: options.params['bid']);
  }

  Future<List<CatalogVolume>> bookCatalog(
    BookSourceActionOptions options,
  ) async {
    var uuid = options.uuid;
    String code = bookCores[uuid]!['code'];
    return coreCatalog(code: code, bid: options.params['id']);
  }

  Future<Chapter> bookChapter(BookSourceActionOptions options) async {
    var uuid = options.uuid;
    String code = bookCores[uuid]!['code'];
    return coreChapter(
      code: code,
      bid: options.params['bid'],
      cid: options.params['cid'],
    );
  }
}
