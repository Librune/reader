import 'package:core/src/interfaces/use_case.dart';
import 'package:core/src/usecases/book_source/exec_action.dart';

class BookSourceExecActionAllOptions {
  final List<String> uuids;
  final String action;
  final Map<String, dynamic>? params;

  BookSourceExecActionAllOptions({required this.uuids, required this.action, this.params});
}

class BookSourceExecActionAll<T extends dynamic> implements UseCase<BookSourceExecActionAllOptions, Future<List<T>>> {
  @override
  Future<List<T>> call(BookSourceExecActionAllOptions input) async {
    final List<T> result = [];
    for (var uuid in input.uuids) {
      result.add(
        await BookSourceExecAction<T>().call(
          BookSourceExecActionOptions(uuid: uuid, action: input.action, params: input.params),
        ),
      );
    }
    return result;
  }
}
