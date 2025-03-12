import 'package:core/src/interfaces/use_case.dart';

class SearchBookUseCase implements UseCase<String, Future<List<dynamic>>> {
  @override
  Future<List> call(String input) async {
    return [];
  }
}
