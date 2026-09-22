// lib/services/notification_service.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/weekly_plan.dart';
import '../models/reminder_settings.dart';

/// Schedules workout reminders on the phone itself (no server).
///
/// Every method is wrapped so a notification problem can never crash the app.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _ready = false;

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  static final NotificationDetails _details = NotificationDetails(
    android: const AndroidNotificationDetails(
      'workout_reminders',
      'Workout reminders',
      channelDescription: 'Reminders that it is time to work out',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: const DarwinNotificationDetails(),
    macOS: const DarwinNotificationDetails(),
  );

  Future<void> init() async {
    if (!_supported || _ready) return;
    try {
      tzdata.initializeTimeZones();
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));

      // Permission prompts are requested later, when the user turns
      // reminders on, so nothing pops up when the app first opens.
      final darwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(
        settings: InitializationSettings(
          android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: darwin,
          macOS: darwin,
        ),
      );
      _ready = true;
    } catch (e) {
      debugPrint('Notification setup failed: $e');
    }
  }

  /// Asks the phone for permission. Returns true if notifications are allowed.
  Future<bool> requestPermission() async {
    await init();
    if (!_ready) return false;
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        final granted = await android.requestNotificationsPermission() ?? false;
        final canBeExact = await android.canScheduleExactNotifications() ?? false;
        if (granted && !canBeExact) {
          await android.requestExactAlarmsPermission();
        }
        return granted;
      }
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        return await ios.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
      final mac = _plugin.resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>();
      if (mac != null) {
        return await mac.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }
    } catch (e) {
      debugPrint('Notification permission request failed: $e');
    }
    return false;
  }

  /// Cancels everything and schedules a weekly reminder for each chosen day.
  Future<void> syncReminders(ReminderSettings settings) async {
    await init();
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
      if (!settings.enabled) return;

      final mode = await _scheduleMode();
      for (final weekday in settings.weekdays) {
        final day = planForWeekday(weekday);
        final body = day.isRest
            ? settings.message
            : '${settings.message}\nToday: ${day.name} - ${day.focus}';
        await _plugin.zonedSchedule(
          id: weekday,
          title: settings.title,
          body: body,
          scheduledDate: _nextInstance(weekday, settings.hour, settings.minute),
          notificationDetails: _details,
          androidScheduleMode: mode,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    } catch (e) {
      debugPrint('Could not schedule reminders: $e');
    }
  }

  Future<void> showTest() async {
    await init();
    if (!_ready) return;
    try {
      await _plugin.show(
        id: 99,
        title: 'Pump Chump',
        body: 'Test reminder. Notifications are working!',
        notificationDetails: _details,
      );
    } catch (e) {
      debugPrint('Could not show test notification: $e');
    }
  }

  Future<void> cancelAll() async {
    if (!_ready) return;
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('Could not cancel notifications: $e');
    }
  }

  /// Exact timing needs a special Android permission. If the user has not
  /// granted it, fall back to "about on time", which needs no permission.
  Future<AndroidScheduleMode> _scheduleMode() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return AndroidScheduleMode.exactAllowWhileIdle;
    final canBeExact = await android.canScheduleExactNotifications() ?? false;
    return canBeExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// The next moment that is this weekday at this time, in the phone's
  /// time zone. Built with the TZDateTime constructor (not Duration math)
  /// so daylight saving changes do not shift the hour.
  tz.TZDateTime _nextInstance(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var date = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (date.weekday != weekday || !date.isAfter(now)) {
      date = tz.TZDateTime(tz.local, date.year, date.month, date.day + 1, hour, minute);
    }
    return date;
  }
}
