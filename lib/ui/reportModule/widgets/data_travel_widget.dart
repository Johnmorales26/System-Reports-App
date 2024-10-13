import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

class DataTravelWidget extends StatelessWidget {
  final ReportViewModel provider;

  const DataTravelWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Datos del Viaje', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripOneData.recordController,
          decoration: const InputDecoration(
            labelText: 'Register',
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripOneData.registerDateController,
          decoration: InputDecoration(
              labelText: 'Register Date',
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      provider.tripOneData.registerDateController.text =
                          "${selectedDate.toLocal()}".split(' ')[0];
                    }
                  },
                  icon: const Icon(Icons.calendar_month))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripOneData.startScheduleController,
          decoration: InputDecoration(
              labelText: 'Initial Time',
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      provider.tripOneData.startScheduleController.text =
                          selectedTime.format(context);
                      provider.tripOneData.startSchedule = selectedTime;
                      provider.calculateTimeDifference(
                          provider.tripOneData.startSchedule,
                          provider.tripOneData.finalSchedule,
                          provider.tripOneData.totalHoursController);
                    }
                  },
                  icon: const Icon(Icons.timer))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripOneData.finalScheduleController,
          decoration: InputDecoration(
              labelText: 'Final Time',
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      provider.tripOneData.finalScheduleController.text =
                          selectedTime.format(context);
                      provider.tripOneData.finalSchedule = selectedTime;
                      provider.calculateTimeDifference(
                          provider.tripOneData.startSchedule,
                          provider.tripOneData.finalSchedule,
                          provider.tripOneData.totalHoursController);
                    }
                  },
                  icon: const Icon(Icons.timer))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripOneData.totalHoursController,
          decoration: const InputDecoration(
            labelText: 'Travel Hours',
            enabled: false,
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      const Divider(),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripTwoData.recordController,
          decoration: const InputDecoration(
            labelText: 'Register',
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripTwoData.registerDateController,
          decoration: InputDecoration(
              labelText: 'Register Date',
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      provider.tripTwoData.registerDateController.text =
                          "${selectedDate.toLocal()}".split(' ')[0];
                    }
                  },
                  icon: const Icon(Icons.calendar_month))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripTwoData.startScheduleController,
          decoration: InputDecoration(
              labelText: 'Initial Time',
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      provider.tripTwoData.startScheduleController.text =
                          selectedTime.format(context);
                      provider.tripTwoData.startSchedule = selectedTime;
                      provider.calculateTimeDifference(
                          provider.tripTwoData.startSchedule,
                          provider.tripTwoData.finalSchedule,
                          provider.tripTwoData.totalHoursController);
                    }
                  },
                  icon: const Icon(Icons.timer))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripTwoData.finalScheduleController,
          decoration: InputDecoration(
              labelText: 'Final Time',
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      provider.tripTwoData.finalScheduleController.text =
                          selectedTime.format(context);
                      provider.tripTwoData.finalSchedule = selectedTime;
                      provider.calculateTimeDifference(
                          provider.tripTwoData.startSchedule,
                          provider.tripTwoData.finalSchedule,
                          provider.tripTwoData.totalHoursController);
                    }
                  },
                  icon: const Icon(Icons.timer))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.tripTwoData.totalHoursController,
          decoration: const InputDecoration(
            labelText: 'Travel Hours',
            enabled: false,
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
    ]);
  }
}
