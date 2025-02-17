import 'package:flutter/material.dart';

class BackButtonWithTitle extends StatelessWidget {
  final String title;
  const BackButtonWithTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFD10A0A),
            size: 28,
          ),
        ),
        const SizedBox(width: 8.0),  // Added space between the back button and title
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
