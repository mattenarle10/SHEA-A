import 'package:flutter/material.dart';

class ProfileDetailWidget extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const ProfileDetailWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon for the section title
          Icon(
            icon,
            size: 20, // Reduced icon size
            color: const Color.fromARGB(255, 181, 7, 7), // Custom color for the icon
          ),
          SizedBox(width: 8), // Reduced spacing between icon and text
          // Title and content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14, // Slightly smaller font size
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 4), // Reduced spacing between title and content
              Text(
                content,
                style: TextStyle(
                  fontSize: 12, // Slightly smaller font size
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const ProfileRow({
    Key? key,
    required this.title,
    required this.content,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProfileDetailWidget(
          title: title,
          content: content,
          icon: icon,
        ),
      ],
    );
  }
}
