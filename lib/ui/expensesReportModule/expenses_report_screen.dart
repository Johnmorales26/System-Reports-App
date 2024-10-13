import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/ui/expensesReportModule/expenses_report_view_model.dart';
import 'package:system_reports_app/ui/expensesReportModule/item_amounts.dart';
import 'package:system_reports_app/ui/expensesReportModule/item_expense.dart';
import 'package:toastification/toastification.dart';

import '../style/dimens.dart';

class ExpensesReportScreen extends StatelessWidget {
  const ExpensesReportScreen({super.key});

  static const String route = '/ExpensesReportScreen';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpensesReportViewModel>(context);

    Widget currentView = _Form();
    switch (viewModel.currentView) {
      case 0:
        currentView = SingleChildScrollView(child: _Form());
        break;
      case 1:
        currentView = SingleChildScrollView(child: _Expenses());
        break;
      case 2:
        currentView = _ListExpenses();
        break;
    }

    return Scaffold(
        appBar: AppBar(
            title: const Text('Registro de Servicio'),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () => showDetails(context, viewModel),
                  icon: const Icon(Icons.info_outline))
            ]),
        body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimens.commonPaddingDefault),
            child: currentView));
  }

  void showDetails(BuildContext context, ExpensesReportViewModel viewModel) {
    if (viewModel.expenses.isEmpty) {
      toastification.show(
          context: context,
          title: const Text('Please add expenses'),
          autoCloseDuration: const Duration(seconds: 5),
          type: ToastificationType.info);
    } else {
      final totalBilled = viewModel.expenses.fold(
          0.0,
          (acumulator, expense) =>
              expense.isBill ? acumulator + expense.amount : acumulator);
      final totalUnbilled = viewModel.expenses.fold(
          0.0,
          (acumulator, expense) => expense.isBill == false
              ? acumulator + expense.amount
              : acumulator);
      final total = viewModel.expenses
          .fold(0.0, (acumulator, expense) => acumulator + expense.amount);

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Report',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: Dimens.commonPaddingDefault),
                  Row(
                    children: [
                      ItemAmounts(title: 'Billed', amount: totalBilled),
                      ItemAmounts(title: 'Unbilled', amount: totalUnbilled),
                    ],
                  ),
                  Row(
                    children: [
                      ItemAmounts(title: 'Total', amount: total),
                      ItemAmounts(title: 'Advance', amount: totalUnbilled),
                    ],
                  ),
                ],
              ));
        },
      );
    }
  }
}

class _Form extends StatelessWidget {
  final screenNumber = 0;

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode daysFocusNode = FocusNode();
  final FocusNode weekFocusNode = FocusNode();
  final FocusNode typeServiceFocusNode = FocusNode();
  final FocusNode clientFocusNode = FocusNode();
  final FocusNode advanceFocusNode = FocusNode();
  final FocusNode referenceFocusNode = FocusNode();

