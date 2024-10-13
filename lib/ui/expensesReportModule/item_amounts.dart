import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

class ItemAmounts extends StatelessWidget {
  final String title;
  final double amount;

  const ItemAmounts({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card.outlined(
            child: Padding(
      padding: const EdgeInsets.all(Dimens.commonPaddingDefault),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Dimens.commonPaddingMin),
            Text('\$$amount',
                style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
      ),
    )));
  }
}
