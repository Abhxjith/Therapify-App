import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final List<String> _quotes = [
    "Every day is a new beginning.",
    "You are stronger than you think.",
    "Small steps lead to big changes.",
    "Your mental health matters.",
    "Take a moment to breathe.",
    "You're doing great!",
    "Progress, not perfection.",
    "Be kind to yourself today.",
    "You are not alone.",
    "Every challenge is an opportunity.",
  ];

  Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    // Request permissions for iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> scheduleDailyNotifications() async {
    // Cancel any existing notifications
    await flutterLocalNotificationsPlugin.cancelAll();

    // Schedule Quote Notification (9:00 AM)
    await _scheduleNotification(
      id: 1,
      title: 'Daily Quote',
      body: _quotes[DateTime.now().millisecondsSinceEpoch % _quotes.length],
      scheduledTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        9, // 9 AM
        0,
      ),
    );

    // Schedule Reminder Notification (2:00 PM)
    await _scheduleNotification(
      id: 2,
      title: 'Wellness Reminder',
      body: 'Take a moment to check in with yourself and practice self-care.',
      scheduledTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        14, // 2 PM
        0,
      ),
    );

    // Schedule Checkup Notification (7:00 PM)
    await _scheduleNotification(
      id: 3,
      title: 'Daily Checkup',
      body: 'How are you feeling today? Take a moment to track your mood.',
      scheduledTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        19, // 7 PM
        0,
      ),
    );
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = DateTime.now();
    var scheduledDate = scheduledTime;

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel',
          'Daily Notifications',
          channelDescription: 'Daily notifications for quotes, reminders, and checkups',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
} 