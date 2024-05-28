import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() async{
    _notification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings()));

    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<int> scheduleNotification(
      {required String title, required String body, required tz.TZDateTime tzDateTime}) async {
    var androidNotificationDetails = const AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.max,
        priority: Priority.high
    );
    var iOSNotificationDetails = const DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);


    int _notificationID = tz.TZDateTime.now(tz.local).hashCode;


    await _notification.zonedSchedule(
        _notificationID,
        title,
        body,
        tzDateTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);

    return _notificationID;
  }
}
