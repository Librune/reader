import 'dart:convert';
import 'dart:io';

import 'package:localstorage/localstorage.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/data/model/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

@Riverpod(keepAlive: true)
class ReaderTheme extends _$ReaderTheme {
  @override
  Future<List<ReaderThemeModel>> build() async {
    final List themeIds = jsonDecode(localStorage.getItem("themes")!);
    final List<ReaderThemeModel> themes = [];
    for (var id in themeIds) {
      final themeDir = Directory(join(PathService().readerThemesPath, id));
      final themeJson =
          await File(join(themeDir.path, 'index.json')).readAsString();
      try {
        themes.add(ReaderThemeModel.fromJson(jsonDecode(themeJson)));
      } catch (err) {
        Log.e("ReaderTheme error: $err");
      }
    }
    return themes;
  }

  updateTheme(ReaderThemeModel theme) async {
    Log.d('updateTheme: ${theme.toJson()}');
  }

  Directory get themesDir => Directory(PathService().readerThemesPath);
}
