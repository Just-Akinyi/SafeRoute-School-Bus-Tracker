// lib/screens/dashboard/parent_dashboard.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/logout_util.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Parent Dashboard"),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => confirmLogout(context),
              tooltip: 'Logout',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map), text: "Live Map"),
              Tab(icon: Icon(Icons.notifications), text: "Alerts"),
              Tab(icon: Icon(Icons.timer), text: "ETA"),
              Tab(icon: Icon(Icons.person), text: "Driver"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [LiveMapTab(), AlertsTab(), EtaTab(), DriverInfoTab()],
        ),
      ),
    );
  }
}

// ==================== TAB SCREENS BELOW ====================
class LiveMapTab extends StatefulWidget {
  const LiveMapTab({super.key});

  @override
  State<LiveMapTab> createState() => _LiveMapTabState();
}

class _LiveMapTabState extends State<LiveMapTab> {
  GoogleMapController? _mapController;
  LatLng? _busLocation;
  String? busId;

  @override
  void initState() {
    super.initState();
    _fetchBusIdAndStart();
  }

  Future<void> _fetchBusIdAndStart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final childDocs =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('children')
              .get();

      if (childDocs.docs.isNotEmpty) {
        final childData = childDocs.docs.first.data();
        final fetchedBusId = childData['busId'] as String?;
        if (fetchedBusId != null) {
          setState(() {
            busId = fetchedBusId;
          });
          _subscribeToBusLocation();
        } else {
          throw Exception("No busId found for child.");
        }
      } else {
        throw Exception("No child data found.");
      }
    } catch (e) {
      print("❌ Error fetching busId: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch bus assignment: $e")),
      );
    }
  }

  void _subscribeToBusLocation() {
    if (busId == null) return;
    FirebaseFirestore.instance
        .collection('buses')
        .doc(busId)
        .snapshots()
        .listen((doc) {
          if (doc.exists) {
            final data = doc.data()!;
            setState(() {
              _busLocation = LatLng(data['lat'], data['lng']);
            });

            if (_mapController != null) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLng(_busLocation!),
              );
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    if (busId == null || _busLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _busLocation!, zoom: 15),
      markers: {
        Marker(
          markerId: const MarkerId('bus'),
          position: _busLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Bus: $busId'),
        ),
      },
      onMapCreated: (controller) => _mapController = controller,
    );
  }
}

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.warning, color: Colors.red),
          title: Text("Bus is running late by 10 minutes"),
        ),
        ListTile(
          leading: Icon(Icons.alt_route, color: Colors.deepOrange),
          title: Text("Bus has deviated from the assigned route"),
        ),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text("Child dropped off at home"),
        ),
      ],
    );
  }
}

class EtaTab extends StatelessWidget {
  const EtaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bus, size: 50, color: Colors.teal),
          SizedBox(height: 16),
          Text(
            "Estimated Time of Arrival: 7:45 AM",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 8),
          Text("Next Stop: St. Mary's School"),
        ],
      ),
    );
  }
}

class DriverInfoTab extends StatelessWidget {
  const DriverInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text("John Doe"),
            subtitle: Text("Driver - Bus #12"),
          ),
          SizedBox(height: 16),
          Text("Phone: +254 712 345678"),
          SizedBox(height: 8),
          Text("License: KDL 567A"),
          SizedBox(height: 8),
          Text("Experience: 5 years"),
        ],
      ),
    );
  }
}
