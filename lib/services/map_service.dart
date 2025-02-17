import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapService {
  // Method to create an initial map location
  CameraPosition getInitialCameraPosition() {
    return const CameraPosition(
      target: LatLng(10.8915131, 123.411011), // Example: Cebu, Philippines
      zoom: 18.0,
    );
  }

  // Method to handle map updates or marker placements
  Set<Marker> getMarkers() {
    return {
      const Marker(
        markerId: MarkerId('1'),
        position: LatLng(10.8915131, 123.411011),
        infoWindow: InfoWindow(title: 'Example Marker'),
      ),
    };
  }

  // Method to get the user's current location
  Future<LatLng?> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // Get the current location
    final locationData = await location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }
}