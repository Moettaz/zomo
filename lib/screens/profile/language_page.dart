import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
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
                  color: Colors.black.withOpacity(0.5),
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
                    Get.back();
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
                  RadioListTile(
                    title: Text('English'),
                    value: 'en',
                    groupValue: language,
                    onChanged: (value) {
                      setState(() {
                        language = value!;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('French'),
                    value: 'fr',
                    groupValue: language,
                    onChanged: (value) {
                      setState(() {
                        language = value!;
                      });
                    },
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
