// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/models/transporteur.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:zomo/services/reservationservices.dart';
import 'package:zomo/services/transporteurservices.dart';

class Colis extends StatefulWidget {
  const Colis({super.key});
  @override
  State<Colis> createState() => _ColisState();
}

class _ColisState extends State<Colis> {
  Future<Map<String, dynamic>> storeReservation() async {
    try {
      final reservation = await ReservationServices.storeReservation(
        dateReservation: selectedDate.toString(),
        status: 'en_attente',
        clientId: clientData!.id!,
        transporteurId: selectedTransporteur!.id!,
        serviceId: 3,
        colisSize: selectedItem,
        from: fromController.text,
        to: destinationController.text,
      );
      return reservation;
    } catch (e) {
      // ignore: avoid_print
      print('Error storing reservation: $e');
      return {};
    }
  }

  String selectedType = '';
  String selectedSize = '';
  String selectedDistance = '';
  int index = 0;
  int selectedFloor = 1;
  int selectedHour = 1;
  int selectedMinute = 0;
  String selectedPeriod = 'AM';
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  String? selectedItem;
  TextEditingController destinationController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final colis = [
    {
      'id': 1,
      'name': '0kg - 5kg',
      'image': 'assets/0kg.png',
    },
    {
      'id': 2,
      'name': '5kg - 25kg',
      'image': 'assets/5kg.png',
    },
    {
      'id': 3,
      'name': '25kg - 100',
      'image': 'assets/25kg.png',
    },
  ];

