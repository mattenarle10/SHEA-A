import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart'; // Import custom widgets

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Add this variable to toggle password visibility

  Future<void> login() async {
    print("Login function triggered");

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print("Email entered: $email");
    print("Password entered: $password");

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        print("Login successful. User UID: $uid");

        // Check if user data exists in Firestore
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userData.exists) {
          print("User data found in Firestore: ${userData.data()}");
          Navigator.pushReplacementNamed(context, '/home'); // Navigate to Home
        } else {
          print("User data not found in Firestore for UID: $uid");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user data found for this account.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print("User credential is null");
      }
    } catch (e) {
      print("Login failed with error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void forgotPassword() async {
  final email = emailController.text.trim();

  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter your email address'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset email sent. Please check your inbox.'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send password reset email: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(  // Wrap the entire body with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context), // Go back
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFD10A0A),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Login Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFD10A0A),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 32),
                const FormLabel(label: 'Email Address'),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Enter Email Address',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const FormLabel(label: 'Password'),
                Stack(
                  children: [
  CustomTextField(
    controller: passwordController,
    hintText: 'Enter Password',
    obscureText: !_isPasswordVisible, // Toggle the visibility
  ),
  Positioned(
    right: 0,
    top: 6,
    child: IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        size: 19, // Make the icon smaller
        color: Colors.grey, // Set the color to gray
      ),
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
        });
      },
    ),
  ),
],
                ),
const SizedBox(height: 8),
                
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                 onPressed: forgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFD10A0A),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: LoginButton(onPressed: login), // Call login function on button press
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup'); // Navigate to signup page
                    },
                    child: const Text(
                      'Don’t have an account? Sign up',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFD10A0A),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
