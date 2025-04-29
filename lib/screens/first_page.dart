import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/screens/auth/signin.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

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
                  color: Colors.black.withOpacity(0.2),
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
                    'Zomo, l’application qui réunit tous vos trajets et services.',
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
