import 'dart:convert';

import 'package:core/src/interfaces/use_case.dart';
import 'package:core/src/models/book_source.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rc/rc.dart';

class BookSourceGetInfoUsecase implements UseCase<String, BookSourceModel> {
  @override
  BookSourceModel call(String uuid) {
    final envs = jsGetAttributes(uuid: uuid, keys: ["name", "author", "forms", "actions"]);
    final forms =
        (jsonDecode(envs["forms"] ?? "[]") as List)
            .map<BookSourceFormModel>((e) => BookSourceFormModel.fromJson(e))
            .toList();
    final actions = (jsonDecode(envs["actions"] ?? "[]") as List);
    return BookSourceModel(
      uuid: uuid,
      name: envs["name"]!,
      author: envs["author"]!,
      forms: forms,
      actions: actions,
      userAgent: envs["userAgent"],
      updateDate: Jiffy.now().format(pattern: "yyyy-MM-dd HH:mm:ss"),
      description: envs["description"],
    );
  }
}
