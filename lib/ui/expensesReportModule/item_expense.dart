import 'package:flutter/material.dart';
import 'package:system_reports_app/data/local/expense_entity.dart';

class ItemExpense extends StatelessWidget {
  final ExpenseEntity expenseEntity;
  final VoidCallback onDelete;

  const ItemExpense({
    super.key,
    required this.expenseEntity,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(expenseEntity.id.toString().trim())),
        Expanded(child: Text(expenseEntity.typeExpense)),
        Expanded(
          child: Checkbox(
            onChanged: (value) {
              if (value != null) {
                expenseEntity.isBill = value;
              }
            },
            value: expenseEntity.isBill,
          ),
        ),
        Expanded(child: Text(expenseEntity.bill)),
        Expanded(child: Text('${expenseEntity.amount}')),
        Expanded(
          child: IconButton(
            onPressed: onDelete, // Aquí se llama a la función
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
