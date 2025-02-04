import 'package:flutter/material.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/provider/catalog.dart';

class ProviderUsecase {
  static ProviderUsecase? _instance;
  final BookModel book;
  final BuildContext context;

  ProviderUsecase._internal({required this.book, required this.context});

  factory ProviderUsecase({required BookModel book, required BuildContext context}) {
    return _instance ??= ProviderUsecase._internal(book: book, context: context);
  }

  late final CatalogProvider catalog;

  void init() {
    catalog = catalogProvider(book);
  }
}
