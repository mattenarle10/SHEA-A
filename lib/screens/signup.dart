import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart'; // Import custom widgets
import '../services/toast_helper.dart';  // Import the toast helper

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
    bool _isPasswordVisible = false; bool _isconfirmPasswordVisible = false; // Add this variable to toggle password visibility
  String? _role;

  void _proceedToDetailsPage() {
    if (_emailController.text.isEmpty) {
      showToast(context, 'Please enter your email');
      return;
    }

    if (_passwordController.text.isEmpty) {
      showToast(context, 'Please enter your password');
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      showToast(context, 'Please confirm your password');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showToast(context, "Passwords don't match");
      return;
    }

    if (_role == null) {
      showToast(context, 'Please select your role');
      return;
    }

    Navigator.pushNamed(
      context,
      '/signup-details',
      arguments: {
        'email': _emailController.text,
        'password': _passwordController.text,
        'role': _role,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFD10A0A),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFD10A0A),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome to SEA-A!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 22),
                const FormLabel(label: 'Email Address'),
                const SizedBox(height: 4),
                CustomTextField(hintText: 'Enter Email Address', controller: _emailController),
                const SizedBox(height: 16),
                const FormLabel(label: 'Password'),
                const SizedBox(height: 4),
                Stack(
                  children: [
  CustomTextField(
    controller: _passwordController,
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
                const SizedBox(height: 16),
                const FormLabel(label: 'Confirm Password'),
                const SizedBox(height: 4),
               Stack(
                  children: [
  CustomTextField(
    controller: _confirmPasswordController,
    hintText: 'Enter Password',
    obscureText: !_isconfirmPasswordVisible, // Toggle the visibility
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
          _isconfirmPasswordVisible = !_isconfirmPasswordVisible; // Toggle visibility
        });
      },
    ),
  ),
],
                ),
                const SizedBox(height: 16),
                const FormLabel(label: 'Role'),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  items: const [
                    DropdownMenuItem(
                      value: 'Student',
                      child: Text('Student/Teacher'),
                    ),
                    
                    DropdownMenuItem(
                      value: 'Red Cross Youth',
                      child: Text('Red Cross Youth'),
                    ),
                    DropdownMenuItem(
                      value: 'Nurse',
                      child: Text('Nurse'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _role = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Choose your Role',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2, color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2, color: Color(0xFFD10A0A)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ContinueButton(onPressed: _proceedToDetailsPage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
