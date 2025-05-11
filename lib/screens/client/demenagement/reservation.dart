import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:zomo/screens/client/navigation_screen.dart';

class Reservation extends StatefulWidget {
  const Reservation({super.key});

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  final _formKey = GlobalKey<FormState>();
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
  List<Map<String, dynamic>> selectedItems = [];
  TextEditingController destinationController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  final items = [
    {
      'id': 1,
      'name': 'Salon',
      'image': 'assets/salon.png',
    },
    {
      'id': 2,
      'name': 'Salle à manger',
      'image': 'assets/desktop.png',
    },
    {
      'id': 3,
      'name': 'Cuisine',
      'image': 'assets/cuisine.png',
    },
    {
      'id': 4,
      'name': 'Télévision Meuble',
      'image': 'assets/tvroom.png',
    },
    {
      'id': 5,
      'name': 'Chambre à coucher',
      'image': 'assets/bedroom.png',
    },
  ];
  final chauffeurs = [
    {
      'id': 1,
      'name': 'Chauffeur 1',
      'rate': '4.5',
      'image': 'assets/person.png',
      'vehicle': 'Fourgonnette',
    },
    {
      'id': 2,
      'name': 'Chauffeur 2',
      'rate': '4.2',
      'image': 'assets/person1.png',
      'vehicle': 'Fourgon',
    },
    {
      'id': 3,
      'name': 'Chauffeur 3',
      'rate': '4.7',
      'image': 'assets/person2.png',
      'vehicle': 'Fourgonnette',
    },
    {
      'id': 3,
      'name': 'Chauffeur 4',
      'rate': '4.7',
      'image': 'assets/person3.png',
      'vehicle': 'Camionnette',
    },
  ];
  int selectedChauffeur = 0;
  void resetAll() {
    resetAddressSection();
    resetDateTimeSection();
    resetFloorSection();
  }

  void resetAddressSection() {
    setState(() {
      fromController.clear();
      destinationController.clear();
    });
  }

  void resetDateTimeSection() {
    setState(() {
      selectedDate = DateTime.now();
      dateController.clear();
      selectedHour = 1;
      selectedMinute = 0;
      selectedPeriod = 'AM';
    });
  }

