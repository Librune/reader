import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_provider.g.dart';

@Riverpod(keepAlive: true)
class SearchHistory extends _$SearchHistory {
  @override
  List<String> build() {
    late final List<String> history;
    try {
      history = jsonDecode(localStorage.getItem("search_history") ?? "[]");
    } catch (e) {
      Log.e(e);
      history = [];
    }
    return history;
  }

  push(String keyword) {
    state = [...state, keyword];
  }

  remove(String keyword) {
    state = state.where((element) => element != keyword).toList();
  }

  clear() {
    state = [];
  }

  onSelfChange(List<String>? oldValue, List<String> newValue) {
    localStorage.setItem("search_history", jsonEncode(newValue));
  }
}
