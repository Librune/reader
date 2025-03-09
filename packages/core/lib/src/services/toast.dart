import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

FToast appToast = FToast();

setupToastService() {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    appToast.init(navigatorKey.currentContext!);
  });
}