  void resetFloorSection() {
    setState(() {
      selectedFloor = 1;
    });
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
                    if (index > 0) {
                      setState(() {
                        index--;
                      });
                    } else {
                      Get.back();
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
                      language == 'fr' ? 'Filtrer' : 'Filter',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  index == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                language == 'fr'
                                    ? 'Type de ménagement'
                                    : 'Type of move',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedType = 'professionnel';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: selectedType == 'professionnel'
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color: selectedType ==
                                                      'professionnel'
                                                  ? kPrimaryColor
                                                  : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Professionnel'
                                                : 'Professional',
                                            style: TextStyle(
                                              color: selectedType ==
                                                      'professionnel'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedType = 'petit';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: selectedType == 'petit'
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color: selectedType == 'petit'
                                                  ? kPrimaryColor
                                                  : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Petit déménagement'
                                                : 'Small move',
                                            style: TextStyle(
                                              color: selectedType == 'petit'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedType = 'particulier';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: selectedType == 'particulier'
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color:
                                                  selectedType == 'particulier'
                                                      ? kPrimaryColor
                                                      : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Particulier'
                                                : 'Private',
                                            style: TextStyle(
                                              color:
                                                  selectedType == 'particulier'
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                language == 'fr'
                                    ? 'Taille du véhicule'
                                    : 'Vehicle size',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedSize = 'Fourgonnette';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: selectedSize == 'Fourgonnette'
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color:
                                                  selectedSize == 'Fourgonnette'
                                                      ? kPrimaryColor
                                                      : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Fourgonnette'
                                                : 'Van',
                                            style: TextStyle(
                                              color:
                                                  selectedSize == 'Fourgonnette'
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedSize = 'Fourgon';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: selectedSize == 'Fourgon'
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color: selectedSize == 'Fourgon'
                                                  ? kPrimaryColor
                                                  : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Fourgon'
                                                : 'Truck',
                                            style: TextStyle(
                                              color: selectedSize == 'Fourgon'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedSize = 'Poids lourd';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: selectedSize == 'Poids lourd'
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color:
                                                  selectedSize == 'Poids lourd'
                                                      ? kPrimaryColor
                                                      : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Poids lourd'
                                                : 'Heavy load',
                                            style: TextStyle(
                                              color:
                                                  selectedSize == 'Poids lourd'
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                language == 'fr' ? ' Distance' : ' Distance',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedDistance = 'Longue distance';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: selectedDistance ==
                                                  'Longue distance'
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color: selectedDistance ==
                                                      'Longue distance'
                                                  ? kPrimaryColor
                                                  : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Longue distance'
                                                : 'Long distance',
                                            style: TextStyle(
                                              color: selectedDistance ==
                                                      'Longue distance'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedDistance =
                                              'Déménagement local';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: selectedDistance ==
                                                  'Déménagement local'
                                              ? kPrimaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color: selectedDistance ==
                                                      'Déménagement local'
                                                  ? kPrimaryColor
                                                  : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Déménagement local'
                                                : 'Local move',
                                            style: TextStyle(
                                              color: selectedDistance ==
                                                      'Déménagement local'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 2.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedDistance = 'Entre villes';
                                        });
                                      },
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color:
                                              selectedDistance == 'Entre villes'
                                                  ? kPrimaryColor
                                                  : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25.sp),
                                          border: Border.all(
                                              color: selectedDistance ==
                                                      'Entre villes'
                                                  ? kPrimaryColor
                                                  : Colors.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            language == 'fr'
                                                ? 'Entre villes'
                                                : 'Between cities',
                                            style: TextStyle(
                                              color: selectedDistance ==
                                                      'Entre villes'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : index == 1
                          ? Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Adresse Section
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(language == 'fr'
                                            ? 'Adresse'
                                            : 'Address',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextButton(
                                          onPressed: resetAddressSection,
                                          child: Text(language == 'fr'
                                              ? 'Réinitialiser'
                                              : 'Reset',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
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
                                            controller: fromController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return language == 'fr'
                                                    ? 'Obligatoire'
                                                    : 'Required';
                                              }
                                              return null;
                                            },
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.sp),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade200),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.sp),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade200),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.sp),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade200),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.sp),
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              labelText: language == 'fr'
                                                  ? 'De'
                                                  : 'From',
                                              suffixIcon: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(Icons
                                                          .location_on_outlined),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        SizedBox(
                                          height: 5.h,
                                          width: 40.w,
                                          child: TextFormField(
                                            controller: destinationController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return language == 'fr'
                                                    ? 'Obligatoire'
                                                    : 'Required';
                                              }
                                              return null;
                                            },
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.sp),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade200),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.sp),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade200),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        25.sp),
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade200),
                                              ),
                                              labelText: language == 'fr'
                                                  ? 'A'
                                                  : 'To',
                                              suffixIcon: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(Icons
                                                          .location_on_outlined),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                        Text(language == 'fr'
                                            ? 'Date et heure'
                                            : 'Date and time',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextButton(
                                          onPressed: resetDateTimeSection,
                                          child: Text(language == 'fr'
                                              ? 'Réinitialiser'
                                              : 'Reset',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ),
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
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                      primary: kPrimaryColor,
                                                      onPrimary: Colors.white,
                                                      surface: Colors.white,
                                                      onSurface: Colors.black,
                                                    ),
                                                    dialogBackgroundColor:
                                                        Colors.white,
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
                                          labelText: language == 'fr'
                                              ? 'Date'
                                              : 'Date',
                                          prefixIcon: Icon(Icons.calendar_month,
                                              color: Colors.grey.shade400),
                                          suffixIcon: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                      Icons.arrow_drop_down),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Hour
                                        Container(
                                          width: 12.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: DropdownButton<int>(
                                            icon: Container(),
                                            value: selectedHour,
                                            underline: SizedBox(),
                                            isExpanded: true,
                                            items: List.generate(
                                                    12, (index) => index + 1)
                                                .map((hour) => DropdownMenuItem(
                                                      value: hour,
                                                      child: Center(
                                                          child: Text(hour
                                                              .toString()
                                                              .padLeft(
                                                                  2, '0'))),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedHour = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(language == 'fr'
                                            ? ':'
                                            : ':',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        SizedBox(width: 8),
                                        // Minute
                                        Container(
                                          width: 12.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: DropdownButton<int>(
                                            icon: Container(),
                                            value: selectedMinute,
                                            underline: SizedBox(),
                                            isExpanded: true,
                                            items: List.generate(
                                                    60, (index) => index)
                                                .map((min) => DropdownMenuItem(
                                                      value: min,
                                                      child: Center(
                                                          child: Text(min
                                                              .toString()
                                                              .padLeft(
                                                                  2, '0'))),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedMinute = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        // AM/PM
                                        ToggleButtons(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          selectedColor: Colors.white,
                                          fillColor: kPrimaryColor,
                                          color: Colors.black,
                                          isSelected: [
                                            selectedPeriod == 'AM',
                                            selectedPeriod == 'PM',
                                          ],
                                          onPressed: (int index) {
                                            setState(() {
                                              selectedPeriod =
                                                  index == 0 ? 'AM' : 'PM';
                                            });
                                          },
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Text(language == 'fr'
                                                  ? 'AM'
                                                  : 'AM',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Text(language == 'fr'
                                                  ? 'PM'
                                                  : 'PM',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Add your date and time pickers here
                                  // ...
                                  SizedBox(height: 16),
                                  // Etage Section
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 1.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(language == 'fr'
                                            ? 'Etage'
                                            : 'Floor',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextButton(
                                          onPressed: resetFloorSection,
                                          child: Text(language == 'fr'
                                              ? 'Réinitialiser'
                                              : 'Reset',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 5.h,
                                      width: 80.w,
                                      child: DropdownButtonFormField(
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        value: selectedFloor,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedFloor = value!;
                                          });
                                        },
                                        items: List.generate(
                                                5, (index) => index + 1)
                                            .map((floor) => DropdownMenuItem(
                                                  value: floor,
                                                  child: Center(
                                                      child: Text(
                                                          floor.toString())),
                                                ))
                                            .toList(),
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
                                          labelText: language == 'fr'
                                              ? 'Etage'
                                              : 'Floor',
                                          prefixIcon: Icon(Icons.home_work,
                                              color: Colors.grey.shade400),
                                          suffixIcon: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                      Icons.arrow_drop_down),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Add your floor selection here
                                  // ...
                                  SizedBox(height: 24),
                                  // Buttons
                                ],
                              ),
                            )
                          : index == 2
                              ? SizedBox(
                                  height: 60.h,
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.5,
                                    ),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) => Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 20.h,
                                            width: 20.h,
                                            child: Material(
                                              color: selectedItems
                                                      .contains(items[index])
                                                  ? kPrimaryColor
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20.sp),
                                              elevation: 2,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10.h,
                                                    width: 10.h,
                                                    child: Image.asset(
                                                        items[index]['image']
                                                            as String),
                                                  ),
                                                  Text(items[index]['name']
                                                      as String),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (selectedItems
                                                .contains(items[index])) {
                                              setState(() {
                                                selectedItems
                                                    .remove(items[index]);
                                              });
                                            } else {
                                              setState(() {
                                                selectedItems.add(items[index]);
                                              });
                                            }
                                          },
                                          icon: selectedItems
                                                  .contains(items[index])
                                              ? Icon(
                                                  Icons.remove_circle,
                                                  color: selectedItems.contains(
                                                          items[index])
                                                      ? Colors.white
                                                      : kPrimaryColor,
                                                  size: 20.sp,
                                                )
                                              : Icon(
                                                  Icons.add_circle,
                                                  color: kPrimaryColor,
                                                  size: 20.sp,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 42.h,
                                  width: 100.w,
                                  child: ListView.builder(
                                    shrinkWrap: false,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: chauffeurs.length,
                                    itemBuilder: (context, index) {
                                      final chauffeur = chauffeurs[index];
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 1.h),
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
                                                      child: Image.asset(
                                                        chauffeur['image']
                                                            .toString(),
                                                        width: 30.sp,
                                                        height: 30.sp,
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
                                                            chauffeur['name']
                                                                as String,
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
                                                                chauffeur[
                                                                        'rate']
                                                                    as String,
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
                                                                chauffeur[
                                                                        'vehicle']
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
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          setState(
                                                                              () {
                                                                            selectedChauffeur =
                                                                                chauffeur['id'] as int;
                                                                          });
                                                                          await showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
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
                                                                                        language == 'fr' ? 'Vous avez gagné x points' : 'You have won x points',
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
                                                                                              Get.to(() => NavigationScreen(
                                                                                                    showDialog: true,
                                                                                                  ));
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
                                  .slideX(duration: 500.ms, begin: 1, end: 0),
                  SizedBox(height: 2.h),
                  index != 3
                      ? Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: index > 0
                                ? MainAxisAlignment.spaceAround
                                : MainAxisAlignment.center,
                            children: [
                              index > 0
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(40.w, 6.h),
                                        elevation: 0,
                                        backgroundColor: kSecondaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (index == 1) {
                                          resetAll();
                                        }
                                      },
                                      child: Text(
                                        language == 'fr'
                                            ? 'Réinitialiser'
                                            : 'Reset',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ))
                                  : Container(),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: index > 0
                                        ? Size(40.w, 6.h)
                                        : Size(60.w, 7.h),
                                    elevation: 0,
                                    backgroundColor: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (index == 0) {
                                      if (selectedType == '') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(language == 'fr'
                                                ? 'Veuillez sélectionner un type de déménagement'
                                                : 'Please select a type of move'),
                                            backgroundColor: kPrimaryColor,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        return;
                                      } else if (selectedSize == '') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(language == 'fr'
                                                ? 'Veuillez sélectionner une taille'
                                                : 'Please select a size'),
                                            backgroundColor: kPrimaryColor,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        return;
                                      } else if (selectedDistance == '') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(language == 'fr'
                                                ? 'Veuillez sélectionner une distance'
                                                : 'Please select a distance'),
                                            backgroundColor: kPrimaryColor,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() {
                                        index++;
                                      });
                                    } else if (index == 1) {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          index++;
                                        });
                                      }
                                    } else if (index == 2) {
                                      if (selectedItems.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(language == 'fr'
                                                ? 'Veuillez sélectionner des items'
                                                : 'Please select items'),
                                            backgroundColor: kPrimaryColor,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        return;
                                      }
                                      setState(() {
                                        index++;
                                      });
                                    }
                                  },
                                  child: Text(
                                    language == 'fr' ? 'Suivant' : 'Next',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ],
                          ),
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
}
