import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:core/src/services/book_source.dart';
import 'package:core/src/services/path.dart';
import 'package:core/src/usecases/book_source/get_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:rc/rc.dart';
import 'package:uuid/uuid.dart';

class BookSourceAddFromFileUseCase
    implements NoParamUseCase<Future<BookSourceModel?>> {
  final log = Logger('book_source_add_from_file_use_case');
  @override
  Future<BookSourceModel?> call() async {
    log.info("从文件添加书源");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: BookSourceFileType.values.map((e) => e.name).toList(),
      type: FileType.custom,
    );
    if (result == null) {
      return null;
    }
    final file = File(result.files.single.path!);
    final text = await file.readAsString();
    // final uuid = attrs["uuid"] ?? Uuid().v4();
    // insertJsScript(uuid: uuid, code: text);
    var metadata = await BookSourceService().add(text);
    final attrs = jsonDecode(metadata);
    final uuid = attrs["uuid"];
    final bookSource = BookSourceGetInfoUsecase().call(uuid);
    // 拷贝书源文件
    final dirPath = join(PathService().bookSourceDir, uuid);
    // 如果不存在则创建
    if (!Directory(dirPath).existsSync()) {
      Directory(dirPath).createSync();
    }
    final jsPath = join(PathService().bookSourceDir, uuid, 'index.js');
    final envFile = File(join(PathService().bookSourceDir, uuid, 'env.json'));
    final String envStr =
        envFile.existsSync() ? envFile.readAsStringSync() : "{}";
    if (!envFile.existsSync()) envFile.createSync();
    // 如果存在则删除
    if (File(jsPath).existsSync()) {
      File(jsPath).deleteSync();
    }
    await file.copy(jsPath);
    // 写入env.json
    final envs = {...(jsonDecode(envStr) as Map<String, dynamic>), ...attrs};
    envFile.writeAsStringSync(jsonEncode(envs));
    return bookSource;
  }
}
