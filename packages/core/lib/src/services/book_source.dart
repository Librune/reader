import 'package:core/src/services/wk8.dart';
import 'package:rc/rc.dart';

class BookSourceService {
  static final BookSourceService _instance = BookSourceService._internal();
  factory BookSourceService() => _instance;
  BookSourceService._internal();

  late final List<BookCore> bookCores;

  init() async {
    BookCore core = await initBookCore(code: wk8);
    bookCores = [core];
  }

  add(String code) async {
    BookCore core = await initBookCore(code: code);
    bookCores.add(core);
    return await core.getMetadata();
  }
}
