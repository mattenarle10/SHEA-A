import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sea_a/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sea_a/widgets/history_list.dart'; // Import the new HistoryList widget

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _role;
  String _selectedStatus = "Pending";
  List<QueryDocumentSnapshot>? _cachedAlerts; // Cache for the alerts
  bool _isRecentFirst = true; // Sorting toggle

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      if (_role == "Nurse") {
        _selectedStatus = "Forwarded to Nurse";
      } else {
        if (_tabController?.index == 0) {
          _selectedStatus = "Pending";
        } else if (_tabController?.index == 1) {
          _selectedStatus = "Received";
        } else if (_tabController?.index == 2) {
          _selectedStatus = "Forwarded to Nurse";
        }
      }
      _cachedAlerts = null; // Clear cache to load new data
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text("User data not found"));
          }

          _role = snapshot.data!['role'] ?? 'Student';

          // Initialize TabController once _role is determined
          _initializeTabController();

          return Column(
            children: [
              Stack(
                children: [
                  Header(title: 'History'),
                  Positioned(
                    left: 10.0,
                    top: 58.0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              _buildTabs(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Sort: ", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    DropdownButton<bool>(
                      value: _isRecentFirst,
                      underline: SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: true,
                          child: Text("Recent", style: TextStyle(fontSize: 14)),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text("Oldest", style: TextStyle(fontSize: 14)),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _isRecentFirst = value ?? true;
                          _cachedAlerts = null; // Clear cache to reload sorted data
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: _getFilteredStream(),
    builder: (context, alertSnapshot) {
      if (alertSnapshot.hasData) {
        _cachedAlerts = alertSnapshot.data!.docs;

        // Sort the cachedAlerts based on the timestamp
        _cachedAlerts?.sort((a, b) {
          Timestamp timestampA = a['timestamp'] ?? Timestamp(0, 0);
          Timestamp timestampB = b['timestamp'] ?? Timestamp(0, 0);
          return _isRecentFirst
              ? timestampB.compareTo(timestampA) // Recent first
              : timestampA.compareTo(timestampB); // Oldest first
        });
      }

      if (_cachedAlerts == null || _cachedAlerts!.isEmpty) {
        return Center(child: Text("No history available"));
      }

     return HistoryList(
        cachedAlerts: _cachedAlerts!,
        currentUserRole: _role ?? 'Student', // Pass the current user's role
      );
    },
  ),
),

            ],
          );
        },
      ),
    );
  }

  void _initializeTabController() {
    if (_tabController == null) {
      _tabController = TabController(
        length: (_role == "Nurse") ? 1 : 3,
        vsync: this,
      );
      _tabController!.addListener(_onTabChanged);
      if (_role == "Nurse") {
        _selectedStatus = "Forwarded to Nurse";
      }
    }
  }

  Widget _buildTabs() {
    if (_role == "Nurse") {
      // Only one tab for the Nurse role
      return Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: const Color.fromARGB(255, 133, 21, 21),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: "Forwarded")],
          ),
          Divider(height: 1, color: Colors.grey),
        ],
      );
    }

    // Tabs for other roles
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: const Color.fromARGB(255, 133, 21, 21),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "Pending"),
            Tab(text: "Received"),
            Tab(text: "Forwarded"),
          ],
        ),
        Divider(height: 1, color: Colors.grey),
      ],
    );
  }

  Stream<QuerySnapshot> _getFilteredStream() {
    User? user = FirebaseAuth.instance.currentUser;

    if (_role == "Nurse") {
      return FirebaseFirestore.instance
          .collection('alerts')
          .where('status', isEqualTo: "Forwarded to Nurse")
          .snapshots();
    } else if (_role == "Red Cross Youth") {
      return FirebaseFirestore.instance
          .collection('alerts')
          .where('status', isEqualTo: _selectedStatus)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('alerts')
          .where('user_id', isEqualTo: user?.uid)
          .where('status', isEqualTo: _selectedStatus)
          .snapshots();
    }
  }
}
