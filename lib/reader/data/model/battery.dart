import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'battery.freezed.dart';

@freezed
class BatteryModel with _$BatteryModel {
  const factory BatteryModel({
    required int batteryLevel,
    required BatteryState batteryState,
  }) = _BatteryModel;
  const BatteryModel._();

  IconData get icon {
    if (batteryState == BatteryState.charging) {
      return Icons.battery_charging_full;
    } else {
      if (batteryState == BatteryState.charging) {
        return Icons.battery_charging_full;
      } else if (batteryLevel > 90) {
        return Icons.battery_full;
      } else if (batteryLevel > 70) {
        return Icons.battery_6_bar;
      } else if (batteryLevel > 50) {
        return Icons.battery_5_bar;
      } else if (batteryLevel > 30) {
        return Icons.battery_4_bar;
      } else if (batteryLevel > 10) {
        return Icons.battery_3_bar;
      } else {
        return Icons.battery_alert;
      }
    }
  }
}
