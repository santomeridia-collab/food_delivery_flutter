import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/delivery_partener/model/delivery_order_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';

class DeliveryMap extends StatefulWidget {
  final LatLng restaurantLocation;
  final LatLng customerLocation;
  final DeliveryOrderStatus currentStatus;
  final bool isNavigating;

  const DeliveryMap({
    super.key,
    required this.restaurantLocation,
    required this.customerLocation,
    required this.currentStatus,
    this.isNavigating = false,
  });

  @override
  State<DeliveryMap> createState() => _DeliveryMapState();
}

class _DeliveryMapState extends State<DeliveryMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Timer? _navigationTimer;
  LatLng? _currentLocation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupMarkers();
    _drawRoute();
    if (widget.isNavigating) {
      _startNavigationSimulation();
    }
  }

  @override
  void didUpdateWidget(DeliveryMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isNavigating != oldWidget.isNavigating) {
      if (widget.isNavigating) {
        _startNavigationSimulation();
      } else {
        _stopNavigationSimulation();
      }
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _setupMarkers() {
    _markers.clear();

    // Restaurant Marker
    _markers.add(
      Marker(
        markerId: const MarkerId('restaurant'),
        position: widget.restaurantLocation,
        infoWindow: const InfoWindow(title: 'Restaurant'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );

    // Customer Marker
    _markers.add(
      Marker(
        markerId: const MarkerId('customer'),
        position: widget.customerLocation,
        infoWindow: const InfoWindow(title: 'Customer'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    // Delivery Partner Marker (if navigating)
    if (widget.isNavigating && _currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('delivery'),
          position: _currentLocation!,
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }
  }

  void _drawRoute() {
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: [widget.restaurantLocation, widget.customerLocation],
      color: AppTheme.primaryColor,
      width: 4,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );

    _polylines.add(polyline);
  }

  void _startNavigationSimulation() {
    _navigationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (_progress >= 1.0) {
        timer.cancel();
        setState(() {
          _currentLocation = widget.customerLocation;
        });
        _setupMarkers();
        _animateCameraToCurrentLocation();
      } else {
        setState(() {
          _progress += 0.005;
          // Interpolate position between restaurant and customer
          final lat =
              widget.restaurantLocation.latitude +
              (widget.customerLocation.latitude -
                      widget.restaurantLocation.latitude) *
                  _progress;
          final lng =
              widget.restaurantLocation.longitude +
              (widget.customerLocation.longitude -
                      widget.restaurantLocation.longitude) *
                  _progress;
          _currentLocation = LatLng(lat, lng);
        });
        _setupMarkers();
        _animateCameraToCurrentLocation();
      }
    });
  }

  void _stopNavigationSimulation() {
    _navigationTimer?.cancel();
    setState(() {
      _progress = 0.0;
      _currentLocation = null;
    });
    _setupMarkers();
  }

  void _animateCameraToCurrentLocation() {
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 15),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.restaurantLocation,
            zoom: 12,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
        ),

        // Navigation Info Overlay
        if (widget.isNavigating)
          Positioned(
            top: 16.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.navigation,
                        color: AppTheme.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      const Text(
                        'Navigation Active',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey.shade200,
                      color: AppTheme.primaryColor,
                      minHeight: 4.h,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14.sp, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          'Destination: ${widget.currentStatus == DeliveryOrderStatus.accepted ? "Restaurant" : "Customer"}',
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ),
                      Text(
                        'ETA: ${_calculateETA()}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        // Info when not navigating
        if (!widget.isNavigating)
          Positioned(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tap "Start Navigation" to begin',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Get turn-by-turn directions to your destination',
                          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _calculateETA() {
    final latDiff =
        widget.restaurantLocation.latitude - widget.customerLocation.latitude;
    final lngDiff =
        widget.restaurantLocation.longitude - widget.customerLocation.longitude;

    final distance = sqrt((latDiff * latDiff + lngDiff * lngDiff).abs()) * 111;

    final remainingProgress = 1.0 - _progress;
    final remainingDistance = distance * remainingProgress;

    final etaMinutes = (remainingDistance * 4).toInt(); // ~15 km/h

    if (etaMinutes < 1) return 'Arriving soon';
    if (etaMinutes < 60) return '$etaMinutes min';
    return '${(etaMinutes / 60).floor()} hr ${etaMinutes % 60} min';
  }
}
