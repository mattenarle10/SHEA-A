import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/back_button_with_title.dart'; // Import the custom back button widget
import '../widgets/custom_widgets.dart'; // Import your custom widgets

class EditProfileScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String contactNo;
  final String emergencyContact;
  final String gender;
  final String schoolLocation;
  final String building;
  final String floor;
  final String room;
  final String role;
  final String address;

  const EditProfileScreen({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactNo,
    required this.emergencyContact,
    required this.gender,
    required this.schoolLocation,
    required this.building,
    required this.floor,
    required this.room,
    required this.role,
    required this.address,
    Key? key,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController contactNoController;
  late TextEditingController emergencyContactController;
  late TextEditingController genderController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    emailController = TextEditingController(text: widget.email);
    contactNoController = TextEditingController(text: widget.contactNo);
    emergencyContactController = TextEditingController(text: widget.emergencyContact);
    genderController = TextEditingController(text: widget.gender);
    addressController = TextEditingController(text: widget.address);

    debugPrint("EditProfileScreen initialized with data:");
    debugPrint("First Name: ${widget.firstName}");
    debugPrint("Last Name: ${widget.lastName}");
    debugPrint("Email: ${widget.email}");
    debugPrint("Contact No: ${widget.contactNo}");
    debugPrint("Emergency Contact: ${widget.emergencyContact}");
    debugPrint("Gender: ${widget.gender}");
    debugPrint("Address: ${widget.address}");
  }

  @override
  void dispose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    contactNoController.dispose();
    emergencyContactController.dispose();
    genderController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
  if (_formKey.currentState!.validate()) {
    debugPrint("Prompting user for confirmation...");
    bool? confirmSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Save"),
          content: Text("Are you sure you want to save the changes?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Confirm
              child: Text("Save"),
            ),
          ],
        );
      },
    );

    if (confirmSave == true) {
      debugPrint("Saving profile...");
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'first_name': firstNameController.text,
            'last_name': lastNameController.text,
            'email': emailController.text,
            'contact_no': contactNoController.text,
            'emergency_contact': emergencyContactController.text,
            'gender': genderController.text,
            'address': addressController.text,
          });
          debugPrint("Profile updated successfully.");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile saved successfully')),
          );
          Navigator.pop(context); // Return to the profile screen
        } else {
          debugPrint("Error: No user logged in.");
        }
      } catch (e) {
        debugPrint("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile')),
        );
      }
    } else {
      debugPrint("User canceled the save operation.");
    }
  } else {
    debugPrint("Form validation failed.");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey, // Form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButtonWithTitle(title: 'Edit Details'), // Back button and title
                const SizedBox(height: 24), // Space between title and form
                FormLabel(label: 'First Name'),
                CustomTextField(
                  hintText: 'First Name',
                  controller: firstNameController,
                ),
                const SizedBox(height: 16),
                FormLabel(label: 'Last Name'),
                CustomTextField(
                  hintText: 'Last Name',
                  controller: lastNameController,
                ),
                const SizedBox(height: 16),
              
         
                FormLabel(label: 'Contact No'),
                CustomTextField(
                  hintText: 'Contact No',
                  controller: contactNoController,
                ),
                const SizedBox(height: 16),
                FormLabel(label: 'Emergency Contact'),
                CustomTextField(
                  hintText: 'Emergency Contact',
                  controller: emergencyContactController,
                ),
                const SizedBox(height: 16),
                FormLabel(label: 'Gender'),
                CustomTextField(
                  hintText: 'Gender',
                  controller: genderController,
                ),
                const SizedBox(height: 16),
                FormLabel(label: 'Home Address'),
                CustomTextField(
                  hintText: 'Home Address',
                  controller: addressController,
                ),
                const SizedBox(height: 20),
                Center(
                  child: SaveButton(onPressed: _saveProfile), // Save button centered
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
