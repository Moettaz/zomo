import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/models/notification_model.dart';

class SignalProblem extends StatefulWidget {
  const SignalProblem({super.key});

  @override
  State<SignalProblem> createState() => _SignalProblemState();
}

class _SignalProblemState extends State<SignalProblem> {
  bool empty = false;

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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      language == 'fr'
                          ? 'Signaler un problème'
                          : 'Report a problem',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: empty ? 20.h : 1.h),
                  empty
                      ? Center(child: _buildEmptyState())
                      : SizedBox(
                          height: 60.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Material(
                                    elevation: 4,
                                    borderRadius: BorderRadius.circular(20.sp),
                                    child: Padding(
                                      padding: EdgeInsets.all(20.sp),
                                      child: Text(
                                        language == 'fr'
                                            ? 'Signaler un problème Si vous rencontrez des problèmes pendant ou après un trajet ou une livraison, contactez notre équipe via le chat intégré dans l\'application Zomo. Notre service client est disponible 24 heures sur 24, 7 jours sur 7, et vous répondra dans les plus brefs délais.'
                                            : 'Report a problem If you encounter problems during or after a trip or delivery, contact our team via the chat integrated in the Zomo application. Our customer service is available 24 hours a day, 7 days a week, and will respond to you in the shortest possible time.',
                                        style: TextStyle(fontSize: 18.sp),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.sp, vertical: 2.h),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    fixedSize: Size(70.w, 6.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Text(
                                    language == 'fr'
                                        ? 'Ecrire un message'
                                        : 'Write a message',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                ],
              ).animate().slideX(duration: 500.ms, begin: -1, end: 0),
            ),
          ),
        )
      ],
    ));
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: kSecondaryColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: kSecondaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.notifications,
            size: 45.sp,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          language == 'fr' ? "Aucune notification !" : "No notification !",
          style: TextStyle(
            fontFamily: 'Sofia Pro',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          language == 'fr'
              ? "Aucune notification à vous pour le moment."
              : "No notification for you at the moment.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Sofia Pro',
            fontSize: 15.sp,
            height: 1.4,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  notificationItem(NotificationModel notification) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Material(
        elevation: 4,
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.sp),
          bottomRight: Radius.circular(20.sp),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(0.sp),
              ),
              child: Image.asset(
                'assets/miniLogo.png',
                width: 10.w,
                height: 10.w,
              ),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 1.h),
                SizedBox(
                    width: 70.w,
                    child: Text(notification.description,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis)),
                SizedBox(height: 1.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
