import 'dart:async';
import 'package:battery_plus/battery_plus.dart';

class BatteryService {
  final Battery _battery = Battery();
  final StreamController<BatteryState> _stateController = StreamController.broadcast();

  Stream<BatteryState> get onBatteryStateChanged => _battery.onBatteryStateChanged;

  Future<int> getBatteryLevel() => _battery.batteryLevel;

  void dispose() {
    _stateController.close();
  }
}
