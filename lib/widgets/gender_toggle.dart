import 'package:flutter/material.dart';

class GenderToggle extends StatefulWidget {
  final void Function(String) onGenderSelected;
  const GenderToggle({required this.onGenderSelected});

  @override
  _GenderToggleState createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  int _selectedIndex = -1; // Default to no selection
  final List<String> genders = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          genders.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onGenderSelected(genders[index]);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? const Color(0xFFD10A0A)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedIndex == index
                      ? const Color(0xFFD10A0A)
                      : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Text(
                genders[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: _selectedIndex == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


