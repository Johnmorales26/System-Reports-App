import 'package:flutter/material.dart';

class CustomerData {
  final TextEditingController referenceNumberController;
  final TextEditingController clientNameController;
  final TextEditingController managerNameController;
  final TextEditingController ubicationController;
  final TextEditingController statusController;
  final TextEditingController activityController;
  final TextEditingController observationsController;

  CustomerData({
    required this.referenceNumberController,
    required this.clientNameController,
    required this.managerNameController,
    required this.ubicationController,
    required this.statusController,
    required this.activityController,
    required this.observationsController,
  });
}