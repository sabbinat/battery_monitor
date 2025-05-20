import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/battery_viewmodel.dart';
import 'view/broadcast_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BatteryViewModel())],
      child: const BroadcastApp(),
    ),
  );
}
