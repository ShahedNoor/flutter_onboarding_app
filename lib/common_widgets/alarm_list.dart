import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AlarmList extends StatelessWidget {
  final List<DateTime> alarms;
  const AlarmList({super.key, required this.alarms});

  @override
  Widget build(BuildContext context) {
    if (alarms.isEmpty) {
      return const Center(
        child: Text(
          "No alarms set yet",
          style: TextStyle(color: AppColors.onPrimary),
        ),
      );
    }

    return ListView.builder(
      itemCount: alarms.length,
      itemBuilder: (context, index) {
        final alarm = alarms[index];
        return ListTile(
          title: Text(
            "Alarm at ${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(color: AppColors.onPrimary),
          ),
        );
      },
    );
  }
}
