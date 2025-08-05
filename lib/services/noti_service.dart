import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/models/task_model.dart';


class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notification',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

Future<void> showScheduledNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDateTime,
  String? payload,
  TaskRepeat repeatType = TaskRepeat.none,
}) async {
  final now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduledDateTime, tz.local);

  // If the scheduled time is in the past, move it to the next day
  if (scheduledTZDate.isBefore(now)) {
    scheduledTZDate = scheduledTZDate.add(Duration(days: 1));
  }

  // Daily and Weekly repeats handled via matchDateTimeComponents
  DateTimeComponents? matchComponents;
  if (repeatType == TaskRepeat.daily) {
    matchComponents = DateTimeComponents.time;
  } else if (repeatType == TaskRepeat.weekday || repeatType == TaskRepeat.weekend) {
    matchComponents = DateTimeComponents.dayOfWeekAndTime;
  }

  // Only schedule if today is valid for repeatType
  final int weekday = scheduledTZDate.weekday;

  final bool shouldSchedule = switch (repeatType) {
    TaskRepeat.none => true,
    TaskRepeat.daily => true,
    TaskRepeat.weekday => weekday >= 1 && weekday <= 5, // Mon–Fri
    TaskRepeat.weekend => weekday == 6 || weekday == 7, // Sat–Sun
  };

  if (!shouldSchedule) return; // Skip scheduling if not allowed today

  await notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    scheduledTZDate,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Channel for reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: matchComponents,
    payload: payload,
  );
}

}


// usage
// await NotiService().showScheduledNotification(
//   id: 1,
//   title: 'Daily Water',
//   body: 'Drink water!',
//   scheduledDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8),
// );

// await NotiService().showScheduledNotification(
//   id: 1,
//   title: 'Daily Water',
//   body: 'Drink water!',
//   scheduledDateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8),
//   repeatType: RepeatType.daily,
// );

// await NotiService().showScheduledNotification(
//   id: 2,
//   title: 'Work Reminder',
//   body: 'Start your tasks!',
//   scheduledDateTime: DateTime.now().add(Duration(seconds: 5)), // today’s time
//   repeatType: RepeatType.weekday,
// );

// await NotiService().showScheduledNotification(
//   id: 3,
//   title: 'Weekend Vibes',
//   body: 'Relax, it’s the weekend!',
//   scheduledDateTime: DateTime.now().add(Duration(seconds: 5)),
//   repeatType: RepeatType.weekend,
// );
