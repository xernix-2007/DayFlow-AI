import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
      windows: WindowsInitializationSettings(appName: 'DayFlow AI', appUserModelId: 'xernix.dayflow', guid: '6a0b7ef2-0f1a-4d75-8e2c-7c6b1e2f8e5a'),
    );
    await _plugin.initialize(settings);
  }

  Future<void> scheduleTaskReminder({
    required int id,
    required String title,
    required DateTime scheduledAt,
    int minutesBefore = 10,
  }) async {
    final when = scheduledAt.subtract(Duration(minutes: minutesBefore));
    if (!when.isAfter(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      'Upcoming task',
      '$title starts in $minutesBefore minutes',
      tz.TZDateTime.from(when, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'dayflow_tasks',
          'Task reminders',
          channelDescription: 'Reminders for scheduled DayFlow tasks',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
        windows: WindowsNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
}
