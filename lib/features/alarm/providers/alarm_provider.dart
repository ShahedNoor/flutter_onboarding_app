import 'package:flutter/material.dart';
import '../models/alarm_model.dart';

class AlarmProvider with ChangeNotifier {
  final List<AlarmModel> _alarms = [];

  List<AlarmModel> get alarms => _alarms;

  // Add an alarm and return to AlarmModel (so that callers can schedule it).
  AlarmModel addAlarm(DateTime time) {
    final id = time.millisecondsSinceEpoch ~/ 1000; // unique id
    final alarm = AlarmModel(id: id, time: time, enabled: true);
    _alarms.add(alarm);
    notifyListeners();
    return alarm;
  }

  void removeAlarm(AlarmModel alarm) {
    _alarms.remove(alarm);
    notifyListeners();
  }

  void toggleAlarm(AlarmModel alarm, bool isEnabled) {
    final index = _alarms.indexOf(alarm);
    if (index != -1) {
      _alarms[index].enabled = isEnabled;
      notifyListeners();
    }
  }
}