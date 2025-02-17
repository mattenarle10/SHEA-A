import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sea_a/widgets/historycards/rcy_history.dart';
import 'package:sea_a/widgets/historycards/student_updatehistory.dart';
import 'package:sea_a/widgets/historycards/student_history.dart';
import 'package:sea_a/widgets/historycards/nurse_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryList extends StatelessWidget {
  final List<QueryDocumentSnapshot> cachedAlerts;
  final String currentUserRole; // Current user role

  HistoryList({
    required this.cachedAlerts,
    required this.currentUserRole, // Require the role
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cachedAlerts.length,
      itemBuilder: (context, index) {
        var data = cachedAlerts[index].data() as Map<String, dynamic>;
        return _buildHistoryCard(context, data, cachedAlerts[index].id);
      },
    );
  }

  Widget _buildHistoryCard(
      BuildContext context, Map<String, dynamic> data, String alertId) {
    String role = data['role'] ?? 'Unknown Role';
    String status = data['status'] ?? 'Unknown Status';
    Timestamp? timestamp = data['timestamp'] as Timestamp?;
    String formattedTimestamp = timestamp != null
        ? DateFormat('MMMM d, y • h:mm a').format(timestamp.toDate())
        : "Unknown Date";

    String sender =
        "From: ${data['user_name'] ?? 'Unknown User'} (${data['role'] ?? 'Unknown Role'})";

    double latitude = data['latitude'] ?? 0.0;
    double longitude = data['longitude'] ?? 0.0;
    String location = "Location: $latitude, $longitude";

    if (currentUserRole == "Student") {
      // Students only see plain StudentHistoryCard
      return StudentHistoryCard(
        patientStatus: data['patient_status'] ?? 'No Status',
        buildingRoom: data['building_room'] ?? 'No Location',
        notes: data['additional_notes'] ?? 'No Notes',
        status: status,
        timestamp: formattedTimestamp,
        sender: sender,
        alertId: alertId,
        location: location,
      );
    } else if (currentUserRole == "Red Cross Youth") {
      if (status == "Forwarded to Nurse") {
        // Show NurseHistoryCard design for "Forwarded to Nurse" status
        return NurseHistoryCard(
          id: alertId,
          patientStatus: data['patient_status'] ?? 'No Status',
          buildingRoom: data['building_room'] ?? 'No Location',
          notes: data['additional_notes'] ?? 'No Notes',
          location: location,
          timestamp: formattedTimestamp,
          sender: sender,
          status: status,
        );
      } else if (role == "Red Cross Youth" && (status == "Pending" || status == "Received")) {
        // Show RCY card with buttons for RCY
        return RCYVolunteerHistoryCard(
          patientStatus: data['patient_status'] ?? 'No Status',
          buildingRoom: data['building_room'] ?? 'No Location',
          status: status,
          notes: data['additional_notes'] ?? 'No Notes',
          location: location,
          alertId: alertId,
          timestamp: formattedTimestamp,
          sender: sender,
        );
      } else if (role == "Student") {
        // RCY sees editable Student cards
        return StudentHistoryCardWithEdit(
          patientStatus: data['patient_status'] ?? 'No Status',
          buildingRoom: data['building_room'] ?? 'No Location',
          status: status,
          notes: data['additional_notes'] ?? 'No Notes',
          location: location,
          alertId: alertId,
          timestamp: formattedTimestamp,
          sender: sender,
        );
      }
    } else if (currentUserRole == "Nurse") {
      if (role == "Red Cross Youth" || role == "Student") {
        // Nurse sees NurseHistoryCard with delete button
        return NurseHistoryCard(
          id: alertId,
          patientStatus: data['patient_status'] ?? 'No Status',
          buildingRoom: data['building_room'] ?? 'No Location',
          notes: data['additional_notes'] ?? 'No Notes',
          location: location,
          timestamp: formattedTimestamp,
          sender: sender,
          status: status,
        );
      }
    }

    return const SizedBox(); // Default case if no matching role or status
  }
}
