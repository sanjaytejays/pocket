import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pocket/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      final User? user = authResult.user;
      if (user != null) {
        // Check if the user is new or existing by checking Firestore for their UID
        final DocumentSnapshot userSnapshot =
            await _usersCollection.doc(user.uid).get();
        if (!userSnapshot.exists) {
          // User is new, create their account in Firestore
          final UserModel newUser = UserModel(
            uid: user.uid,
            name: user.displayName ?? 'User_${user.uid}',
            email: user.email ?? 'No Mail',
            profilePic: user.photoURL ??
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png',
            dateJoined: DateTime.now().toIso8601String(),
          );

          await _usersCollection.doc(user.uid).set(newUser.toMap());
        }
      }

      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  void logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Other authentication methods and sign-out logic...
}
