import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';
import '../features/alarm/models/alarm_model.dart';

class AlarmHelper {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _hasExactAlarmPermission = false;

  AlarmHelper() {
    tz.initializeTimeZones();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  Future<bool> checkExactAlarmPermission() async {
    if (Platform.isAndroid) {
      try {
        final permission = await Permission.scheduleExactAlarm.status;
        _hasExactAlarmPermission = permission.isGranted;
      } catch (e) {
        _hasExactAlarmPermission = false;
      }
    } else {
      _hasExactAlarmPermission = true;
    }
    return _hasExactAlarmPermission;
  }

  Future<bool> requestExactAlarmPermission(BuildContext context) async {
    if (Platform.isAndroid && !_hasExactAlarmPermission) {
      try {
        final permission = await Permission.scheduleExactAlarm.request();
        if (permission.isDenied) {
          final intent = AndroidIntent(
            action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          );
          await intent.launch();
          _showPermissionDialog(context);
          return false;
        } else if (permission.isGranted) {
          _hasExactAlarmPermission = true;
          return true;
        }
      } catch (e) {
        final intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );
        await intent.launch();
        _showPermissionDialog(context);
        return false;
      }
    }
    return _hasExactAlarmPermission;
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: const Text(
            'To set exact alarms, please grant the "Alarms & reminders" permission in Settings, then return to the app.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> scheduleAlarm(AlarmModel alarm) async {
    final scheduled = alarm.time.isAfter(DateTime.now())
        ? alarm.time
        : alarm.time.add(const Duration(days: 1));
    final tz.TZDateTime tzScheduled = tz.TZDateTime.from(scheduled, tz.local);
    final androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );
    final platformDetails = NotificationDetails(android: androidDetails);
    await _notifications.zonedSchedule(
      alarm.id,
      "Alarm",
      "Your alarm is ringing!",
      tzScheduled,
      platformDetails,
      androidScheduleMode: _hasExactAlarmPermission
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexact,
    );
  }

  Future<void> cancelAlarm(AlarmModel alarm) async {
    await _notifications.cancel(alarm.id);
  }

  Future<void> showAlarmOffNotification(
    AlarmModel alarm,
    String formattedTime,
  ) async {
    final androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    final platformDetails = NotificationDetails(android: androidDetails);
    await _notifications.show(
      alarm.id + 10000,
      "Alarm turned off",
      "The alarm at $formattedTime has been turned off.",
      platformDetails,
    );
  }
}