  final servicesTypes = [
    const MapEntry(100, 'Extranjero'),
    const MapEntry(150, 'Local'),
    const MapEntry(700, 'Foraneo')
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpensesReportViewModel>(context);
    viewModel.changeScreen(screenNumber);

    return Column(
      children: [
        const Text(
            'Completa los siguientes campos para registrar un nuevo servicio.'),
        const SizedBox(height: Dimens.commonPaddingDefault),
        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
            child: Column(
              children: [
                TextField(
                  controller: viewModel.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter name',
                    border: OutlineInputBorder(),
                  ),
                  focusNode: nameFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(daysFocusNode),
                ),
                const SizedBox(height: Dimens.commonPaddingDefault),
                TextField(
                  controller: viewModel.daysController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Service Days',
                    border: OutlineInputBorder(),
                  ),
                  focusNode: daysFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(weekFocusNode),
                ),
                const SizedBox(height: Dimens.commonPaddingDefault),
                TextField(
                  controller: viewModel.weekController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Week',
                    border: OutlineInputBorder(),
                  ),
                  focusNode: weekFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(typeServiceFocusNode),
                ),
                const SizedBox(height: Dimens.commonPaddingDefault),
                DropdownButtonFormField(
                    items: servicesTypes.map((MapEntry value) {
                      return DropdownMenuItem<String>(
                        value: value.value,
                        child: Text(value.value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        viewModel.typeServiceController.text = newValue;
                        var result = servicesTypes.firstWhere((item) => item.value == newValue);
                        viewModel.typeServiceValue = result.key;
                      }
                    }),
                const SizedBox(height: Dimens.commonPaddingDefault),
                TextField(
                  controller: viewModel.clientController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Client',
                    border: OutlineInputBorder(),
                  ),
                  focusNode: clientFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(advanceFocusNode),
                ),
                const SizedBox(height: Dimens.commonPaddingDefault),
                TextField(
                  controller: viewModel.advanceController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Advance',
                    border: OutlineInputBorder(),
                  ),
                  focusNode: advanceFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(referenceFocusNode),
                ),
                const SizedBox(height: Dimens.commonPaddingDefault),
                TextField(
                  controller: viewModel.referenceController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Reference Number',
                    border: OutlineInputBorder(),
                  ),
                  focusNode: referenceFocusNode,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
                const SizedBox(height: Dimens.commonPaddingDefault),
                ElevatedButton(
                  onPressed: () => viewModel.nextScreen(),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Expenses extends StatelessWidget {
  final screenNumber = 1;

  final FocusNode idFocusNode = FocusNode();
  final FocusNode expenseTypeFocusNode = FocusNode();
  final FocusNode billFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpensesReportViewModel>(context);
    viewModel.changeScreen(screenNumber);
    return Column(children: [
      const Text('Agrega los gastos relacionados con el servicio'),
      const SizedBox(height: Dimens.commonPaddingDefault),
      Card.outlined(
          child: Padding(
              padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
              child: Column(children: [
                TextField(
                  controller: viewModel.idController,
                  keyboardType: TextInputType.number,
                  focusNode: idFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(expenseTypeFocusNode),
                  decoration: const InputDecoration(
                      labelText: 'Enter ID', border: OutlineInputBorder()),
                ),
                const SizedBox(height: Dimens.commonPaddingMin),
                TextField(
                  controller: viewModel.expenseTypeController,
                  keyboardType: TextInputType.text,
                  focusNode: expenseTypeFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(billFocusNode),
                  decoration: const InputDecoration(
                      labelText: 'Enter Expense Type',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: Dimens.commonPaddingMin),
                Row(children: [
                  const Text('Bill'),
                  const SizedBox(width: Dimens.commonPaddingMin),
                  Checkbox(
                      value: viewModel.isBill,
                      onChanged: (bool? state) {
                        viewModel.changeState(state!);
                      })
                ]),
                const SizedBox(height: Dimens.commonPaddingMin),
                TextField(
                  controller: viewModel.billController,
                  keyboardType: TextInputType.text,
                  focusNode: billFocusNode,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(amountFocusNode),
                  decoration: const InputDecoration(
                      labelText: 'Enter Bill', border: OutlineInputBorder()),
                ),
                const SizedBox(height: Dimens.commonPaddingMin),
                TextField(
                  controller: viewModel.amountController,
                  keyboardType: TextInputType.number,
                  focusNode: amountFocusNode,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                      labelText: 'Enter Amount', border: OutlineInputBorder()),
                ),
                const SizedBox(height: Dimens.commonPaddingMin),
                OutlinedButton(
                    onPressed: () {
                      final response = viewModel.addExpense();
                      if (!response) {
                        toastification.show(
                            context: context,
                            title: const Text('Please fill all fields'),
                            autoCloseDuration: const Duration(seconds: 5),
                            type: ToastificationType.info);
                      }
                    },
                    child: const Text('Add Expense')),
              ]))),
      const SizedBox(height: Dimens.commonPaddingDefault),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () => viewModel.previousScreen(),
                child: const Text('Back')),
            ElevatedButton(
                onPressed: () => viewModel.nextScreen(),
                child: const Text('Next')),
          ]),
    ]);
  }
}

class _ListExpenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpensesReportViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildExpensesList(viewModel),
          ),
          const SizedBox(height: 16.0),
          _buildActions(viewModel, context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'ID',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Expense',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Is Bill',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Bill',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Amount',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(), // Espacio vacío para mantener la alineación
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList(ExpensesReportViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.expenses.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
          elevation: 2.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ItemExpense(
              expenseEntity: viewModel.expenses[index],
              onDelete: () => viewModel.itemDelete(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActions(
      ExpensesReportViewModel viewModel, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => viewModel.previousScreen(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back'),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            final response = await viewModel.generateDocument();
            if (response) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.cloud_upload),
          label: const Text('Upload'),
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          ),
        ),
      ],
    );
  }
}
