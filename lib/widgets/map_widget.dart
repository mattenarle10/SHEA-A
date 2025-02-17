import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/map_service.dart';

class MapWidget extends StatefulWidget {
  final Function(LatLng?) onCurrentLocation;

  const MapWidget({Key? key, required this.onCurrentLocation}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;
  final MapService _mapService = MapService();
  // ignore: unused_field
  LatLng? _currentLocation;

  CameraPosition get _initialCameraPosition => _mapService.getInitialCameraPosition();
  Set<Marker> get _markers => _mapService.getMarkers();

  Future<void> _goToCurrentLocation() async {
    final location = await _mapService.getCurrentLocation();
    if (location != null) {
      setState(() {
        _currentLocation = location;
      });
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(location, 14.0),
      );
      widget.onCurrentLocation(location); // Notify parent widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
   
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1), // Add gray border
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(245, 200, 51, 51),
                onPressed: _goToCurrentLocation,
                child: const Icon(Icons.my_location, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
