import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/models/client.dart';
import 'package:zomo/screens/auth/signin.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
import 'package:zomo/services/authserices.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      final response = await AuthServices.getCurrentUser();
      if (response != null) {
        setState(() {
          if (response['specific_data'] != null) {
            if (response['specific_data'] is Client) {
              clientData = response['specific_data'];
            } else {
              clientData = Client.fromJson(response['specific_data']);
            }
          }
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Image.asset(
                  'assets/background.jpeg',
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 100.w,
                  height: 100.h,
                  color: Colors.black.withValues(alpha: 0.2),
                ),
              ],
            ),
          ),
          // Background image at top left
          Positioned(
            top: 1.h,
            left: 1.w,
            child: Image.asset(
              'assets/background1.png',
              width: 70.w,
              height: 60.h,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 5.h, right: 1.w),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    language == 'fr' ? language = 'en' : language = 'fr';
                  });
                },
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(language == 'fr' ? 'FR' : 'EN',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    Icon(
                      Icons.language_outlined,
                      color: kPrimaryColor,
                      size: 25.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Center content (logo and text)
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Logo in center
                Image.asset(
                  'assets/ZOMO-LOGO 5.png',
                  width: 80.w,
                  height: 20.h,
                ),
                SizedBox(height: 2.h),
                // Text under logo
                SizedBox(
                  width: 80.w,
                  child: Text(
                    language == 'fr'
                        ? 'Zomo, l’application qui réunit tous vos trajets et services.'
                        : 'Zomo, the application that brings together all your trips and services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_up_sharp,
                          color: kPrimaryColor,
                          size: 30.sp,
                        ),
                        onPressed: () {
                          Get.to(() => const SignInScreen(),
                              transition: Transition.downToUp,
                              duration: const Duration(milliseconds: 500));
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom icon button
        ],
      ),
    );
  }
}
