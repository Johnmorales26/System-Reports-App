class ExpenseEntity {

  final int id;
  final String typeExpense;
  bool isBill;
  final String bill;
  final double amount;

  ExpenseEntity(this.id, this.typeExpense, this.isBill, this.bill, this.amount);
}