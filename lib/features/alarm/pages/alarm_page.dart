import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_app/constants/colors.dart';
import 'package:flutter_onboarding_app/common_widgets/my_button.dart';
import 'package:provider/provider.dart';
import '../../location/providers/location_provider.dart';
import '../providers/alarm_provider.dart';
import '../models/alarm_model.dart';
import '../helpers/alarm_service.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late AlarmService _alarmService;
  bool _hasExactAlarmPermission = false;

  @override
  void initState() {
    super.initState();
    _alarmService = AlarmService();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await _alarmService.checkExactAlarmPermission();
    setState(() {
      _hasExactAlarmPermission = hasPermission;
    });
  }

  Future<void> _pickTime() async {
    final hasPermission = await _alarmService.requestExactAlarmPermission(
      context,
    );
    if (!hasPermission) return;

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

      final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
      final AlarmModel newAlarm = alarmProvider.addAlarm(scheduled);
      await _alarmService.scheduleAlarm(newAlarm);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Alarm set for ${scheduled.hour.toString().padLeft(2, '0')}:${scheduled.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: AppColors.onPrimary),
            ),
            backgroundColor: AppColors.secondaryColor.withOpacity(0.4),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime time) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekday = weekdays[time.weekday - 1];
    final day = time.day;
    final month = months[time.month - 1];
    final year = time.year;
    return "$weekday $day $month $year";
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final alarmProvider = Provider.of<AlarmProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
                vertical: 100,
              ),
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
                                ? AppColors.secondaryColor
                                : AppColors.onSecondary,
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
            Text(
              "Alarms",
              style: TextStyle(
                color: AppColors.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alarmProvider.alarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarmProvider.alarms[index];
                  return Container(
                    padding: const EdgeInsets.all(18.0),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(alarm.time),
                          // "${_formatTime(alarm.time)}",
                          style: TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Text(
                                _formatDate(alarm.time),
                                style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 5),
                              CupertinoSwitch(
                                value: alarm.enabled,
                                activeTrackColor: AppColors.secondaryColor,
                                onChanged: (value) async {
                                  alarmProvider.toggleAlarm(alarm, value);
                                  if (value) {
                                    await _alarmService.scheduleAlarm(alarm);
                                  } else {
                                    await _alarmService.cancelAlarm(alarm);
                                    await _alarmService
                                        .showAlarmOffNotification(
                                          alarm,
                                          _formatTime(alarm.time),
                                        );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}