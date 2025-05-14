import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class Colis extends StatefulWidget {
  const Colis({super.key});

  @override
  State<Colis> createState() => _ColisState();
}

class _ColisState extends State<Colis> {
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
  Map<String, dynamic>? selectedItems;
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
                                            selectedItems == colis[index]
                                                ? selectedItems = null
                                                : selectedItems = colis[index];
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
                                                color: selectedItems ==
                                                        colis[index]
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
                                          color: selectedItems == colis[index]
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
                                    labelText:
                                        language == 'fr' ? 'Date' : 'Date',
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.arrow_drop_down),
                                          )),
                                    ),
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
                          ? SizedBox(
                              height: 42.h,
                              width: 100.w,
                              child: ListView.builder(
                                shrinkWrap: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: chauffeurs.length,
                                itemBuilder: (context, index) {
                                  final chauffeur = chauffeurs[index];
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 1.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
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
                                              MainAxisAlignment.spaceBetween,
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
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 0.5.h),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            chauffeur['rate']
                                                                as String,
                                                            style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.star_border,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Text(
                                                            chauffeur['vehicle']
                                                                as String,
                                                            style: TextStyle(
                                                              fontSize: 15.sp,
                                                              color:
                                                                  Colors.grey,
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
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize: Size(30.w, 4.h),
                                                  elevation: 0,
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
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
                                                                  height: 20),
                                                              Text(
                                                                language == 'fr'
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
                                                                  height: 10),
                                                              Text(
                                                                language == 'fr'
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
                                                                  height: 20),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      setState(
                                                                          () {
                                                                        index =
                                                                            1;
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      language ==
                                                                              'fr'
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
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      setState(
                                                                          () {
                                                                        selectedChauffeur =
                                                                            chauffeur['id']
                                                                                as int;
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
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                            child:
                                                                                Container(
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
                                                                    child: Text(
                                                                      language ==
                                                                              'fr'
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
                                  onPressed: () {
                                    if (selectedItems == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(language == 'fr'
                                              ? 'Veuillez sélectionner un colis'
                                              : 'Please select a colis'),
                                          backgroundColor: kPrimaryColor,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      return;
                                    }
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        index++;
                                      });
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
}
