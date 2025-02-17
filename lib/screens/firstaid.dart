import 'package:flutter/material.dart';
import 'package:sea_a/widgets/header.dart';
import 'package:sea_a/widgets/bottom_navbar.dart';
import 'package:sea_a/services/first_aid_data.dart';  // Import the data

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({Key? key}) : super(key: key);

  @override
  _FirstAidScreenState createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  int _selectedIndex = 1;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;

      // Navigate to the appropriate screen based on index
      if (index == 0) {
        Navigator.pushNamed(context, '/home');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/profile');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
      body: Column(
        children: [
          const Header(title: 'First Aid'), // Custom header widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Type of Emergency:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Use Expanded and SingleChildScrollView to allow scrolling
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(firstAidTypes.length, (index) {
                  final item = firstAidTypes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        print("Navigating to /first_aid_detail with arguments: ${item['title']}, ${item['videoUrl']}, ${item['steps']}");
                        Navigator.pushNamed(
                          context,
                          '/first_aid_detail',
                          arguments: {
                            'title': item['title']!,
                            'videoUrl': item['videoUrl']!,
                            'steps': item['steps']!,
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFD9D9D9), // light gray
                              Color.fromARGB(255, 192, 138, 138), // A04545 red
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