  Transporteur? selectedTransporteur;
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
      if (mounted) {
        setState(() {
          gettingTransporteurs = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.topCenter,
      children: [
        // Header Image
        SizedBox(
          width: 100.w,
          height: 20.h,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Header Image
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  image: DecorationImage(
                    image: AssetImage('assets/headerImage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/miniLogo.png',
                  width: 50.w,
                  height: 8.h,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      Get.back();
                    } else {
                      setState(() {
                        index--;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Container(
                      width: 10.w,
                      height: 10.h,
                      decoration: BoxDecoration(
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
            height: 85.h,
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
                  SizedBox(height: 3.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      language == 'fr'
                          ? 'Détail du colis'
                          : 'Detail of the colis',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  index == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: SizedBox(
                                height: 15.h,
                                child: ListView.builder(
                                  itemCount: colis.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Stack(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedItem == colis[index]['name']
                                                ? selectedItem = null
                                                : selectedItem = colis[index]
                                                        ['name']
                                                    .toString();
                                          });
                                        },
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 12.h,
                                              width: 12.h,
                                              child: Material(
                                                color: selectedItem ==
                                                        colis[index]['name']
                                                    ? kPrimaryColor
                                                    : Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20.sp),
                                                    bottomLeft:
                                                        Radius.circular(20.sp),
                                                    bottomRight:
                                                        Radius.circular(20.sp)),
                                                elevation: 2,
                                                child: Column(
                                                  children: [
                                                    Text(colis[index]['name']
                                                        as String),
                                                    SizedBox(
                                                      height: 8.h,
                                                      width: 8.h,
                                                      child: Image.asset(
                                                          colis[index]['image']
                                                              as String),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: selectedItem ==
                                                  colis[index]['name']
                                              ? kPrimaryColor
                                              : Colors.white,
                                          size: 20.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Adresse Section
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 1.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language == 'fr' ? 'Adresse' : 'Address',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      language == 'fr'
                                          ? 'Réinitialiser'
                                          : 'Reset',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            Form(
                              key: formKey,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 1.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                      width: 40.w,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return language == 'fr'
                                                ? 'Obligatoire'
                                                : 'Required';
                                          }
                                          return null;
                                        },
                                        controller: fromController,
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                          labelText: 'De',
                                          suffixIcon:
                                              Icon(Icons.location_on_outlined),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      height: 5.h,
                                      width: 40.w,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return language == 'fr'
                                                ? 'Obligatoire'
                                                : 'Required';
                                          }
                                          return null;
                                        },
                                        controller: destinationController,
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.sp),
                                            borderSide: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                          labelText: 'A',
                                          suffixIcon:
                                              Icon(Icons.location_on_outlined),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            // Date et heure Section
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 1.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language == 'fr' ? 'Date' : 'Date',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      language == 'fr'
                                          ? 'Réinitialiser'
                                          : 'Reset',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 5.h,
                                width: 80.w,
                                child: TextFormField(
                                  controller: dateController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return language == 'fr'
                                          ? 'Obligatoire'
                                          : 'Required';
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 365)),
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: kPrimaryColor,
                                                onPrimary: Colors.white,
                                                surface: Colors.white,
                                                onSurface: Colors.black,
                                              ),
                                              dialogTheme: DialogThemeData(
                                                  backgroundColor:
                                                      Colors.white),
                                            ),
                                            child: child!,
                                          );
                                        });
                                    if (date != null) {
                                      setState(() {
                                        selectedDate = date;
                                        dateController.text =
                                            DateFormat('dd/MM/yyyy')
                                                .format(date);
                                      });
                                    }
                                  },
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 1.h),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.sp),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.sp),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.sp),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                    labelText:
                                        language == 'fr' ? 'Date' : 'Date',
                                    prefixIcon: Icon(Icons.calendar_month,
                                        color: Colors.grey.shade400),
                                    suffixIcon: Icon(Icons.arrow_drop_down),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            // Etage Section

                            // Buttons
                          ],
                        )
                      : index == 1
                          ? gettingTransporteurs
                              ? _buildShimmerLoading()
                              : SizedBox(
                                  height: 42.h,
                                  width: 100.w,
                                  child: ListView.builder(
                                    shrinkWrap: false,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: transporteurs.length,
                                    itemBuilder: (context, index) {
                                      final transporteur = transporteurs[index];
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 1.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.5),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(15.sp),
                                          child: Padding(
                                            padding: EdgeInsets.all(2.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(width: 2.w),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 12.w,
                                                      child: Image.network(
                                                        '${TransporteurServices.baseUrl}/storage/${transporteur.imageUrl}',
                                                        width: 30.sp,
                                                        height: 30.sp,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            Image.asset(
                                                          'assets/person.png',
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 2.w),
                                                    SizedBox(
                                                      width: 40.w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            transporteur
                                                                .username,
                                                            style: TextStyle(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 0.5.h),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                transporteur
                                                                    .noteMoyenne
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      17.sp,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .star_border,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Text(
                                                                transporteur
                                                                    .vehiculeType
                                                                    .toString(),
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
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      fixedSize:
                                                          Size(30.w, 4.h),
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
                                                                  Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 50.sp,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  Text(
                                                                    language ==
                                                                            'fr'
                                                                        ? 'Prêt à partir'
                                                                        : 'Ready to go',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Text(
                                                                    language ==
                                                                            'fr'
                                                                        ? 'Le chauffeur est en chemin. Merci de patienter quelques instants.'
                                                                        : 'The driver is on the way. Please wait a few moments.',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.sp),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          setState(
                                                                              () {
                                                                            index =
                                                                                1;
                                                                          });
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          language == 'fr'
                                                                              ? 'Annuler'
                                                                              : 'Cancel',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                kSecondaryColor,
                                                                            fontSize:
                                                                                17.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            selectedTransporteur =
                                                                                transporteur;
                                                                          });
                                                                          final result =
                                                                              await storeReservation();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          if (result[
                                                                              'success']) {
                                                                            await showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return Dialog(
                                                                                  backgroundColor: Colors.white,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                  ),
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.all(20),
                                                                                    child: Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.white,
                                                                                            shape: BoxShape.circle,
                                                                                            border: Border.all(
                                                                                              color: kPrimaryColor,
                                                                                            ),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: EdgeInsets.all(10.sp),
                                                                                            child: Icon(
                                                                                              Icons.attach_money_outlined,
                                                                                              color: kPrimaryColor,
                                                                                              size: 40.sp,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(height: 20),
                                                                                        Text(
                                                                                          language == 'fr' ? 'Vous avez gagné 5 points' : 'You have won 5 points',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontSize: 16.sp),
                                                                                        ),
                                                                                        SizedBox(height: 1.h),
                                                                                        Divider(
                                                                                          color: kPrimaryColor,
                                                                                        ),
                                                                                        SizedBox(height: 1.h),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            TextButton(
                                                                                              onPressed: () {
                                                                                                setState(() {
                                                                                                  showwDialog = true;
                                                                                                  rateTransporteur = transporteur;
                                                                                                });
                                                                                                Get.to(() => NavigationScreen());
                                                                                              },
                                                                                              child: Text(
                                                                                                language == 'fr' ? 'Génial' : 'Great',
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
                                                                          } else {
                                                                            Get.showSnackbar(GetSnackBar(
                                                                              message: language == 'fr' ? 'Une erreur est survenue' : 'An error occurred',
                                                                              backgroundColor: Colors.red,
                                                                              duration: const Duration(seconds: 3),
                                                                              margin: const EdgeInsets.all(10),
                                                                              padding: const EdgeInsets.all(15),
                                                                              borderRadius: 10,
                                                                              snackPosition: SnackPosition.BOTTOM,
                                                                              animationDuration: const Duration(milliseconds: 500),
                                                                            ));
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          language == 'fr'
                                                                              ? 'Terminer'
                                                                              : 'Finish',
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
                                                    child: Text(
                                                      language == 'fr'
                                                          ? 'Réserver'
                                                          : 'Book',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.sp,
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
                                )
                                  .animate()
                                  .slideX(duration: 500.ms, begin: 1, end: 0)
                          : Container(),
                  SizedBox(height: 2.h),
                  index != 3
                      ? Align(
                          alignment: Alignment.center,
                          child: index == 0
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(60.w, 6.h),
                                    elevation: 0,
                                    backgroundColor: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (selectedItem == null) {
                                      Get.showSnackbar(GetSnackBar(
                                        message: language == 'fr'
                                            ? 'Veuillez sélectionner un colis'
                                            : 'Please select a colis',
                                        backgroundColor: kPrimaryColor,
                                        duration: const Duration(seconds: 3),
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(15),
                                        borderRadius: 10,
                                        snackPosition: SnackPosition.BOTTOM,
                                        animationDuration:
                                            const Duration(milliseconds: 500),
                                      ));
                                      return;
                                    }
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        index++;
                                      });
                                      await getTransporteurs();
                                    }
                                  },
                                  child: Text(
                                    language == 'fr'
                                        ? 'Envoyer la demande'
                                        : 'Send request',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600),
                                  ))
                              : Container(),
                        )
                      : Container(),
                ],
              ).animate().slideX(duration: 500.ms, begin: -1, end: 0),
            ),
          ),
        )
      ],
    ));
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
}
