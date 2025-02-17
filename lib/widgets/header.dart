import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
            color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontFamily: 'Poppins',
               color: const Color.fromARGB(255, 181, 7, 7),
            ),
          ),
        ),
      ),
    );
  }
}
