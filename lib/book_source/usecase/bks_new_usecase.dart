import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/book_source/usecase/bks_runtime_usecase.dart';

class BookSourceNewUsecase {
  static final bksDir = join(PathService().appPath, 'bks');
  static Future<File> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: BookSourceFileType.values.map((e) => e.name).toList(), type: FileType.custom);
    if (result != null) {
      return File(result.files.single.path!);
    } else {
      // User canceled the picker
      Fluttertoast.showToast(
          msg: "未选择任何文件",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
    throw Exception('未选择任何文件');
  }

  static _copyFile(File file, {required String uuid, String name = 'index.js'}) async {
    final dirPath = join(bksDir, uuid);
    if (!Directory(dirPath).existsSync()) {
      Directory(dirPath).createSync(recursive: true);
    }
    final target = join(bksDir, uuid, name);
    return await file.copy(target);
  }

  static Future<BookSourceModel> js() async {
    final file = await _pickFile();
    final bks = await BookSourceRuntimeUseCase(file: file).info();
    await _copyFile(file, uuid: bks.uuid);
    return bks;
  }
}
