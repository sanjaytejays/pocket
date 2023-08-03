import 'package:flutter/material.dart';
import 'package:pocket/models/data_model.dart';
import 'package:pocket/services/transcation_service.dart';

Widget floatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      _showCustomDialog(context);
    },
    child: const Icon(Icons.add),
  );
}

void _showCustomDialog(BuildContext context) {
  TextEditingController textController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool _isIncome = false;

  final FirestoreService firestoreService = FirestoreService();

  void _onAddExpenseButtonPressed(BuildContext context) {
    _showCustomDialog(context); // Call the function to show the custom dialog
  }

  void _addExpense(Expense expense) {
    firestoreService.addExpense(
        expense); // Call the FirestoreService method to add the expense
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, setState) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: const Text('New Transaction'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Amount?',
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Enter an amount';
                    }
                    return null;
                  },
                  controller: amountController,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'For what?',
                  ),
                  controller: textController,
                ),
                const SizedBox(height: 20),
                const Text('Select type:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Expense'),
                    Switch(
                      value: _isIncome,
                      onChanged: (newValue) {
                        setState(() {
                          _isIncome = newValue;
                        });
                      },
                    ),
                    const Text('Income'),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: const Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
            OutlinedButton(
              child: const Text(
                'Submit',
                style: TextStyle(
                    color: Color.fromARGB(255, 73, 137, 142),
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Validate the input
                if (amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter an amount.')),
                  );
                  return;
                }

                // Extract data from the dialog fields
                String text = textController.text;
                double amount = double.parse(amountController.text);
                bool isIncome = _isIncome;

                // Create the Expense object
                Expense newExpense = Expense(
                  id: DateTime.now()
                      .toString(), // You can generate a unique ID here, or use any other unique identifier
                  text: text,
                  amount: amount,
                  date: DateTime.now().toString(),
                  isIncome: isIncome,
                );

                // Add the expense to Firestore
                _addExpense(newExpense);

                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    },
  );
}

// void _newTransaction(BuildContext context) {
//   showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, setState) {
//             return AlertDialog(
//               title: Text('New Transaction'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Text('Expense'),
//                         Switch(
//                           value: _isIncome,
//                           onChanged: (newValue) {
//                             setState(() {
//                               _isIncome = newValue;
//                             });
//                           },
//                         ),
//                         Text('Income'),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Form(
//                             key: _formKey,
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 hintText: 'Amount?',
//                               ),
//                               validator: (text) {
//                                 if (text == null || text.isEmpty) {
//                                   return 'Enter an amount';
//                                 }
//                                 return null;
//                               },
//                               controller: _textcontrollerAMOUNT,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               hintText: 'For what?',
//                             ),
//                             controller: _textcontrollerITEM,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 MaterialButton(
//                   color: Colors.grey[600],
//                   child: Text('Cancel', style: TextStyle(color: Colors.white)),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//                 MaterialButton(
//                   color: Colors.grey[600],
//                   child: Text('Enter', style: TextStyle(color: Colors.white)),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _enterTransaction();
//                       Navigator.of(context).pop();
//                     }
//                   },
//                 )
//               ],
//             );
//           },
//         );
//       });
// }
