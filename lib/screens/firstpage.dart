import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
            child: Image.asset(
              'assets/background.png',
              width: 100.w,
              height: 100.h,
            ),
          ),
          // Background image at top left
          Positioned(
            top: 1.h,
            left: 1.w,
            child: Image.asset(
              'assets/background1.png',
              width: 30.w,
              height: 30.h,
            ),
          ),

          // Center content (logo and text)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo in center
                Image.asset(
                  'assets/ZOMO-LOGO 5.png',
                  width: 80.w,
                  height: 20.h,
                ),
                SizedBox(height: 2.h),
                // Text under logo
                Text(
                  'Zomo, l’application qui réunit tous vos trajets et services.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Bottom icon button
          Align(
            alignment: Alignment.bottomCenter,
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_up_sharp,
                  color: Colors.white,
                  size: 30.sp,
                ),
                onPressed: () {
                  // Navigate to next screen
                  // You can add navigation code here
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
