import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

class GeneralDataWidget extends StatelessWidget {
  final ReportViewModel provider;

  const GeneralDataWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Datos Generales del Reporte',
          style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customerData.referenceNumberController,
          decoration: const InputDecoration(
            labelText: 'Reference Number',
            hintText: 'Enter your reference number',
            prefixIcon: Icon(Icons.code),
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customerData.clientNameController,
          decoration: const InputDecoration(
            labelText: 'Client',
            hintText: 'Enter your client name',
            prefixIcon: Icon(Icons.person),
            filled: true,
          ),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customerData.managerNameController,
          decoration: const InputDecoration(
            labelText: 'Location',
            hintText: 'Enter your location',
            prefixIcon: Icon(Icons.location_on),
            filled: true,
          ),
          keyboardType: TextInputType.streetAddress),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customerData.ubicationController,
          decoration: const InputDecoration(
            labelText: 'Name FSE',
            hintText: 'Enter your name FSE',
            prefixIcon: Icon(Icons.person_2),
            filled: true,
          ),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customerData.statusController,
          decoration: const InputDecoration(
            labelText: 'Custom Manager',
            hintText: 'Enter your custom manager',
            prefixIcon: Icon(Icons.person),
            filled: true,
          ),
          keyboardType: TextInputType.name),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customerData.activityController,
          decoration: const InputDecoration(
            labelText: 'Activity Performed',
            hintText: 'Enter your activity performed',
            prefixIcon: Icon(Icons.person),
            filled: true,
          ),
          keyboardType: TextInputType.text),
      const SizedBox(height: Dimens.commonPaddingMin),
      TextField(
          controller: provider.customerData.observationsController,
          decoration: const InputDecoration(
            labelText: 'Observations',
            hintText: 'Enter your observations',
            prefixIcon: Icon(Icons.notes),
            filled: true,
          ),
          keyboardType: TextInputType.text),
    ]);
  }
}
