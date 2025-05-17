import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/screens/client/colis/colis.dart';
import 'package:zomo/screens/client/course/select_car.dart';
import 'package:zomo/screens/client/demenagement/reservation.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
import 'package:zomo/services/transporteurservices.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  int carouselIndex = 0;
  @override
  void initState() {
    super.initState();
    if (showwDialog != null && showwDialog == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRatingModal();
      });
    }
    setState(() {
      showwDialog = false;
    });
  }

  void _showRatingModal() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        double rating = 4.0;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(
                            '${TransporteurServices.baseUrl}/storage/${rateTransporteur!.imageUrl}'), // Replace with your asset
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rateTransporteur!.username,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          Text(rateTransporteur!.vehiculeType.toString(),
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Comment évalues-tu ton expérience ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 24),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: kPrimaryColor,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await TransporteurServices.updateTransporteur(
                        rateTransporteur!.id!,
                        {
                          'note_moyenne':
                              (rateTransporteur!.noteMoyenne! + rating) / 2,
                        },
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // Handle rating submission here
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(60.w, 7.h),
                      elevation: 0,
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(language == 'fr' ? 'Valider' : 'Validate'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
              // Back Button
              selectedIndex == 0
                  ? Container()
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (selectedIndex == 0) {
                            return;
                          } else if (selectedIndex == 1) {
                            setState(() {
                              selectedIndex = 0;
                            });
                          } else if (selectedIndex == 3 || selectedIndex == 6) {
                            setState(() {
                              selectedIndex = 0;
                            });
                          } else {
                            setState(() {
                              selectedIndex = selectedIndex - 1;
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 5.h),
                  // Top buttons
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                    color: selectedIndex == 0
                                        ? kPrimaryColor
                                        : Colors.grey),
                              ),
                            ),
                            child: Text(
                              language == 'fr' ? 'Course' : 'Course',
                              style: TextStyle(
                                  color: selectedIndex == 0
                                      ? kPrimaryColor
                                      : Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                    color: selectedIndex == 1
                                        ? kPrimaryColor
                                        : Colors.grey),
                              ),
                            ),
                            child: Text(
                              language == 'fr' ? 'Déménagement' : 'Demovation',
                              maxLines: 1,
                              style: TextStyle(
                                  color: selectedIndex == 1
                                      ? kPrimaryColor
                                      : Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex = 2;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                    color: selectedIndex == 2
                                        ? kPrimaryColor
                                        : Colors.grey),
                              ),
                            ),
                            child: Text(
                              language == 'fr' ? 'Colis' : 'Colis',
                              style: TextStyle(
                                color: selectedIndex == 2
                                    ? kPrimaryColor
                                    : Colors.black,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  // course Section
                  selectedIndex == 0
                      ? Column(
                          children: [
                            Material(
                              elevation: 4,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.sp),
                              child: Column(
                                children: [
                                  SizedBox(height: 2.h),
                                  Text(
                                    language == 'fr' ? 'Course' : 'Course',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/car.png',
                                    width: 80.w,
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.sp),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => SelectCar(),
                                      transition: Transition.downToUp,
                                      duration: Duration(milliseconds: 500));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  fixedSize: Size(70.w, 6.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  language == 'fr' ? 'Réserver' : 'Book',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 5.h,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1,
                                autoPlayInterval: Duration(seconds: 3),
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    carouselIndex = index;
                                  });
                                },
                              ),
                              items: [
                                Text(language == 'fr'
                                    ? "Réservez un taxi en un clic avec Zomo."
                                    : "Book a taxi in one click with Zomo."),
                                Text(language == 'fr'
                                    ? "Chauffeurs vérifiés et tarifs transparents."
                                    : "Drivers verified and transparent prices."),
                                Text(language == 'fr'
                                    ? "Voyagez partout, à tout moment."
                                    : "Travel everywhere, anytime."),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            DotsIndicator(
                              dotsCount: 3,
                              position: carouselIndex.toDouble(),
                              decorator: DotsDecorator(
                                activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.sp)),
                                activeSize: Size(10.w, 1.h),
                                size: Size(10.w, 1.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.sp)),
                                color: Colors.grey[200]!,
                                activeColor: kPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ).animate().slideX(duration: 500.ms, begin: -1, end: 0)
                      // déménagement Section
                      : selectedIndex == 1
                          ? Column(
                              children: [
                                Material(
                                  elevation: 4,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.sp),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Déménagement',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/camion.png',
                                        width: 80.w,
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.sp),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => Reservation());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      fixedSize: Size(70.w, 6.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Text(
                                      language == 'fr' ? 'Réserver' : 'Book',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 5.h,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1,
                                    autoPlayInterval: Duration(seconds: 3),
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        carouselIndex = index;
                                      });
                                    },
                                  ),
                                  items: [
                                    Text(language == 'fr'
                                        ? "Déménagez sans stress avec notre application."
                                        : "Move without stress with our application."),
                                    Text(language == 'fr'
                                        ? "Réservation rapide et équipes pro."
                                        : "Quick booking and professional teams."),
                                    Text(language == 'fr'
                                        ? "Suivi en temps réel, 7j/7."
                                        : "Real-time tracking, 7/7."),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                DotsIndicator(
                                  dotsCount: 3,
                                  position: carouselIndex.toDouble(),
                                  decorator: DotsDecorator(
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.sp)),
                                    activeSize: Size(10.w, 1.h),
                                    size: Size(10.w, 1.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.sp)),
                                    color: Colors.grey[200]!,
                                    activeColor: kPrimaryColor,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                              ],
                            )
                              .animate()
                              .slideX(duration: 500.ms, begin: -1, end: 0)
                          // colis Section
                          : Column(
                              children: [
                                Material(
                                  elevation: 4,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.sp),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Colis',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/colis.png',
                                        width: 80.w,
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.sp),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => Colis());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      fixedSize: Size(70.w, 6.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: Text(
                                      language == 'fr' ? 'Réserver' : 'Book',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 5.h,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1,
                                    autoPlayInterval: Duration(seconds: 3),
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        carouselIndex = index;
                                      });
                                    },
                                  ),
                                  items: [
                                    Text(language == 'fr'
                                        ? "Expédiez vos colis facilement et en toute sécurité."
                                        : "Ship your packages easily and securely."),
                                    Text(language == 'fr'
                                        ? "Suivi en temps réel et tarifs transparents."
                                        : "Real-time tracking and transparent prices."),
                                    Text(language == 'fr'
                                        ? "Disponible 7j/7, pour tous vos envois, près ou loin."
                                        : "Available 7/7, for all your shipments, near or far."),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                DotsIndicator(
                                  dotsCount: 3,
                                  position: carouselIndex.toDouble(),
                                  decorator: DotsDecorator(
                                    activeShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.sp)),
                                    activeSize: Size(10.w, 1.h),
                                    size: Size(10.w, 1.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.sp)),
                                    color: Colors.grey[200]!,
                                    activeColor: kPrimaryColor,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                              ],
                            )
                              .animate()
                              .slideX(duration: 500.ms, begin: -1, end: 0)
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
