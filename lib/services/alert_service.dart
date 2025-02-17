import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlertService {
  Future<void> sendAlert({
    required String role,
    required String patientStatus,
    required String buildingRoom,
    required String additionalNotes,
    required LatLng location,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch user details
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final firstName = userDoc.data()?['first_name'] ?? 'Unknown';
      final lastName = userDoc.data()?['last_name'] ?? 'User';
      final fullName = '$firstName $lastName';

      final alertData = {
        'user_id': user.uid,
        'user_name': fullName,
        'role': role,
        'patient_status': patientStatus,
        'building_room': buildingRoom,
        'additional_notes': additionalNotes,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'status': 'Pending',
        'timestamp': Timestamp.now(),
      };

      // Add alert to both active_alerts and alerts
      await FirebaseFirestore.instance.runTransaction((transaction) async {
  
        final alertsRef = FirebaseFirestore.instance.collection('alerts').doc();

   
        transaction.set(alertsRef, alertData);
      });
    }
  }
}
