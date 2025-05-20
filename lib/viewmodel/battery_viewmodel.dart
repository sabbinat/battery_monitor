import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import '../services/battery_service.dart';
import '../services/notification_service.dart';

class BatteryViewModel extends ChangeNotifier {
  final BatteryService _batteryService = BatteryService();
  final NotificationService _notificationService = NotificationService();

  int? batteryLevel;
  BatteryState? batteryState;
  Timer? _timer;
  bool _notified = false;

  BatteryViewModel() {
    _init();
  }

  Future<void> _init() async {
    await _notificationService.initialize();
    await _notificationService.requestPermission();

    _batteryService.onBatteryStateChanged.listen((BatteryState state) {
      batteryState = state;
      notifyListeners();
    });

    _startBatteryMonitoring();
  }

  void _startBatteryMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      final level = await _batteryService.getBatteryLevel();
      batteryLevel = level;

      if (level < 20 && !_notified) {
        _notified = true;
        await _notificationService.showLowBatteryNotification(level);
      } else if (level >= 20) {
        _notified = false;
      }

      notifyListeners();
    });
  }

  IconData getBatteryIcon() {
    if (batteryState == BatteryState.charging) return Icons.battery_charging_full;
    if (batteryLevel == null) return Icons.battery_unknown;

    final level = batteryLevel!;
    if (level >= 90) return Icons.battery_full;
    if (level >= 75) return Icons.battery_6_bar;
    if (level >= 50) return Icons.battery_5_bar;
    if (level >= 35) return Icons.battery_4_bar;
    if (level >= 20) return Icons.battery_3_bar;
    if (level >= 10) return Icons.battery_2_bar;
    if (level >= 5) return Icons.battery_1_bar;
    return Icons.battery_alert;
  }

  String getBatteryStatusText() {
    switch (batteryState) {
      case BatteryState.charging:
        return 'Cargando...';
      case BatteryState.discharging:
        return 'Usando batería';
      case BatteryState.full:
        return 'Batería completa';
      default:
        return 'Estado desconocido';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _batteryService.dispose();
    super.dispose();
  }
}
