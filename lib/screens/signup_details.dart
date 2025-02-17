import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters

import '../widgets/back_button_with_title.dart';
import '../widgets/gender_toggle.dart';
import '../widgets/custom_widgets.dart'; // Import custom widgets
import '../services/validation_service.dart'; // Import the ValidationService

class SignupDetailsPage extends StatefulWidget {
  const SignupDetailsPage({super.key});

  @override
  _SignupDetailsPageState createState() => _SignupDetailsPageState();
}

class _SignupDetailsPageState extends State<SignupDetailsPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  String? selectedGender;
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveToFirestore() async {
    // Retrieve arguments from Navigator
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Missing signup data.')),
      );
      Navigator.pop(context);
      return;
    }

    final email = args['email'] as String;
    final password = args['password'] as String;
    final role = args['role'] as String;

    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final user = userCredential.user;

        if (user != null) {
          final userData = {
            'email': email,
            'role': role,
            'first_name': firstNameController.text.trim(),
            'last_name': lastNameController.text.trim(),
            'gender': selectedGender,
            'address': addressController.text.trim(),
            'contact_no': contactNoController.text.trim(),
            'emergency_contact': emergencyContactController.text.trim(),
            'school_location': {
              'building': buildingController.text.trim(),
              'floor': floorController.text.trim(),
              'room': roomController.text.trim(),
            },
            'user_id': user.uid, // Associate data with the user
          };

          print('Saving user data: $userData'); // Debugging: Log the data being saved

          // Save the data in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userData, SetOptions(merge: true)); // Merge if document already exists

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup details saved successfully!')),
          );

          Navigator.pushReplacementNamed(context, '/home'); // Navigate to HomePage
        }
      } catch (e) {
        print('Error saving data to Firestore: $e'); // Debugging: Log the error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save details. Please try again.')),
        );
      }
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
                const BackButtonWithTitle(title: 'Fill Up Details'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: firstNameController,
                        hintText: 'First Name',
                        validator: ValidationService.validateFirstName, // Use ValidationService
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        controller: lastNameController,
                        hintText: 'Last Name',
                        validator: ValidationService.validateLastName, // Use ValidationService
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const FormLabel(label: 'Gender'),
                GenderToggle(
                  onGenderSelected: (selectedGender) {
                    setState(() {
                      this.selectedGender = selectedGender;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const FormLabel(label: 'Address'),
                CustomTextField(
                  controller: addressController,
                  hintText: 'Enter Address',
                  validator: ValidationService.validateAddress, // Use ValidationService
                ),
                const SizedBox(height: 16),
                const FormLabel(label: 'Contact No.'),
                CustomTextField(
                  controller: contactNoController,
                  hintText: '+63',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                  validator: ValidationService.validateContactNumber, // Use ValidationService
                ),
                const SizedBox(height: 16),
                const FormLabel(label: 'Emergency Contact No.'),
                CustomTextField(
                  controller: emergencyContactController,
                  hintText: '+63',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                  validator: ValidationService.validateEmergencyContact, // Use ValidationService
                ),
                const SizedBox(height: 16),
                const FormLabel(label: 'School Location'),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: buildingController,
                        hintText: 'Building Name',
                        validator: ValidationService.validateBuilding, // Use ValidationService
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        controller: floorController,
                        hintText: 'Floor No.',
                        validator: ValidationService.validateFloor, // Use ValidationService
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: roomController,
                  hintText: 'Room No.',
                  validator: ValidationService.validateRoom, // Use ValidationService
                ),
                const SizedBox(height: 24),
                Center(
                  child: SignUpButton(
                    onPressed: saveToFirestore, // Save data when button is pressed
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
