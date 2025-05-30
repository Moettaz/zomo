// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:zomo/models/transporteur.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
import 'package:zomo/services/trajetservices.dart';
import 'package:zomo/services/transporteurservices.dart';
import 'package:shimmer/shimmer.dart';
import 'package:location/location.dart';

class SelectCar extends StatefulWidget {
  const SelectCar({super.key});

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  List<Transporteur> transporteurs = [];
  bool gettingTransporteurs = false;
  getTransporteurs() async {
    setState(() {
      gettingTransporteurs = true;
    });
    try {
      transporteurs = await TransporteurServices.getAllTransporteurs();
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching transporteurs: $e');
    } finally {
      setState(() {
        gettingTransporteurs = false;
      });
    }
  }

  bool uploadingTrajet = false;
  Future<Map<String, dynamic>> _storeTrajet() async {
    setState(() {
      uploadingTrajet = true;
    });
    try {
      // Validate required data
      if (clientData?.id == null) {
        throw Exception('Client ID is null');
      }
      if (selectedTransporteur?.id == null) {
        throw Exception('Selected transporteur ID is null');
      }
      if (_originController.text.isEmpty) {
        throw Exception('Origin location is empty');
      }
      if (_destinationController.text.isEmpty) {
        throw Exception('Destination location is empty');
      }

      // Store trajet with validated data
      final result = await TrajetServices.storeTrajet(
        clientId: clientData!.id!,
        transporteurId: selectedTransporteur!.id!,
        serviceId: 1,
        dateHeureDepart: DateTime.now().toIso8601String(),
        dateHeureArrivee: DateTime.now().toIso8601String(),
        pointDepart: _originController.text,
        pointArrivee: _destinationController.text,
        prix: 5.0,
        etat: 'en_attente',
        methodePaiement: _selectedPaymentMethod,
      );
      // ignore: avoid_print
      print('Trajet stored successfully: $result');
      // Log success
      return result;
    } catch (e) {
      // ignore: avoid_print
      print('Error storing trajet: ${e.toString()}');
      return {
        'success': false,
        'message': 'Error storing trajet: ${e.toString()}',
      };
    } finally {
      setState(() {
        uploadingTrajet = false;
      });
    }
  }

  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  GoogleMapController? mapController;
  LatLng _center = const LatLng(36.8065, 10.1815);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _origin;
  LatLng? _destination;
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final PolylinePoints _polylinePoints = PolylinePoints();
  String selectedVehicle = '';
  String _selectedPaymentMethod = language == 'fr' ? 'Espèce' : 'Cash';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  bool showingDialog = false;

