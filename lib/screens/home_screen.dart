import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pocket/models/data_model.dart';
import 'package:pocket/models/user_model.dart';
import 'package:pocket/screens/profile_screen.dart';
import 'package:pocket/services/transcation_service.dart';
import 'package:pocket/widgets/floating_action_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          _user =
              UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _user != null
          ? AppBar(
              elevation: 0,
              title: const Text('POCKET'),
              backgroundColor: const Color.fromARGB(255, 24, 95, 111),
              actions: [
                Center(
                    child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: Text(
                    _user!.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                )),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_user!.profilePic),
                  ),
                ),
              ],
            )
          : AppBar(
              elevation: 0,
              title: const Text('POCKET'),
              backgroundColor: const Color.fromARGB(255, 24, 95, 111),
              actions: [
                const Center(
                    child: Text(
                  'Error User',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
                IconButton(onPressed: () {}, icon: const Icon(Icons.error)),
              ],
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              SizedBox(
                width: double.infinity,
                height: 500,
                child: StreamBuilder<List<Expense>>(
                  stream: firestoreService.getExpenses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Show a loading indicator while waiting for data
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    List<Expense> expenses = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        Expense expense = expenses[index];
                        return ListTile(
                            title: Text(expense.text),
                            subtitle: Text(expense.date),
                            trailing: expense.isIncome == true
                                ? Text(
                                    "+ ₹${expense.amount.toString()}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "- ₹${expense.amount.toString()}",
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ));
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: floatingActionButton(context),
    );
  }

  Widget _header() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: StreamBuilder<double>(
        stream: firestoreService.getTotalIncome(),
        builder: (context, snapshotIncome) {
          if (snapshotIncome.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshotIncome.hasError) {
            return Text('Error: ${snapshotIncome.error}');
          }

          double totalIncome = snapshotIncome.data ?? 0;

          return StreamBuilder<double>(
            stream: firestoreService.getTotalExpense(),
            builder: (context, snapshotExpense) {
              if (snapshotExpense.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
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
                    return const CircularProgressIndicator();
                  }

                  if (snapshotBalance.hasError) {
                    return Text('Error: ${snapshotBalance.error}');
                  }

                  double totalBalance = snapshotBalance.data ?? 0;

                  return Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 24, 95, 111),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.arrow_upward),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Income')
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      totalIncome.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.arrow_downward),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('Expenses')
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      totalExpense.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 60,
                        left: 40,
                        child: Container(
                          height: 90,
                          width: 320,
                          decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 29, 53, 58),
                                  offset: Offset(0, 6),
                                  spreadRadius: 4,
                                  blurRadius: 10,
                                )
                              ],
                              color: Color.fromARGB(255, 14, 43, 49),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Total Balance",
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                totalBalance.toString(),
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
