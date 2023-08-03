import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DailyTransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Transactions')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('daily_transactions')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting for data
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          List<QueryDocumentSnapshot> dailyDocs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: dailyDocs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  dailyDocs[index].data() as Map<String, dynamic>;

              // You can access the daily transactions using data['transactions'] (assuming it's stored as a list of Maps)

              return ListTile(
                title: Text('Date: ${dailyDocs[index].id}'),
                subtitle:
                    Text('Total Transactions: ${data['transactions'].length}'),
                onTap: () {
                  // Navigate to a new screen to show detailed transactions for the selected day
                },
              );
            },
          );
        },
      ),
    );
  }
}
