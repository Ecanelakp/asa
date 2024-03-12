import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifficacions() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

Future<void> mostrarNotificaciones(String _usuarioorigen, String _asunto,
    String _notificacion, String _fecha, int _idmensaje) async {
  print('enviando.............');

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('you_channel_id', 'you_channel_name',
          playSound: true);
  const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: DarwinNotificationDetails());

  await flutterLocalNotificationsPlugin.show(
      1, _asunto, _notificacion, notificationDetails);

  print('enviado');
}
