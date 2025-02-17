import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void _updateStatus(BuildContext context, String alertId, String newStatus) {
  FirebaseFirestore.instance
      .collection('alerts')
      .doc(alertId)
      .get()
      .then((docSnapshot) {
    if (docSnapshot.exists) {
      // Document exists, update the status
      FirebaseFirestore.instance
          .collection('alerts')
          .doc(alertId)
          .update({'status': newStatus}).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $newStatus')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $error')),
        );
      });
    } else {
      print('Document with ID $alertId does not exist!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No alert found with ID: $alertId')),
      );
    }
  }).catchError((error) {
    print('Error checking document existence: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to check document existence: $error')),
    );
  });
}

class RCYVolunteerHistoryCard extends StatelessWidget {
  final String patientStatus;
  final String buildingRoom;
  final String notes;
  final String location;
  final String alertId;
  final String timestamp;
  final String sender;
  final String status;

  RCYVolunteerHistoryCard({
    required this.patientStatus,
    required this.buildingRoom,
    required this.notes,
    required this.location,
    required this.alertId,
    required this.timestamp,
    required this.sender,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender, style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Patient Status: $patientStatus"),
            Text("Bldg & Room No.: $buildingRoom"),
            Text("Notes: $notes"),
            Text("Location: $location"),
            Text("Date: $timestamp"),
            SizedBox(height: 8),
            Text(
              "Current Status: $status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == "Forwarded to Nurse" ? Colors.red : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            // Render buttons only for "Pending" or "Received" statuses
            if (status == "Pending" || status == "Received")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (status == "Pending") // Show 'Received' button for 'Pending' status
                    ElevatedButton(
                      onPressed: () {
                        if (alertId.isNotEmpty) {
                          _updateStatus(context, alertId, "Received");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Alert ID is missing!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Received",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (alertId.isNotEmpty) {
                        _updateStatus(context, alertId, "Forwarded to Nurse");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alert ID is missing!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 177, 40, 49),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Send to Nurse",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}