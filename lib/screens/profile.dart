// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sea_a/widgets/header.dart';
import 'package:sea_a/widgets/bottom_navbar.dart';
import 'package:sea_a/widgets/profile_detail.dart';
import 'package:sea_a/screens/profile_edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  String firstName = '';
  String lastName = '';
  String email = '';
  String contactNo = '';
  String emergencyContact = '';
  String gender = '';
  String schoolLocation = '';
  String building = '';
  String floor = '';
  String room = '';
  String role = '';
  String address = '';

  Future<void> fetchUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['first_name'] ?? '';
            lastName = userDoc['last_name'] ?? '';
            email = userDoc['email'] ?? '';
            contactNo = userDoc['contact_no'] ?? '';
            emergencyContact = userDoc['emergency_contact'] ?? '';
            gender = userDoc['gender'] ?? '';
            schoolLocation = userDoc['school_location']['school'] ?? '';
            building = userDoc['school_location']['building'] ?? '';
            floor = userDoc['school_location']['floor'] ?? '';
            room = userDoc['school_location']['room'] ?? '';
            role = userDoc['role'] ?? 'Student';
            address = userDoc['address'] ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data')),
      );
    }
  }

Future<String?> _getPasswordFromUser() async {
  TextEditingController passwordController = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Password'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: 'Password'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(null), // Cancel
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(passwordController.text), // Submit password
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}

  void _navigateToEditProfile() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProfileScreen(
        firstName: firstName,
        lastName: lastName,
        email: email,
        contactNo: contactNo,
        emergencyContact: emergencyContact,
        gender: gender,
        schoolLocation: schoolLocation,
        building: building,
        floor: floor,
        room: room,
        role: role,
        address: address,
      ),
    ),
  ).then((_) {
    // Refresh profile data after editing
    fetchUserProfile();
  });
}
void _deleteAccount() async {
  // Step 1: Show the confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                // Step 2: Get the password from the user
                String? password = await _getPasswordFromUser();
                if (password != null) {
                  try {
                    // Step 3: Reauthenticate the user
                    final AuthCredential credential = EmailAuthProvider.credential(
                      email: user.email!,
                      password: password, // Use the provided password
                    );
                    await user.reauthenticateWithCredential(credential);

                    // Step 4: Delete the user from Firestore
                    await _firestore.collection('users').doc(user.uid).delete();

                    // Step 5: Delete the user from Firebase Authentication
                    await user.delete();

                    // Navigate to landing page
                    Navigator.pushReplacementNamed(context, '/');
                  } catch (e) {
                    print('Error deleting account: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete account')),
                    );
                  }
                }
              }
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}


  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, '/home');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/first-aid');
      }
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const Header(title: 'Profile',
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         ProfileDetailWidget(
      title: 'Name:',
      content: '$firstName $lastName',
      icon: Icons.person,
    ),
  
         IconButton(
          icon: Icon(
            Icons.edit,
            color: const Color.fromARGB(255, 56, 56, 56),
          ),
          onPressed: _navigateToEditProfile, // Navigate to Edit Profile screen
        ),
       
      ],
    ),
      Divider(thickness: 1),
    ProfileDetailWidget(
      title: 'Gender:',
      content: gender,
      icon: Icons.transgender,
    ),
    Divider(thickness: 1),
    ProfileDetailWidget(
      title: 'Role:',
      content: role,
      icon: Icons.security,
    ),
    Divider(thickness: 1),
    ProfileDetailWidget(
      title: 'Email:',
      content: email,
      icon: Icons.email,
    ),
    Divider(thickness: 1),
    ProfileDetailWidget(
      title: 'Home Address:',
      content: address,
      icon: Icons.home,
    ),
    Divider(thickness: 1),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProfileDetailWidget(
          title: 'Phone:',
          content: contactNo,
          icon: Icons.phone,
        ),
        ProfileDetailWidget(
          title: 'Emergency Contact:',
          content: emergencyContact,
          icon: Icons.local_phone,
        ),
      ],
    ),
    Divider(thickness: 1),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ProfileDetailWidget(
          title: 'Building:',
          content: building,
          icon: Icons.business,
        ),
        ProfileDetailWidget(
          title: 'Floor:',
          content: floor,
          icon: Icons.location_city,
        ),
        ProfileDetailWidget(
          title: 'Room:',
          content: room,
          icon: Icons.meeting_room,
        ),
      ],
    ),
        SizedBox(height: 10),
      
    
  ],
  
),
                    ),
                  ),
                 // Row to hold both logout and delete account buttons
Align(
  alignment: Alignment.bottomCenter,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space between buttons
      children: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Color.fromARGB(255, 145, 53, 53),
          ),
          onPressed: _logout,
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Color.fromARGB(255, 145, 53, 53),
          ),
          onPressed: _deleteAccount,
        ),
      ],
    ),
  ),
),

                ],
              ),
            ),
    );
  }
}
