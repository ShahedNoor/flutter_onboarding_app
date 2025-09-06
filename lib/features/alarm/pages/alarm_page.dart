import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_onboarding_app/constants/colors.dart';
import 'package:flutter_onboarding_app/common_widgets/my_button.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:provider/provider.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';

import '../providers/alarm_provider.dart';
import '../../location/providers/location_provider.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Add this to track permission state
  bool _hasExactAlarmPermission = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _initNotifications();
    _checkExactAlarmPermission(); // Check permission on init
  }

  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  // Check if exact alarm permission is already granted
  Future<void> _checkExactAlarmPermission() async {
    if (Platform.isAndroid) {
      try {
        // For Android 12+ (API 31+), check if exact alarm permission is granted
        final permission = await Permission.scheduleExactAlarm.status;
        setState(() {
          _hasExactAlarmPermission = permission.isGranted;
        });
      } catch (e) {
        // If permission_handler doesn't work, assume permission is needed
        // You can also use platform channels or other methods to check
        setState(() {
          _hasExactAlarmPermission = false;
        });
      }
    } else {
      // For non-Android platforms, assume permission is granted
      setState(() {
        _hasExactAlarmPermission = true;
      });
    }
  }

  // Request exact alarm permission (Android 12+)
  Future<bool> _requestExactAlarmPermission() async {
    if (Platform.isAndroid && !_hasExactAlarmPermission) {
      try {
        final permission = await Permission.scheduleExactAlarm.request();
        if (permission.isDenied) {
          // If still denied, redirect to settings
          final intent = AndroidIntent(
            action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          );
          await intent.launch();

          // Show a dialog to inform the user
          if (mounted) {
            _showPermissionDialog();
          }
          return false;
        } else if (permission.isGranted) {
          setState(() {
            _hasExactAlarmPermission = true;
          });
          return true;
        }
      } catch (e) {
        // Fallback: redirect to settings
        final intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );
        await intent.launch();

        if (mounted) {
          _showPermissionDialog();
        }
        return false;
      }
    }
    return _hasExactAlarmPermission;
  }

  void _showPermissionDialog() {
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
                // Re-check permission when user returns
                Future.delayed(const Duration(milliseconds: 500), () {
                  _checkExactAlarmPermission();
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _scheduleAlarm(DateTime dateTime) async {
    final now = DateTime.now();
    final scheduled = dateTime.isAfter(now)
        ? dateTime
        : dateTime.add(const Duration(days: 1));
    final tzScheduled = tz.TZDateTime.from(scheduled, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarms',
      channelDescription: 'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true, // This helps make it more alarm-like
      category: AndroidNotificationCategory.alarm,
    );

    final platformDetails = NotificationDetails(android: androidDetails);

    try {
      await _notifications.zonedSchedule(
        scheduled.millisecondsSinceEpoch ~/ 1000,
        "Alarm",
        "Your alarm is ringing!",
        tzScheduled,
        platformDetails,
        androidScheduleMode: _hasExactAlarmPermission
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexact,
      );

      // Save alarm to provider
      final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
      alarmProvider.addAlarm(scheduled);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Alarm set for ${scheduled.hour.toString().padLeft(2, '0')}:${scheduled.minute.toString().padLeft(2, '0')}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set alarm: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickTime() async {
    // Check permission first, request only if needed
    final hasPermission = await _requestExactAlarmPermission();

    if (!hasPermission) {
      // Permission not granted, don't proceed with time picker
      return;
    }

    // Now show the time picker
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final now = DateTime.now();
      final scheduled = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      await _scheduleAlarm(scheduled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final alarmProvider = Provider.of<AlarmProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selected Location",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/alarm_page_images/location_icon.png",
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        locationProvider.location,
                        style: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MyButton(
                  onTap: _pickTime,
                  buttonText: "Add Alarm",
                  buttonBackgroundColor: AppColors.onPrimary.withOpacity(0.2),
                ),
                // Optional: Show permission status
                if (Platform.isAndroid)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Icon(
                          _hasExactAlarmPermission
                              ? Icons.check_circle
                              : Icons.warning,
                          color: _hasExactAlarmPermission
                              ? Colors.green
                              : Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _hasExactAlarmPermission
                              ? 'Exact alarms enabled'
                              : 'Exact alarms disabled',
                          style: TextStyle(
                            color: AppColors.onPrimary.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Alarms",
              style: TextStyle(
                color: AppColors.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alarmProvider.alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarmProvider.alarms[index];
                return ListTile(
                  title: Text(
                    "Alarm at ${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(color: AppColors.onPrimary),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: AppColors.onPrimary),
                    onPressed: () {
                      alarmProvider.removeAlarm(alarm);
                      // Also cancel the notification
                      _notifications.cancel(
                        alarm.millisecondsSinceEpoch ~/ 1000,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
