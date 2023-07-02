import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class NotiticationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails(bool sound) {
    if (sound) {
      return const NotificationDetails(
          android: AndroidNotificationDetails('channelId', 'channelName',
              playSound: true, importance: Importance.max),
          iOS: DarwinNotificationDetails());
    } else {
      return const NotificationDetails(
          android: AndroidNotificationDetails('1', 'silenceChannel',
              playSound: false, importance: Importance.max),
          iOS: DarwinNotificationDetails());
    }
  }

  Future<void> cancelNotification(int id) async {
    print("borrar notificacion $id");
    await notificationsPlugin.cancel(id);
  }

  Future scheduleNotification(
      {required int id,
      String? title,
      String? body,
      String? payLoad,
      required bool sound,
      required DateTime scheduledNotificationDateTime}) async {
    print("$id al crear noti");

    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(sound),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
