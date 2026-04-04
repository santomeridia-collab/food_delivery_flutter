import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;
  String _selectedAddress = '';
  bool _isLoading = true;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.6139, 77.2090), // Delhi coordinates
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _selectedPosition!, zoom: 15),
      ),
    );

    await _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    if (_selectedPosition == null) return;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedPosition!.latitude,
        _selectedPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _selectedAddress =
              '${place.street}, ${place.locality}, ${place.postalCode}';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed:
                _selectedPosition != null
                    ? () {
                      Navigator.pop(context, {
                        'position': _selectedPosition,
                        'address': _selectedAddress,
                      });
                    }
                    : null,
            child: const Text('Confirm'),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_selectedPosition != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedPosition!,
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: (latLng) {
                setState(() {
                  _selectedPosition = latLng;
                });
                _getAddressFromLatLng();
              },
              markers: {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedPosition!,
                  draggable: true,
                  onDragEnd: (newPosition) {
                    setState(() {
                      _selectedPosition = newPosition;
                    });
                    _getAddressFromLatLng();
                  },
                ),
              },
            ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        'Selected Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedAddress.isNotEmpty
                        ? _selectedAddress
                        : 'Tap on map to select location',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
