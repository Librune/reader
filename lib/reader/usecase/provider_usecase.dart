import 'package:flutter/material.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/extra.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/data/model/theme.dart';
import 'package:reader/reader/provider/catalog.dart';
import 'package:reader/reader/provider/config.dart';
import 'package:reader/reader/provider/extra.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/provider/reader.dart';
import 'package:reader/reader/provider/theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// ignore: invalid_use_of_internal_member
typedef MenuProvider = AutoDisposeNotifierProviderImpl<Menu, MenuModel>;
// ignore: invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
typedef ThemeProvider
    = AsyncNotifierProviderImpl<ReaderTheme, List<ReaderThemeModel>>;
// ignore: invalid_use_of_internal_member
typedef ExtraProvider
    = NotifierProviderImpl<ReaderExtraConfig, ReaderExtraModal>;

class ProviderUsecase {
  static ProviderUsecase? _instance;
  // final BookModel book;
  // final BuildContext context;

  ProviderUsecase._internal();

  factory ProviderUsecase() {
    return _instance ??= ProviderUsecase._internal();
  }

  late MenuProvider menu;
  late CatalogProvider catalog;
  late ReaderProvider reader;
  late ReaderConfigProvider config;
  late ThemeProvider theme;
  late ExtraProvider extra;

  void init({
    required BookModel book,
    required BuildContext context,
  }) {
    menu = menuProvider;
    catalog = catalogProvider(book);
    reader = readerProvider(book, context: context);
    config = readerConfigProvider(context);
    theme = readerThemeProvider;
    extra = readerExtraConfigProvider;
  }

  void dispose() {}
}
