import 'package:core/src/services/path.dart';
import 'package:rc/rc.dart';

initCoreServices() async {
  await Rc.init();
  await PathService().init();
}
