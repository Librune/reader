// import 'package:core/core.dart';
// import 'package:core/src/interfaces/use_case.dart';

// class BookSourceRunActionUseCase implements UseCase<BookSourceActionOptions, Future<dynamic>> {
//   @override
//   Future<dynamic> call(BookSourceActionOptions params) async {
//     final uuid = params.uuid;
//     final action = params.action;
//     final actionParams = params.params ?? {};
//     final res = await jsAction(uuid: uuid, method: action, args: actionParams);
//     try {
//       var dynamicRes = jsonDecode(res);
//       if (dynamicRes is String) {
//         return jsonDecode(dynamicRes);
//       } else {
//         return dynamicRes;
//       }
//     } catch (e) {
//       return res;
//     }
//   }
// }
