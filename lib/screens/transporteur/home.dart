import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// ignore: must_be_immutable
class HomePageTransporteur extends StatefulWidget {
  const HomePageTransporteur({
    super.key,
  });

  @override
  State<HomePageTransporteur> createState() => _HomePageTransporteurState();
}

class _HomePageTransporteurState extends State<HomePageTransporteur> {
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final PolylinePoints _polylinePoints = PolylinePoints();
  bool _isNavigating = false;
  LatLng? _destination;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      _locationData = await _location.getLocation();
      if (_locationData != null) {
        setState(() {
          _center = LatLng(_locationData!.latitude!, _locationData!.longitude!);
          _origin = _center;
          _markers.add(
            Marker(
              markerId: const MarkerId('origin'),
              position: _center,
              infoWindow: const InfoWindow(title: 'Your Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
            ),
          );
        });

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _center,
              zoom: 10.0,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _getPolyline() async {
    if (_origin == null || _destination == null) return;

    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyAAHfvxLbO689cJyTwr5caSdTKyzbJEAOE',
      request: PolylineRequest(
        origin: PointLatLng(_origin!.latitude, _origin!.longitude),
        destination:
            PointLatLng(_destination!.latitude, _destination!.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylineCoordinates,
          ),
        );
      });
    }
  }

  

  void _startNavigation(LatLng destination) {
    setState(() {
      _destination = destination;
      _isNavigating = true;
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
    _getPolyline();
  }

  void _stopNavigation() {
    setState(() {
      _isNavigating = false;
      _destination = null;
      _markers.removeWhere((marker) => marker.markerId.value == 'destination');
      _polylines.clear();
    });
  }

  int carouselIndex = 0;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  GoogleMapController? mapController;
  LatLng _center = const LatLng(36.8065, 10.1815);
  LatLng? _origin;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_locationData != null) {
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: 100.w,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              compassEnabled: true,
              buildingsEnabled: true,
              trafficEnabled: true,
              padding: const EdgeInsets.only(bottom: 16),
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _center = position.target;
                });
              },
              onTap: _isNavigating
                  ? null
                  : (LatLng position) {
                      _startNavigation(position);
                    },
            ),
          ).animate().fadeIn(duration: 500.ms).animate(),
          if (_isNavigating)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Navigation Active',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _stopNavigation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Stop Navigation'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
