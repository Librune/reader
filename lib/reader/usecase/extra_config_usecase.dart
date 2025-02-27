import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

toggleZenMode(WidgetRef ref) {
  final willZenMode = !ref.read(ProviderUsecase().extra.select((value) => value.zenMode));
  Log.d('toggleZenMode: $willZenMode');
  if (willZenMode) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  } else {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }
  ref.read(ProviderUsecase().extra.notifier).updatePageTurning('zenMode');
}
