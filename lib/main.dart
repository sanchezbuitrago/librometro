import 'package:flutter/material.dart';

import 'core/services/notifications.dart';
import 'core/services/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // Inicializa el servicio de notificaciones
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
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xB32A4A83),
          onPrimary: Color(0xFFCBD5E8),
          secondary: Color(0xFFCBD5E8),
          onSecondary: Colors.black,
          error: Color(0xFFFF0000),
          onError: Colors.black,
          surface: Color(0xFFCBD5E8),
          onSurface: Colors.white,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Color(0xB32A4A83),
          contentTextStyle: TextStyle(color: Color(0xFFCBD5E8)),
        ),
      ),
      navigatorKey: AppRoutes.navigatorKey,
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}
