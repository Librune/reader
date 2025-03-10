import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:core/src/services/path.dart';

class BookSourceUpdateManifestUseCase implements UseCase<List<BookSourceModel>, void> {
  final log = Logger('update_manifest_use_case');
  @override
  void call(List<BookSourceModel> input) {
    log.info(input);
    final arr =
        input.map((val) {
          return Map<String, dynamic>.from({"name": val.name, "author": val.author, "uuid": val.uuid, "enabled": true});
        }).toList();
    final json = jsonEncode(arr);
    File(PathService().bookSourceManifest).writeAsString(json);
  }
}
