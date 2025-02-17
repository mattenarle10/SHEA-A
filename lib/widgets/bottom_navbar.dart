import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62, // Slightly taller for better layout
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            iconPath: 'lib/img/icon_home.png',
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _buildNavItem(
            iconPath: 'lib/img/icon_firstaid.png',
            label: 'First Aid',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _buildNavItem(
            iconPath: 'lib/img/icon_profile.png',
            label: 'Profile',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20, // Consistent width for icons
            height: 20, // Consistent height for all icons
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
              color: isSelected ? const Color(0xFFB00020) : const Color(0xFF707070),
            ),
          ),
          const SizedBox(height: 2.5), // Spacing between icon and label
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: isSelected ? const Color(0xFFB00020) : const Color.fromARGB(255, 30, 29, 29),
            ),
          ),
        ],
      ),
    );
  }
}
