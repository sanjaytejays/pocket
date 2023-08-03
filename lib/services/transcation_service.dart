import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket/models/data_model.dart';

class FirestoreService {
  final CollectionReference _expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  Stream<List<Expense>> getExpenses() {
    return _expenseCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Expense(
          id: doc.id,
          text: data['text'],
          amount: data['amount'],
          date: data['date'],
          isIncome: data['isIncome'],
        );
      }).toList();
    });
  }

  Future<void> addExpense(Expense expense) async {
    // Convert the Expense object to a Map using the toMap() method
    Map<String, dynamic> expenseData = expense.toMap();

    await _expenseCollection
        .doc(expense
            .id) // Assuming 'id' is unique and you want to use it as the document ID
        .set(expenseData);
  }

  Stream<double> getTotalIncome() {
    return _expenseCollection
        .where('isIncome', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      double totalIncome = 0;
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalIncome += data['amount'] as double;
      });
      return totalIncome;
    });
  }

  Stream<double> getTotalExpense() {
    return _expenseCollection
        .where('isIncome', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      double totalExpense = 0;
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        totalExpense += data['amount'] as double;
      });
      return totalExpense;
    });
  }

  Stream<double> getTotalBalance() {
    return _expenseCollection.snapshots().map((snapshot) {
      double totalIncome = 0;
      double totalExpense = 0;
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double amount = data['amount'] as double;
        if (data['isIncome'] == true) {
          totalIncome += amount;
        } else {
          totalExpense += amount;
        }
      });
      return totalIncome - totalExpense;
    });
  }

  Future<void> resetDailyTransactions() async {
    // Get the current date and time
    DateTime currentDate = DateTime.now();

    // Fetch all the transactions for the current day from the 'users' collection
    QuerySnapshot querySnapshot = await _expenseCollection
        .where('date', isGreaterThanOrEqualTo: currentDate)
        .where('date', isLessThan: currentDate.add(Duration(days: 1)))
        .get();

    // Create a list to store the daily transactions
    List<Map<String, dynamic>> dailyTransactions = [];

    // Convert the query snapshot to a list of Map representing the transactions
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      dailyTransactions.add(data);
    });

    // Create a new document in the 'daily_transactions' collection with the current date as the document ID
    await FirebaseFirestore.instance
        .collection('daily_transactions')
        .doc(currentDate
            .toLocal()
            .toString()) // Convert the date to local timezone before using it as the document ID
        .set({'transactions': dailyTransactions});
  }
}
