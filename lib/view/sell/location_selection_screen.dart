import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationSelectionScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const LocationSelectionScreen({
    super.key,
    this.initialLatitude = 18.0735, // Default to Mauritania (Nouakchott approx)
    this.initialLongitude = -15.9582,
  });

  @override
  State<LocationSelectionScreen> createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  late final MapController _mapController;
  late LatLng _currentCenter;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = LatLng(widget.initialLatitude, widget.initialLongitude);
    // Optionally try to update to current location immediately if permissions allowed
    _checkCurrentLocation();
  }

  Future<void> _checkCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition();
        setState(() {
          _currentCenter = LatLng(pos.latitude, pos.longitude);
        });
        _mapController.move(_currentCenter, 13);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(
                result: {
                  'latitude': _currentCenter.latitude.toString(),
                  'longitude': _currentCenter.longitude.toString(),
                },
              );
            },
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: Color(0xFF1B834F),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 13.0,
              onPositionChanged: (position, hasGesture) {
                setState(() {
                  _currentCenter = position.center;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.agroconnect_flutter',
              ),
            ],
          ),
          const Center(
            child: Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF1B834F),
              child: const Icon(Icons.my_location, color: Colors.white),
              onPressed: () async {
                try {
                  final pos = await Geolocator.getCurrentPosition();
                  final newCenter = LatLng(pos.latitude, pos.longitude);
                  setState(() {
                    _currentCenter = newCenter;
                  });
                  _mapController.move(newCenter, 15);
                } catch (e) {
                  Get.snackbar('Error', 'Could not get current location');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
