import 'package:flutter/material.dart';

class StudentHistoryCard extends StatelessWidget {
  final String patientStatus;
  final String buildingRoom;
  final String notes;
  final String status;
  final String timestamp;
  final String sender;
  final String alertId;  // Add alertId as a parameter
  final String location; // New parameter for location (latitude and longitude)

  StudentHistoryCard({
    required this.patientStatus,
    required this.buildingRoom,
    required this.notes,
    required this.status,
    required this.timestamp,
    required this.sender,
    required this.alertId, // Accept alertId here
    required this.location, // Accept location here
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
          
            Text("Location: $location"),  // Display location here
              Text("Date: $timestamp"),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status == "Received"
                      ? Colors.green
                      : (status == "Forwarded to Nurse" ? Colors.red : Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
