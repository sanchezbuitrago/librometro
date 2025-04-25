import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Inicializa las notificaciones
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notificationsPlugin.initialize(settings);
  }

  // Muestra la notificación persistente mientras el temporizador está activo
  static Future<void> showRunningNotification(String timeString) async {
    const androidDetails = AndroidNotificationDetails(
      'timer_channel_id',
      'Temporizador',
      channelDescription: 'Muestra que el temporizador está activo',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      showWhen: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      'Temporizador activo',
      'Tiempo: $timeString',
      notificationDetails,
    );
  }

  // Cancela la notificación cuando el temporizador se pausa o reinicia
  static Future<void> cancelNotification() async {
    await _notificationsPlugin.cancel(0);
  }
}
