import 'package:flutter/material.dart';

class TripData {
  final TextEditingController recordController;
  final TextEditingController registerDateController;
  final TextEditingController startScheduleController;
  final TextEditingController finalScheduleController;
  final TextEditingController totalHoursController;
  TimeOfDay? startSchedule;
  TimeOfDay? finalSchedule;

  TripData({
    required this.recordController,
    required this.registerDateController,
    required this.startScheduleController,
    required this.finalScheduleController,
    required this.totalHoursController,
    this.startSchedule,
    this.finalSchedule,
  });
}
