import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sea_a/widgets/emergency_widgets.dart';
import 'package:sea_a/services/alert_service.dart';
import 'package:sea_a/logic/location_logic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sea_a/services/fetch_contacts.dart';
import 'package:sea_a/widgets/floating_banner.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  void _openDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      bool launched = await launchUrl(phoneUri);
      if (!launched) {
        print("Could not open the dialer.");
      }
    } catch (e) {
      print('Could not open dialer with $phoneNumber: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientStatusController = TextEditingController();
    final buildingRoomController = TextEditingController();
    final additionalNotesController = TextEditingController();

    final AlertService alertService = AlertService();
    final LocationLogic locationLogic = LocationLogic();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 139, 18, 10),
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'lib/img/alert.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('User data not found.'));
            }

            final userRole = snapshot.data!.get('role');
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (userRole != 'Nurse') ...[
                    EmergencyForm(
                      patientStatusController: patientStatusController,
                      buildingRoomController: buildingRoomController,
                      additionalNotesController: additionalNotesController,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 60,
                      child: EmergencyButton(
                        onPressed: () async {
                          final location = await locationLogic.getCurrentLocation();
                          if (location == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Unable to retrieve location.')),
                            );
                            return;
                          }

                          // Send alert using AlertService
                          await alertService.sendAlert(
                            role: userRole,
                            patientStatus: patientStatusController.text,
                            buildingRoom: buildingRoomController.text,
                            additionalNotes: additionalNotesController.text,
                            location: location,
                          );

                          // Show confirmation
                          FloatingBanner.show(
                            context,
                            message: "Alert: ${patientStatusController.text} at ${buildingRoomController.text}",
                            soundAsset: 'lib/sounds/notification.wav',
                            notificationTitle: 'Emergency Alert',
                          );

                          // Clear inputs and navigate to history
                          patientStatusController.clear();
                          buildingRoomController.clear();
                          additionalNotesController.clear();
                          Navigator.pushNamed(context, '/history');
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (userRole == 'Student') ...[
                    ContactList(
                      contactsFuture: fetchRCYContacts(),
                      role: 'RCY',
                      onContactTap: (phoneNumber) => _openDialer(phoneNumber),
                    ),
                  ] else if (userRole == 'Red Cross Youth') ...[
                    ContactList(
                      contactsFuture: fetchNurseContacts(),
                      role: 'Nurse',
                      onContactTap: (phoneNumber) => _openDialer(phoneNumber),
                    ),
                  ] else if (userRole == 'Nurse') ...[
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ContactButton(
                            name: 'LODIFI HOSPITAL',
                            role: 'Hospital',
                            onTap: () => _openDialer('0938 163 0291'),
                          ),
                          const SizedBox(height: 16),
                          ContactButton(
                            name: 'SAGAY RESCUE',
                            role: 'Rescue',
                            onTap: () => _openDialer('(034) 488-0300'),
                          ),
                          const SizedBox(height: 16),
                          ContactButton(
                            name: 'Alfredo E. Marañon, Sr. Memorial District Hospital',
                            role: 'Hospital',
                            onTap: () => _openDialer('(034) 213 0088'),
                          ),
                          const SizedBox(height: 16),
                          ContactButton(
                            name: 'Lopez District Farmers\' Hospital Inc',
                            role: 'Hospital',
                            onTap: () => _openDialer('(034) 488 0868'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/history'),
        child: const Icon(
          Icons.history,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFFD10A0A),
      ),
    );
  }
}
