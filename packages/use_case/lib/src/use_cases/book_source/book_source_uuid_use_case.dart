import 'package:core/core.dart';
import 'package:uuid/uuid.dart';
import '../../interfaces/use_case.dart';

class BookSourceUuidUseCase implements UseCase<BookSourceModel, BookSourceModel> {
  const BookSourceUuidUseCase();

  @override
  BookSourceModel call(BookSourceModel bookSource) {
    var uuid = Uuid();
    return bookSource.uuid == null ? bookSource : bookSource.copyWith(uuid: uuid.v4());
  }
}
