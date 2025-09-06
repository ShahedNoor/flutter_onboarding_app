import 'package:flutter/material.dart';

class AlarmProvider extends ChangeNotifier {
  final List<DateTime> _alarms = [];

  List<DateTime> get alarms => _alarms;

  void addAlarm(DateTime alarm) {
    _alarms.add(alarm);
    notifyListeners();
  }

  void removeAlarm(DateTime alarm) {
    _alarms.remove(alarm);
    notifyListeners();
  }
}
