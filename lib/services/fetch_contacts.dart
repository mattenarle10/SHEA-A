import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sea_a/services/contacts.dart';

Future<List<Contact>> fetchRCYContacts() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Red Cross Youth')
        .get();

    List<Contact> contacts = [];
    for (var doc in snapshot.docs) {
      // Handle missing fields
      String firstName = doc.data().containsKey('first_name') ? doc['first_name'] : 'Unknown';
      String lastName = doc.data().containsKey('last_name') ? doc['last_name'] : 'Unknown';
      String contactNo = doc.data().containsKey('contact_no') ? doc['contact_no'] : 'Unknown';

      String name = '$firstName $lastName';
      contacts.add(Contact(name: name, phoneNumber: contactNo));
    }

    return contacts;
  } catch (e) {
    print("Error fetching RCY contacts: $e");
    return [];
  }
}


Future<List<Contact>> fetchStudentContacts() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Student')
        .get();

    List<Contact> contacts = [];
    for (var doc in snapshot.docs) {
      String name = '${doc['first_name']} ${doc['last_name']}';
      String contactNo = doc['contact_no'];
      contacts.add(Contact(name: name, phoneNumber: contactNo));
    }

    return contacts;
  } catch (e) {
    print("Error fetching Student contacts: $e");
    return [];
  }
}


Future<List<Contact>> fetchNurseContacts() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Nurse')
        .get();

    List<Contact> contacts = [];
    for (var doc in snapshot.docs) {
      String name = '${doc['first_name']} ${doc['last_name']}';
      String contactNo = doc['contact_no'];
      contacts.add(Contact(name: name, phoneNumber: contactNo));
    }

    return contacts;
  } catch (e) {
    print("Error fetching Nurse contacts: $e");
    return [];
  }
}
