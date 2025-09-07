class AlarmModel {
  final int id;
  final DateTime time;
  bool enabled;

  AlarmModel({
    required this.id,
    required this.time,
    this.enabled = true,
  });
}