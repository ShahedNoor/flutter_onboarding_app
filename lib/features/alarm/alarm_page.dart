import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final List<DateTime> _alarms = [];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // Initialize timezone database
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  Future<void> _scheduleAlarm(DateTime dateTime) async {
  // ensure scheduled time is in the future (if not, schedule for next day)
  final now = DateTime.now();
  final DateTime scheduled = dateTime.isAfter(now)
      ? dateTime
      : dateTime.add(const Duration(days: 1));

  // Convert to TZDateTime (timezone-aware)
  final tz.TZDateTime tzScheduled = tz.TZDateTime.from(scheduled, tz.local);

  // Notification configuration
  final androidDetails = AndroidNotificationDetails(
    'alarm_channel', 
    'Alarms',
    channelDescription: 'Alarm notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  final platformDetails = NotificationDetails(android: androidDetails);

  // NOTE: remove androidAllowWhileIdle and uiLocalNotificationDateInterpretation
  await _notifications.zonedSchedule(
    // unique id for this notification
    scheduled.millisecondsSinceEpoch ~/ 1000,
    "Alarm",
    "It's time!",
    tzScheduled,
    platformDetails,
    // required now: AndroidScheduleMode
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    // optional: payload or matchDateTimeComponents for repeating
    payload: null,
  );

  setState(() => _alarms.add(scheduled));
}

  Future<void> _pickTime() async {
    final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      final now = DateTime.now();
      final scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      _scheduleAlarm(scheduled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Alarm")),
      body: Column(
        children: [
          ElevatedButton(onPressed: _pickTime, child: const Text("Pick Alarm Time")),
          Expanded(
            child: ListView.builder(
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                return ListTile(
                  title: Text("Alarm at ${alarm.hour}:${alarm.minute}"),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}