  final vehicles = [
    {
      'id': 1,
      'name': 'Voiture confortable',
      'image': "assets/car confort.png",
      'duration': '15 min',
      'price': '5 DT',
      'distance': '2.5 km',
      'color': Colors.orange,
      'type': 'confort',
    },
    {
      'id': 2,
      'name': 'Voiture luxe',
      'image': "assets/car luxe.png",
      'duration': '20 min',
      'price': '12 DT',
      'distance': '2.5 km',
      'color': Colors.blue,
      'type': 'luxe',
    },
    {
      'id': 3,
      'name': 'Moto',
      'image': "assets/single-motorbike.png",
      'duration': '20 min',
      'price': '25 DT',
      'distance': '2.5 km',
      'color': Colors.purple,
      'type': 'moto',
    },
    {
      'id': 4,
      'name': 'Taxi 4 places ',
      'image': "assets/carblack.png",
      'duration': '25 min',
      'price': '18 DT',
      'distance': '2.5 km',
      'color': Colors.green,
      'type': 'taxi',
    },
  ];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_locationData != null) {
      _getCurrentLocation();
    }
  }

  String _selectedGender = 'female';
  int selectedIndex = 0;
  Transporteur? selectedTransporteur;
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
            color: Colors.amber,
            points: polylineCoordinates,
            width: 5,
          ),
        );
      });
    }
  }

  void _onPlaceSelected(Prediction prediction, bool isOrigin) {
    // Here you would typically use the Places API to get the LatLng from the place_id
    // For now, we'll just update the text field
    if (isOrigin) {
      _originController.text = prediction.description ?? '';
    } else {
      _destinationController.text = prediction.description ?? '';
    }
  }

  Widget _buildShimmerLoading() {
    return SizedBox(
      height: 42.h,
      width: 100.w,
      child: ListView.builder(
        shrinkWrap: false,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3, // Show 3 shimmer items
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: kPrimaryColor.withOpacity(0.2),
            highlightColor: kPrimaryColor.withOpacity(0.4),
            child: Container(
              margin: EdgeInsets.only(bottom: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15.sp),
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 2.w),
                      Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40.w,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Container(
                                width: 20.w,
                                height: 15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 30.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate().slideX(duration: 500.ms, begin: 1, end: 0);
  }

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
              zoom: 15.0,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.topCenter,
      children: [
        // Google Map
        SizedBox(
          width: 100.w,
          height: selectedIndex == 0 ? 33.h : 53.h,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Google Map
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
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
              ),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    if (selectedIndex == 0) {
                      Get.back();
                    } else {
                      setState(() {
                        selectedIndex = 0;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w, top: 5.h),
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms).animate(),

        // Login Section
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 100.w,
            height: selectedIndex == 0 ? 70.h : 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.sp),
                topRight: Radius.circular(25.sp),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 13.h,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 4.w),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 10.sp,
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 10.sp,
                                    ),
                                    SizedBox(height: 0.3.h),
                                    Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 10.sp,
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      color: kPrimaryColor,
                                      size: 25.sp,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 80.w,
                                      height: 5.h,
                                      child: GooglePlaceAutoCompleteTextField(
                                        validator: (p0, p1) {
                                          if (p0 == null ||
                                              p0.isEmpty ||
                                              _originController.text == "") {
                                            return language == 'fr'
                                                ? 'Obligatoire'
                                                : 'Required';
                                          }
                                          return null;
                                        },
                                        boxDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        googleAPIKey:
                                            'AIzaSyAAHfvxLbO689cJyTwr5caSdTKyzbJEAOE',
                                        textEditingController:
                                            _originController,
                                        inputDecoration: InputDecoration(
                                          hintText: language == 'fr'
                                              ? "Entrez votre emplacement"
                                              : "Enter your location",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide.none),
                                        ),
                                        debounceTime: 800,
                                        countries: const ["tn"],
                                        isLatLngRequired: true,
                                        getPlaceDetailWithLatLng:
                                            (Prediction prediction) {
                                          _onPlaceSelected(prediction, true);
                                        },
                                        itemClick: (Prediction prediction) {
                                          _onPlaceSelected(prediction, true);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80.w,
                                      height: 1.h,
                                      child: Divider(
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    SizedBox(
                                      width: 80.w,
                                      height: 5.h,
                                      child: GooglePlaceAutoCompleteTextField(
                                        validator: (p0, p1) {
                                          if (p0 == null ||
                                              p0.isEmpty ||
                                              _destinationController.text ==
                                                  "") {
                                            return language == 'fr'
                                                ? 'Obligatoire'
                                                : 'Required';
                                          }
                                          return null;
                                        },
                                        boxDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        googleAPIKey:
                                            'AIzaSyAAHfvxLbO689cJyTwr5caSdTKyzbJEAOE',
                                        textEditingController:
                                            _destinationController,
                                        inputDecoration: InputDecoration(
                                          hintText: language == 'fr'
                                              ? "Entrez votre destination"
                                              : "Enter destination",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        debounceTime: 800,
                                        countries: const ["tn"],
                                        isLatLngRequired: true,
                                        getPlaceDetailWithLatLng:
                                            (Prediction prediction) {
                                          _onPlaceSelected(prediction, false);
                                        },
                                        itemClick: (Prediction prediction) {
                                          _onPlaceSelected(prediction, false);
                                          _getPolyline();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 0.h),
                        uploadingTrajet
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                ),
                              )
                            : selectedIndex == 0
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedGender = 'men';
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: _selectedGender == 'men'
                                                    ? kPrimaryColor
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: kPrimaryColor),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.man,
                                                    color:
                                                        _selectedGender == 'men'
                                                            ? Colors.white
                                                            : kPrimaryColor,
                                                  ),
                                                  Text(
                                                    language == 'fr'
                                                        ? 'Homme'
                                                        : 'Men',
                                                    style: TextStyle(
                                                      color: _selectedGender ==
                                                              'men'
                                                          ? Colors.white
                                                          : kPrimaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.sp),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedGender = 'female';
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                color:
                                                    _selectedGender == 'female'
                                                        ? kPrimaryColor
                                                        : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: kPrimaryColor),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.woman,
                                                    color: _selectedGender ==
                                                            'female'
                                                        ? Colors.white
                                                        : kPrimaryColor,
                                                  ),
                                                  Text(
                                                    language == 'fr'
                                                        ? 'Femme'
                                                        : 'Women',
                                                    style: TextStyle(
                                                      color: _selectedGender ==
                                                              'female'
                                                          ? Colors.white
                                                          : kPrimaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 35.h,
                                        width: 100.w,
                                        child: ListView.builder(
                                          shrinkWrap: false,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: vehicles.length,
                                          itemBuilder: (context, index) {
                                            final vehicle = vehicles[index];
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 1.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withValues(alpha: 0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Material(
                                                color: selectedVehicle ==
                                                        vehicle['type']
                                                    ? kPrimaryColor.withValues(
                                                        alpha: 0.5)
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.sp),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedVehicle =
                                                          vehicle['type']
                                                              .toString();
                                                    });
                                                    // Handle vehicle selection
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.sp),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(2.w),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 12.w,
                                                          child: Image.asset(
                                                            vehicle['image']
                                                                .toString(),
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(width: 2.w),
                                                        SizedBox(
                                                          width: 50.w,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                vehicle['name']
                                                                    as String,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      0.5.h),
                                                              Text(
                                                                vehicle['distance']
                                                                    as String,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                vehicle['price']
                                                                    as String,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      0.5.h),
                                                              Text(
                                                                vehicle['duration']
                                                                    as String,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            language == 'fr'
                                                ? 'Méthode de paiement'
                                                : 'Payment method',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          SizedBox(
                                            width: 30.w,
                                            height: 4.h,
                                            child:
                                                DropdownButtonFormField<String>(
                                              dropdownColor: Colors.white,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.sp,
                                              ),
                                              icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black),
                                              value: _selectedPaymentMethod,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                fillColor: Colors.white,
                                                filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.sp),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.sp),
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor),
                                                ),
                                              ),
                                              items: [
                                                language == 'fr'
                                                    ? 'Espèce'
                                                    : 'Cash',
                                                language == 'fr'
                                                    ? 'Carte'
                                                    : 'Card'
                                              ].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _selectedPaymentMethod =
                                                      value ?? 'Cash';
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 2.h),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(60.w, 7.h),
                                            elevation: 0,
                                            backgroundColor: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (selectedVehicle == '') {
                                                Get.showSnackbar(
                                                  GetSnackBar(
                                                    message: language == 'fr'
                                                        ? 'Veuillez sélectionner un véhicule'
                                                        : 'Please select a vehicle',
                                                    backgroundColor:
                                                        kPrimaryColor,
                                                    duration: const Duration(
                                                        seconds: 3),
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    borderRadius: 10,
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    animationDuration:
                                                        const Duration(
                                                            milliseconds: 500),
                                                  ),
                                                );
                                              } else {
                                                setState(() {
                                                  selectedIndex = 1;
                                                });
                                                getTransporteurs();
                                              }
                                            }
                                          },
                                          child: Text(
                                            language == 'fr'
                                                ? 'Valider'
                                                : 'Validate',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      SizedBox(height: 2.h),
                                    ],
                                  )
                                : selectedIndex == 1
                                    ? gettingTransporteurs
                                        ? _buildShimmerLoading()
                                        : transporteurs
                                                .where((element) =>
                                                    element.vehiculeType ==
                                                        selectedVehicle &&
                                                    element.disponibilite ==
                                                        true &&
                                                    element.gender ==
                                                        _selectedGender)
                                                .isEmpty
                                            ? Center(
                                                child: Text(
                                                  language == 'fr'
                                                      ? 'Aucun chauffeur disponible'
                                                      : 'No driver available',
                                                  style: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 42.h,
                                                width: 100.w,
                                                child: ListView.builder(
                                                  shrinkWrap: false,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: transporteurs
                                                      .where((element) =>
                                                          element.vehiculeType ==
                                                              selectedVehicle &&
                                                          element.disponibilite ==
                                                              true &&
                                                          element.gender ==
                                                              _selectedGender)
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final filteredTransporteurs = transporteurs
                                                        .where((element) =>
                                                            element.vehiculeType ==
                                                                selectedVehicle &&
                                                            element.disponibilite ==
                                                                true &&
                                                            element.gender ==
                                                                _selectedGender)
                                                        .toList();
                                                    final transporteur =
                                                        filteredTransporteurs[
                                                            index];
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 1.h),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withValues(
                                                                    alpha: 0.1),
                                                            spreadRadius: 1,
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    15.sp),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                  width: 2.w),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 12.w,
                                                                    child: transporteur.imageUrl !=
                                                                            null
                                                                        ? Image
                                                                            .network(
                                                                            '${TransporteurServices.baseUrl}/storage/${transporteur.imageUrl}',
                                                                            width:
                                                                                30.sp,
                                                                            height:
                                                                                30.sp,
                                                                            errorBuilder: (context, error, stackTrace) =>
                                                                                Image.asset(
                                                                              'assets/person.png',
                                                                            ),
                                                                          )
                                                                        : Image
                                                                            .asset(
                                                                            'assets/person.png',
                                                                          ),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          2.w),
                                                                  SizedBox(
                                                                    width: 40.w,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          transporteur
                                                                              .username,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                0.5.h),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              transporteur.noteMoyenne.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: 17.sp,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                            Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    fixedSize:
                                                                        Size(
                                                                            30.w,
                                                                            4.h),
                                                                    elevation:
                                                                        0,
                                                                    backgroundColor:
                                                                        kPrimaryColor,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      selectedTransporteur =
                                                                          transporteur;
                                                                    });
                                                                    await showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return Dialog(
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(20),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.check_circle,
                                                                                  color: kPrimaryColor,
                                                                                  size: 50.sp,
                                                                                ),
                                                                                SizedBox(height: 20),
                                                                                Text(
                                                                                  language == 'fr' ? 'Prêt à partir' : 'Ready to go',
                                                                                  style: TextStyle(
                                                                                    fontSize: 20.sp,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 10),
                                                                                Text(
                                                                                  language == 'fr' ? 'Le chauffeur est en chemin. Merci de patienter quelques instants.' : 'The driver is on the way. Please wait a few moments.',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(fontSize: 16.sp),
                                                                                ),
                                                                                SizedBox(height: 20),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(context).pop();
                                                                                        setState(() {
                                                                                          selectedIndex = 1;
                                                                                        });
                                                                                      },
                                                                                      child: Text(
                                                                                        language == 'fr' ? 'Annuler' : 'Cancel',
                                                                                        style: TextStyle(
                                                                                          color: kSecondaryColor,
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () async {
                                                                                        final result = await _storeTrajet();
                                                                                        if (result['success']) {
                                                                                          Navigator.of(context).pop();
                                                                                          setState(() {
                                                                                            selectedTransporteur = transporteur;
                                                                                            selectedIndex = 2;
                                                                                          });
                                                                                        } else {
                                                                                          Navigator.of(context).pop();

                                                                                          Get.showSnackbar(GetSnackBar(
                                                                                            message: language == 'fr' ? 'Une erreur est survenue' : 'An error occurred',
                                                                                            backgroundColor: kPrimaryColor,
                                                                                            duration: const Duration(seconds: 3),
                                                                                            margin: const EdgeInsets.all(10),
                                                                                            padding: const EdgeInsets.all(15),
                                                                                            borderRadius: 10,
                                                                                            snackPosition: SnackPosition.BOTTOM,
                                                                                            animationDuration: const Duration(milliseconds: 500),
                                                                                          ));
                                                                                        }
                                                                                      },
                                                                                      child: Text(
                                                                                        language == 'fr' ? 'Terminer' : 'Finish',
                                                                                        style: TextStyle(
                                                                                          color: kPrimaryColor,
                                                                                          fontSize: 17.sp,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    language ==
                                                                            'fr'
                                                                        ? 'Réserver'
                                                                        : 'Book',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 15
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ).animate().slideX(
                                                duration: 500.ms,
                                                begin: 1,
                                                end: 0)
                                    : SizedBox(
                                            height: 42.h,
                                            width: 100.w,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.sp),
                                                      ),
                                                      width: 70.w,
                                                      height: 7.h,
                                                      child: Center(
                                                        child: Text(
                                                          language == 'fr'
                                                              ? 'Le Chauffeur est en route'
                                                              : 'The driver is on the way',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 17.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 0.w),
                                                    Container(
                                                      width: 30.w,
                                                      height: 7.h,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.sp),
                                                        border:
                                                            Border.symmetric(
                                                          horizontal:
                                                              BorderSide(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 2.w),
                                                      child: Center(
                                                        child: Text(
                                                          "3 mn",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 17.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 2.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 20.w,
                                                      child: selectedTransporteur!
                                                                  .imageUrl !=
                                                              null
                                                          ? Image.network(
                                                              '${TransporteurServices.baseUrl}/storage/${selectedTransporteur!.imageUrl}',
                                                              width: 50.sp,
                                                              height: 50.sp,
                                                              errorBuilder: (context,
                                                                      error,
                                                                      stackTrace) =>
                                                                  Image.asset(
                                                                'assets/person.png',
                                                              ),
                                                            )
                                                          : Image.asset(
                                                              'assets/person.png',
                                                            ),
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          selectedTransporteur!
                                                              .username,
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 0.5.h),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              selectedTransporteur!
                                                                  .noteMoyenne
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 16.sp,
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .star_outline,
                                                              color:
                                                                  kSecondaryColor,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.5.h),
                                                        Row(
                                                          children: [
                                                            for (var i = 0;
                                                                i <
                                                                    selectedTransporteur!
                                                                        .noteMoyenne!
                                                                        .floor();
                                                                i++)
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                              ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.5.h),
                                                        Text(
                                                          selectedTransporteur!
                                                              .serviceId
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        SizedBox(height: 0.5.h),
                                                        Text(
                                                          selectedTransporteur!
                                                                      .vehiculeType ==
                                                                  "confort"
                                                              ? language == 'fr'
                                                                  ? 'Confort Electrique'
                                                                  : 'Electric Comfort'
                                                              : selectedTransporteur!
                                                                          .vehiculeType ==
                                                                      "luxe"
                                                                  ? language ==
                                                                          'fr'
                                                                      ? 'Voiture confortable'
                                                                      : 'Comfortable Car'
                                                                  : selectedTransporteur!
                                                                              .vehiculeType ==
                                                                          "moto"
                                                                      ? language ==
                                                                              'fr'
                                                                          ? 'Moto'
                                                                          : 'Moto'
                                                                      : language ==
                                                                              'fr'
                                                                          ? 'Taxi 4 places'
                                                                          : 'Taxi 4 places',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    SizedBox(
                                                      width: 12.w,
                                                      child: Image.asset(
                                                        "assets/yellow car.png",
                                                        width: 35.w,
                                                        height: 12.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      fixedSize:
                                                          Size(60.w, 7.h),
                                                      elevation: 0,
                                                      backgroundColor:
                                                          kPrimaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      await showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color:
                                                                            kPrimaryColor,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets
                                                                          .all(10
                                                                              .sp),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .attach_money_outlined,
                                                                        color:
                                                                            kPrimaryColor,
                                                                        size: 40
                                                                            .sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  Text(
                                                                    language ==
                                                                            'fr'
                                                                        ? 'Vous avez gagné 15 points'
                                                                        : 'You have won 15 points',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.sp),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          1.h),
                                                                  Divider(
                                                                    color:
                                                                        kPrimaryColor,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          1.h),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            showwDialog =
                                                                                true;
                                                                            rateTransporteur =
                                                                                selectedTransporteur;
                                                                          });
                                                                          Get.to(() =>
                                                                              NavigationScreen());
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          language == 'fr'
                                                                              ? 'Génial'
                                                                              : 'Great',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontSize:
                                                                                17.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.phone_outlined,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 2.w),
                                                        Text(
                                                          language == 'fr'
                                                              ? 'Appeler'
                                                              : 'Call',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ))
                                        .animate()
                                        .slideX(
                                            duration: 500.ms, begin: 1, end: 0),
                      ],
                    ),
                  ),
                ],
              ).animate().slideX(duration: 500.ms, begin: -1, end: 0),
            ),
          ),
        )
      ],
    ));
  }
}
