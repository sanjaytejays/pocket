import 'package:flutter/material.dart';
import 'package:pocket/services/transcation_service.dart';

class TotalSummaryWidget extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: firestoreService.getTotalIncome(),
      builder: (context, snapshotIncome) {
        if (snapshotIncome.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshotIncome.hasError) {
          return Text('Error: ${snapshotIncome.error}');
        }

        double totalIncome = snapshotIncome.data ?? 0;

        return StreamBuilder<double>(
          stream: firestoreService.getTotalExpense(),
          builder: (context, snapshotExpense) {
            if (snapshotExpense.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshotExpense.hasError) {
              return Text('Error: ${snapshotExpense.error}');
            }

            double totalExpense = snapshotExpense.data ?? 0;

            return StreamBuilder<double>(
              stream: firestoreService.getTotalBalance(),
              builder: (context, snapshotBalance) {
                if (snapshotBalance.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshotBalance.hasError) {
                  return Text('Error: ${snapshotBalance.error}');
                }

                double totalBalance = snapshotBalance.data ?? 0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total Income: $totalIncome'),
                    Text('Total Expense: $totalExpense'),
                    Text('Total Balance: $totalBalance'),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
