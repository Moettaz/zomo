import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
// import 'package:geolocator/geolocator.dart';

class SelectCar extends StatefulWidget {
  const SelectCar({super.key});

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  GoogleMapController? mapController;
  LatLng _center = const LatLng(36.8065, 10.1815);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _origin;
  LatLng? _destination;
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final PolylinePoints _polylinePoints = PolylinePoints();
  int selectedVehicle = 0;
  String _selectedPaymentMethod = 'Cash';

  @override
  void initState() {
    super.initState();
    // _getCurrentLocation();
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         return;
  //       }
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     setState(() {
  //       _center = LatLng(position.latitude, position.longitude);
  //       _origin = _center;
  //       _markers.add(
  //         Marker(
  //           markerId: const MarkerId('origin'),
  //           position: _center,
  //           infoWindow: const InfoWindow(title: 'Your Location'),
  //         ),
  //       );
  //     });

  //     mapController?.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           target: _center,
  //           zoom: 15.0,
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint('Error getting location: $e');
  //   }
  // }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  String _selectedGender = 'women';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.topCenter,
      children: [
        // Google Map
        SizedBox(
          width: 100.w,
          height: 43.h,
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
                    Get.back();
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
            height: 60.h,
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
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 13.h,
                          child: Row(
                            children: [
                              Column(
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
                              SizedBox(width: 2.w),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 80.w,
                                    height: 5.h,
                                    child: GooglePlaceAutoCompleteTextField(
                                      boxDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.white),
                                      ),
                                      googleAPIKey:
                                          'AIzaSyAAHfvxLbO689cJyTwr5caSdTKyzbJEAOE',
                                      textEditingController: _originController,
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
                                      boxDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.white),
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
                            ],
                          ),
                        ),
                        SizedBox(height: 0.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: kPrimaryColor),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.man,
                                      color: _selectedGender == 'men'
                                          ? Colors.white
                                          : kPrimaryColor,
                                    ),
                                    Text(
                                      language == 'fr' ? 'Homme' : 'Men',
                                      style: TextStyle(
                                        color: _selectedGender == 'men'
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
                                  _selectedGender = 'women';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _selectedGender == 'women'
                                      ? kPrimaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: kPrimaryColor),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.woman,
                                      color: _selectedGender == 'women'
                                          ? Colors.white
                                          : kPrimaryColor,
                                    ),
                                    Text(
                                      language == 'fr' ? 'Femme' : 'Women',
                                      style: TextStyle(
                                        color: _selectedGender == 'women'
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
                          height: 50.h,
                          width: 100.w,
                          child: ListView.builder(
                            shrinkWrap: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              final vehicles = [
                                {
                                  'id': 1,
                                  'name': 'Bike',
                                  'icon': Icons.motorcycle,
                                  'duration': '15 min',
                                  'price': '5 DT',
                                  'distance': '2.5 km',
                                  'color': Colors.orange,
                                },
                                {
                                  'id': 2,
                                  'name': '4 Places Car',
                                  'icon': Icons.directions_car,
                                  'duration': '20 min',
                                  'price': '12 DT',
                                  'distance': '2.5 km',
                                  'color': Colors.blue,
                                },
                                {
                                  'id': 3,
                                  'name': 'Luxury Car',
                                  'icon': Icons.directions_car_filled,
                                  'duration': '20 min',
                                  'price': '25 DT',
                                  'distance': '2.5 km',
                                  'color': Colors.purple,
                                },
                                {
                                  'id': 4,
                                  'name': 'Van',
                                  'icon': Icons.airport_shuttle,
                                  'duration': '25 min',
                                  'price': '18 DT',
                                  'distance': '2.5 km',
                                  'color': Colors.green,
                                },
                              ];

                              final vehicle = vehicles[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: selectedVehicle == vehicle['id']
                                      ? kPrimaryColor.withOpacity(0.5)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15.sp),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedVehicle = vehicle['id'] as int;
                                      });
                                      // Handle vehicle selection
                                    },
                                    borderRadius: BorderRadius.circular(15.sp),
                                    child: Padding(
                                      padding: EdgeInsets.all(2.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 12.w,
                                            child: Icon(
                                              vehicle['icon'] as IconData,
                                              color: Colors.black,
                                              size: 30.sp,
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          SizedBox(
                                            width: 50.w,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  vehicle['name'] as String,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 0.5.h),
                                                Text(
                                                  vehicle['distance'] as String,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  vehicle['price'] as String,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 0.5.h),
                                                Text(
                                                  vehicle['duration'] as String,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.grey,
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
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  fillColor: kSecondaryColor,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.sp),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                
                                items: ['Cash', 'Card'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedPaymentMethod = value ?? 'Cash';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 100.w,
                          height: 5.h,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                  language == 'fr' ? 'Valider' : 'Validate')),
                        ),
                        SizedBox(height: 2.h),
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
