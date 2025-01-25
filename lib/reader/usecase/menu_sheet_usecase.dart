import 'package:flutter/material.dart';

class MenuSheetUsecase {
  static final MenuSheetUsecase _instance = MenuSheetUsecase._internal();
  factory MenuSheetUsecase() => _instance;
  MenuSheetUsecase._internal();

  final sheetCtx = GlobalKey();

  void show() {}
}
