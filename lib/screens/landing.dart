import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/img/logo_clear.png',
                height: 250,
              ),
              const Text(
                'School Health Emergency Alert \n Application',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(220, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup'); // Navigate to Signup page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD10A0A),
                  minimumSize: const Size(280, 48), // Reduced button width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navigate to Login page
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFFD10A0A),
                    width: 2, // Increased border weight
                  ),
                  minimumSize: const Size(280, 48), // Reduced button width
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Already have an Account?',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD10A0A),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Added section to go to First Aid
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/first-aid-landing'); // Navigate to First Aid screen
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Go to First Aid',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFD10A0A),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 71, 71, 71),
                    ),
                    
                  ],
                  
                ),
                
              ),
              
            ],
            
          ),
        ),
      ),
    );
  }
}
