import 'package:flutter/material.dart';
import 'package:librometro/dashboard/presentation/views/dashboard.dart';

import 'core/services/notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();  // Inicializa el servicio de notificaciones
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.deepOrangeAccent,
          onPrimary: Colors.black,
          secondary: Color(0xFF494747),
          onSecondary: Colors.white,
          error: Colors.redAccent,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black
        ),
      ),
      home: const Dashboard(),
    );
  }
}