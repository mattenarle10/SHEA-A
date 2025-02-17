import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter

// Optimized CustomTextField Widget
class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType; // Added keyboardType for flexibility
  final String? Function(String?)? validator; // Added validator for form validation
  final Widget? prefixIcon; // Added support for prefix icons
  final Widget? suffixIcon; // Added support for suffix icons

  const CustomTextField({
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.inputFormatters,
    this.keyboardType = TextInputType.text, // Default to text input
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      validator: validator, // Apply validation if provided
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
          fontFamily: 'Poppins',
        ),
        prefixIcon: prefixIcon, // Use prefix icon if provided
        suffixIcon: suffixIcon, // Use suffix icon if provided
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 3, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2, color: Color(0xFFD10A0A)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2, color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2, color: Colors.redAccent),
        ),
      ),
    );
  }
}


// Custom Form Label Widget
class FormLabel extends StatelessWidget {
  final String label;
  const FormLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: 'Poppins',
      ),
    );
  }
}

// Custom Sign Up Button Widget
class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ContinueButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD10A0A),
        minimumSize: const Size(280, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Continue',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

// Custom Sign Up Button Widget
class SignUpButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SignUpButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD10A0A),
        minimumSize: const Size(280, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD10A0A),
        minimumSize: const Size(280, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class FormRow extends StatelessWidget {
  final String leftLabel;
  final String leftHint;
  final String rightLabel;
  final String rightHint;

  const FormRow({
    required this.leftLabel,
    required this.leftHint,
    required this.rightLabel,
    required this.rightHint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormLabel(label: leftLabel),
              const SizedBox(height: 8),
              CustomTextField(hintText: leftHint),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormLabel(label: rightLabel),
              const SizedBox(height: 8),
              CustomTextField(hintText: rightHint),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Save Button Widget
class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SaveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD10A0A),
        minimumSize: const Size(280, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Save Changes',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
