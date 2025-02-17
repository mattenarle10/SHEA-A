import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseHistoryCard extends StatelessWidget {
  final String id;
  final String patientStatus;
  final String buildingRoom;
  final String notes;
  final String status;
  final String location;
  final String timestamp;
  final String sender;

  NurseHistoryCard({
    required this.id,
    required this.patientStatus,
    required this.buildingRoom,
    required this.notes,
    required this.location,
    required this.status,
    required this.timestamp,
    required this.sender,
  });

  Future<void> _deleteAlert(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this alert? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 251, 132, 121),
                
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance.collection('alerts').doc(id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alert deleted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete alert: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Patient Status: $patientStatus"),
            Text("Bldg & Room No.: $buildingRoom"),
            Text("Notes: $notes"),
            Text("Location: $location"),
            Text("Date: $timestamp"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: status == "Received"
                        ? Colors.green
                        : (status == "Forwarded to Nurse" ? Colors.red : Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: () => _deleteAlert(context),
                  icon: Icon(Icons.delete, color: Colors.red),
                  tooltip: "Delete Alert",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
