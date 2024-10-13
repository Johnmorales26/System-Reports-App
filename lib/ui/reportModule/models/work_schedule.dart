import 'package:flutter/material.dart';

class WorkSchedule {
  final TextEditingController registerDate;
  final TextEditingController startSchedule;
  final TextEditingController lunchStart;
  final TextEditingController lunchEnd;
  final TextEditingController endSchedule;
  final TextEditingController travelHours;
  TimeOfDay? startWorkSchedule;
  TimeOfDay? finalWorkSchedule;

  WorkSchedule({
    required this.registerDate,
    required this.startSchedule,
    required this.lunchStart,
    required this.lunchEnd,
    required this.endSchedule,
    required this.travelHours,
    this.startWorkSchedule,
    this.finalWorkSchedule,
  });
}
