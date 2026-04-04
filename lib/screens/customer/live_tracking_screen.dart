import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/cancel_screen.dart';
import 'package:food_delivery/screens/customer/chat_screen.dart';
import 'package:food_delivery/screens/customer/widgets/status_timeline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'models/order_model.dart';
import 'models/tracking_model.dart';
import 'providers/tracking_provider.dart';
import 'utils/app_theme.dart';
import 'order_details_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  final Order order;
  const LiveTrackingScreen({super.key, required this.order});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initTracking();
  }

  void _initTracking() {
    final trackingProvider = Provider.of<TrackingProvider>(
      context,
      listen: false,
    );
    trackingProvider.startTracking(widget.order.id);

    // Add markers
    _updateMarkers(
      trackingProvider.deliveryPartner,
      trackingProvider.restaurantLocation,
    );
  }

  void _updateMarkers(DeliveryPartner? partner, LatLng? restaurantLocation) {
    _markers.clear();

    if (restaurantLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('restaurant'),
          position: restaurantLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
          infoWindow: const InfoWindow(title: 'Restaurant'),
        ),
      );
    }

    if (partner != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('delivery'),
          position: LatLng(partner.currentLatitude, partner.currentLongitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(title: partner.name),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ChatScreen(
                        orderId: widget.order.id,
                        restaurantName: widget.order.restaurantName,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TrackingProvider>(
        builder: (context, trackingProvider, child) {
          return Column(
            children: [
              // Status Timeline
              StatusTimeline(
                currentStatus: widget.order.status,
                statusUpdates: trackingProvider.statusUpdates,
              ),

              // Map
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target:
                        trackingProvider.restaurantLocation ??
                        const LatLng(28.6139, 77.2090),
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),

              // Delivery Partner Info
              if (trackingProvider.deliveryPartner != null)
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25.r,
                            backgroundImage: AssetImage(
                              trackingProvider.deliveryPartner!.imageUrl,
                            ),
                            child: const Icon(Icons.delivery_dining),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trackingProvider.deliveryPartner!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'ETA: ${trackingProvider.deliveryPartner!.eta} minutes',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.phone,
                                  color: AppTheme.primaryColor,
                                ),
                                onPressed: () {
                                  _makeCall(
                                    trackingProvider.deliveryPartner!.phone,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.chat,
                                  color: AppTheme.primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ChatScreen(
                                            orderId: widget.order.id,
                                            restaurantName:
                                                widget.order.restaurantName,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Fixed LinearProgressIndicator - Use SizedBox to set height
                      SizedBox(
                        height: 6.h,
                        child: LinearProgressIndicator(
                          value: trackingProvider.deliveryProgress,
                          backgroundColor: Colors.grey.shade200,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(order: widget.order),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Details'),
                ),
              ),
              SizedBox(width: 12.w),
              if (widget.order.canCancel)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CancelOrderScreen(order: widget.order),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _makeCall(String phoneNumber) {
    // Implement phone call functionality
    // Use url_launcher package: launch('tel:$phoneNumber');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Calling $phoneNumber...')));
  }
}
