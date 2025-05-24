import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zomo/design/const.dart';
import 'screens/first_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void showInAppNotification(String title, String body) {
  Get.snackbar(
    title,
    '',
    backgroundColor: Colors.white,
    colorText: kPrimaryColor,
    duration: Duration(seconds: 5),
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(15),
    borderRadius: 10,
    snackPosition: SnackPosition.TOP,
    animationDuration: const Duration(milliseconds: 500),
    messageText: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...body.split('\n').map((line) => Text(
              line,
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
            )),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                fixedSize: Size(30.w, 5.h),
              ),
              onPressed: () {
                Get.back();
              },
              child: Text(language == 'fr' ? 'Accepter' : 'Accept'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: kSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                fixedSize: Size(30.w, 5.h),
              ),
              onPressed: () {
                Get.back();
              },
              child: Text(language == 'fr' ? 'Refuser' : 'Refuse'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: kSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                fixedSize: Size(10.w, 5.h),
              ),
              onPressed: () {
                // You can implement actual call logic here if needed
                Get.back();
              },
              child: Icon(
                Icons.call_outlined,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permissions

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // Show in-app notification
      showInAppNotification(
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? '',
      );
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            surface: Colors.white,
            seedColor: Color.fromRGBO(253, 186, 27, 1),
          ),
        ),
        home: const FirstPage(),
      );
    });
  }
}
