import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationLogic {
  Future<LatLng?> getCurrentLocation() async {
    try {
      Location location = Location();

      // Check if location services are enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return null; // Return null if location services are not enabled
        }
      }

      // Request location permissions
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return null; // Return null if permissions are denied
        }
      }

      // Get current location
      final locationData = await location.getLocation();
      return LatLng(locationData.latitude!, locationData.longitude!);
    } catch (e) {
      print('Error getting location: $e');
      return null; // Handle errors gracefully
    }
  }
}
