/// 通用 UseCase 接口
///
/// [Input] 是用例需要的输入参数类型
/// [Output] 是用例返回的输出类型
abstract class UseCase<Input, Output> {
  const UseCase();

  /// 执行用例的方法
  Output call(Input input);
}

/// 无参数用例接口
///
/// 适用于不需要输入参数的用例
abstract class NoParamUseCase<Output> {
  const NoParamUseCase();

  /// 执行用例的方法
  Output call();
}
