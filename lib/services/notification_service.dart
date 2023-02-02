import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    _configureLocalTimeZone();
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    var initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return _notificationsPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(),
    );
  }

  Future zonedScheduleNotificationTask({
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minutes,
    required int id,
    required String title,
    required String body,
    required String repeat,
    required int reminder,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfNotification(year, month, day, hour, minutes - reminder),
      _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: _selectReapeat(repeat),
    );
    print('Notification scheduled');
  }

  Future zonedScheduleNotificationSchedule({
    required int day,
    required int hour,
    required int minutes,
    required int id,
    required String title,
    required String body,
    required int reminder,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfDay(day, hour, minutes - reminder),
      _notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
    print('Notification scheduled');
  }

  Future cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print('Notification cancelled');
  }

  _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  tz.TZDateTime _nextInstanceOfNotification(
    int year,
    int month,
    int day,
    int hour,
    int minutes,
  ) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, year, month, day, hour, minutes);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfDay(
    int day,
    int hour,
    int minutes,
  ) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = _nextInstanceOfNotification(
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  _selectReapeat(String repeat) {
    if (repeat == 'Daily') {
      return DateTimeComponents.time;
    } else if (repeat == 'Weekly') {
      return DateTimeComponents.dayOfWeekAndTime;
    } else if (repeat == 'Monthly') {
      return DateTimeComponents.dayOfMonthAndTime;
    } else {
      return null;
    }
  }
}
