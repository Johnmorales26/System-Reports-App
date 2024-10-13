import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/reportModule/models/work_schedule.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

class RecordTimesWidget extends StatelessWidget {
  final ReportViewModel provider;
  const RecordTimesWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Horaros Registrados',
          style: Theme.of(context).textTheme.headlineSmall),
      _WorkScheduleForm(
          workSchedule: provider.workScheduleOne, provider: provider),
      const SizedBox(height: Dimens.commonPaddingMin),
      const Divider(),
      const SizedBox(height: Dimens.commonPaddingMin),
      _WorkScheduleForm(
          workSchedule: provider.workScheduleTwo, provider: provider),
      const SizedBox(height: Dimens.commonPaddingMin),
      const Divider(),
      const SizedBox(height: Dimens.commonPaddingMin),
      _WorkScheduleForm(
          workSchedule: provider.workScheduleThree, provider: provider)
    ]);
  }
}

class _WorkScheduleForm extends StatelessWidget {
  final WorkSchedule workSchedule;
  final ReportViewModel provider;
  const _WorkScheduleForm({required this.workSchedule, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextField(
          controller: workSchedule.registerDate,
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
                      workSchedule.registerDate.text =
                          "${selectedDate.toLocal()}".split(' ')[0];
                    }
                  },
                  icon: const Icon(Icons.calendar_month))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: workSchedule.startSchedule,
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
                      workSchedule.startSchedule.text =
                          selectedTime.format(context);
                      workSchedule.startWorkSchedule = selectedTime;
                      provider.calculateTimeDifference(
                          workSchedule.startWorkSchedule,
                          workSchedule.finalWorkSchedule,
                          workSchedule.travelHours);
                    }
                  },
                  icon: const Icon(Icons.timer))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: workSchedule.lunchStart,
          decoration: InputDecoration(
              labelText: 'Initial Lunch',
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      workSchedule.lunchStart.text =
                          selectedTime.format(context);
                    }
                  },
                  icon: const Icon(Icons.timer))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: workSchedule.lunchEnd,
          decoration: InputDecoration(
              labelText: 'Final Lunch',
              filled: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      workSchedule.lunchEnd.text = selectedTime.format(context);
                    }
                  },
                  icon: const Icon(Icons.timer))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: workSchedule.endSchedule,
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
                      workSchedule.endSchedule.text =
                          selectedTime.format(context);
                      workSchedule.finalWorkSchedule = selectedTime;
                      provider.calculateTimeDifference(
                          workSchedule.startWorkSchedule,
                          workSchedule.finalWorkSchedule,
                          workSchedule.travelHours);
                    }
                  },
                  icon: const Icon(Icons.timer))),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: workSchedule.travelHours,
          decoration: const InputDecoration(
            labelText: 'Total',
            enabled: false,
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
    ]);
  }
}
