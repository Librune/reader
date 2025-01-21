import 'dart:io';

import 'package:dartx/dartx_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/book_source/provider/book_source_provider.dart';

class BookSourceManageUsecase {
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
    final dirPath = join(PathService().bookSourcePath, uuid);
    if (!Directory(dirPath).existsSync()) {
      Directory(dirPath).createSync(recursive: true);
    }
    final target = join(PathService().bookSourcePath, uuid, name);
    return await file.copy(target);
  }

  static Future<BookSourceModel> _pickJs(File file) async {
    final bookSource = await BookSourceService().injectBookSourceFromFile(file);
    await _copyFile(file, uuid: bookSource.uuid);
    return bookSource;
  }

  static Future pickNew(WidgetRef ref) async {
    final file = await _pickFile();
    if (!file.name.endsWith(".js")) {
      Fluttertoast.showToast(
          msg: "暂时只支持 js 文件",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      return;
    } else {
      await _pickJs(file);
      ref.read(bookSourceProvider.notifier).refresh();
    }
  }

  static remove(WidgetRef ref, {required String uuid}) async {
    await BookSourceService().remove(uuid);
    ref.read(bookSourceProvider.notifier).refresh();
  }
}
