import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/battery_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';


class BroadcastApp extends StatelessWidget {
  const BroadcastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BatteryViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Broadcast Battery',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const BatteryScreen(),
      ),
    );
  }
}

class BatteryScreen extends StatelessWidget {
  const BatteryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BatteryViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de batería'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Aquí se monitorea el nivel de batería en segundo plano.\n\n',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              if (vm.batteryLevel != null) ...[
                Icon(
                  vm.getBatteryIcon(),
                  size: 100,
                  color: vm.batteryLevel! < 20 ? Colors.redAccent : Colors.deepPurple,
                ),
                const SizedBox(height: 10),
                Text(
                  vm.getBatteryStatusText(),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ] else ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                const Text(
                  'Obteniendo nivel de batería...',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
              const SizedBox(height: 20),
              if (vm.batteryLevel != null)
                Text(
                  'Nivel actual de batería: ${vm.batteryLevel}%',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              const SizedBox(height: 10),
              const Text(
                'Se mostrará una notificación si la batería baja del 20%.',
                style: TextStyle(fontSize: 12, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () async {
                  final url = Uri.parse('https://github.com/sabbinat');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No se pudo abrir GitHub')),
                    );
                  }
                },
                icon: const Icon(Icons.link, color: Colors.white),
                label: const Text('Abrir perfil GitHub', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
