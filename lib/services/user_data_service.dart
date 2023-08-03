import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket/models/user_model.dart';

class UserDataService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    try {
      await usersCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  Future<UserModel?> fetchUserData(String uid) async {
    try {
      final snapshot = await usersCollection.doc(uid).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
