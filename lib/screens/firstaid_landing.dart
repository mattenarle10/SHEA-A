import 'package:flutter/material.dart';

import 'package:sea_a/services/first_aid_data.dart';  // Import the data
import '../widgets/back_button_with_title.dart'; // Import the custom back button widget


class FirstAidLandingScreen extends StatefulWidget {
  const FirstAidLandingScreen({Key? key}) : super(key: key);

  @override
  _FirstAidScreenState createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidLandingScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const SizedBox(height: 8),
                const BackButtonWithTitle(title: 'First Aid'), // Back button

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
                // Use SingleChildScrollView to allow scrolling
                SingleChildScrollView(
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
              ],
            ),
          ),
        ),
      ),
     
    );
  }
}
