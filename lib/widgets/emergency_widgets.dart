import 'package:flutter/material.dart';
import 'package:sea_a/services/contacts.dart';

class ContactList extends StatelessWidget {
  final Future<List<Contact>> contactsFuture;
  final String role;
  final Function(String) onContactTap;

  const ContactList({
    required this.contactsFuture,
    required this.role,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: contactsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text("Error loading contacts");
        }

        List<Contact> contacts = snapshot.data ?? [];
        return Column(
          children: contacts.map((contact) {
            return ContactButton(
              name: contact.name,
              role: role,
              onTap: () => onContactTap(contact.phoneNumber),
            );
          }).toList(),
        );
      },
    );
  }
}


class EmergencyForm extends StatelessWidget {
  final TextEditingController patientStatusController;
  final TextEditingController buildingRoomController;
  final TextEditingController additionalNotesController;

  EmergencyForm({
    required this.patientStatusController,
    required this.buildingRoomController,
    required this.additionalNotesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Patient Status',
          controller: patientStatusController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Bldg & Room No.',
          controller: buildingRoomController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Additional Notes',
          controller: additionalNotesController,
        ),
      ],
    );
  }
}
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.label,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF656161),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFF838383),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFF838383),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 153, 22, 13), // Red color when focused
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 110, 19, 12), // Red color when focused and error
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}


// Emergency Button Widget
class EmergencyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD10A0A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 70), // Adjusted padding for compact size
      ),
      child: const Text(
        'Send Alert',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}





class ContactButton extends StatelessWidget {
  final String name;
  final String role;  // Added the role parameter
  final VoidCallback onTap;

  const ContactButton({
    Key? key,
    required this.name,
    required this.role,  // Initialize the role
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 186, 186, 186), // Darker shadow for better visibility
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: Colors.grey[400]!, // Small outline for the button
            width: 1,
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Text(
                '$role ',  
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:const Color(0xFFD10A0A), 
                ),
              ),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:Color.fromARGB(255, 0, 0, 0),  

                  ),
                  overflow: TextOverflow.ellipsis,  // Ensure name is truncated if too long
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 1,
                height: 24,
                color: Colors.grey[400],
              ),
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

