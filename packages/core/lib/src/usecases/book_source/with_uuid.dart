import 'package:core/core.dart';
import 'package:core/src/interfaces/use_case.dart';
import 'package:uuid/uuid.dart';

class BookSourceWithUuidUseCase implements UseCase<BookSourceModel, BookSourceModel> {
  const BookSourceWithUuidUseCase();

  @override
  BookSourceModel call(BookSourceModel bookSource) {
    var uuid = Uuid();
    return bookSource.uuid == null ? bookSource : bookSource.copyWith(uuid: uuid.v4());
  }
}
