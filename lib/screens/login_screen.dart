import 'package:flutter/material.dart';
import 'package:pocket/services/authentication.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  void _handleSignIn(BuildContext context) async {
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      // Navigate to the home screen or the next screen after successful sign-in
      // For demonstration purposes, we'll just print the user's information here.
      print("User signed in: ${user.displayName} (${user.email})");
    } else {
      // Handle sign-in failure
      print("Sign-In Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleSignIn(context),
          child: Text('Sign In with Google'),
        ),
      ),
    );
  }
}
