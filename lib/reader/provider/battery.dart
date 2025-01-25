import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:reader/reader/data/model/battery.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battery.g.dart';

@Riverpod(keepAlive: true)
class ReaderBattery extends _$ReaderBattery {
  final battery = Battery();
  @override
  Future<BatteryModel> build() async {
    final batteryLevel = await battery.batteryLevel;
    final batteryState = await battery.batteryState;
    battery.onBatteryStateChanged.listen(_batteryListener);
    Timer.periodic(const Duration(minutes: 10), (timer) {
      _batteryLevelScanner();
    });
    return BatteryModel(batteryLevel: batteryLevel, batteryState: batteryState);
  }

  _batteryListener(BatteryState bst) async {
    final batteryLevel = await battery.batteryLevel;
    state = AsyncValue.data(BatteryModel(batteryLevel: batteryLevel, batteryState: bst));
  }

  _batteryLevelScanner() async {
    final batteryLevel = await battery.batteryLevel;
    state = AsyncValue.data(state.value!.copyWith(batteryLevel: batteryLevel));
  }
}
