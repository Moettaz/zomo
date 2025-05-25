import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/screens/transporteur/navigation_screen.dart';
import 'package:zomo/services/callhistory.dart';
import 'package:zomo/services/reservationservices.dart';
import 'package:zomo/services/trajetservices.dart';
import 'screens/first_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<bool> updateReservation({
  required int reservationId,
  required String status,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    final response = await ReservationServices.updateReservation(
      reservationId: reservationId,
      status: status,
    );

    return response['success'];
  } catch (e) {
    return false;
  } finally {
    Get.showSnackbar(GetSnackBar(
      message: 'Reservation modifiée avec succès !',
      backgroundColor: kPrimaryColor,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 500),
    ));
  }
}

Future<bool> storeCall(int senderId, int receiverId) async {
  final callHistoryService = CallHistoryService();

// Store a call history
  try {
    final result = await callHistoryService.storeCallHistory(
      senderId: senderId,
      receiverId: receiverId,
      etat: 'received',
      duration: 120, // optional
    );
    return result;
  } catch (e) {
    return false;
  } finally {
    Get.showSnackbar(GetSnackBar(
      message: 'Appel enregistré avec succès !',
      backgroundColor: kPrimaryColor,
       duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 500),    ));
  }
}

bool uploading = false;
Future<bool> updateTrajet({
  required int trajetId,
  required String status,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    final response = await TrajetServices.updateTrajet(
      id: trajetId,
      etat: status,
    );

    return response['success'];
  } catch (e) {
    return false;
  } finally {
    Get.showSnackbar(GetSnackBar(
      message: 'Trajet modifié avec succès !',
      backgroundColor: kPrimaryColor,
        duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 500),
    ));
  }
}

Future<void> callClient(String phoneNumber, int clientId) async {
  try {
    await storeCall(transporteurData!.id!, clientId);
    final Uri uri = Uri.parse('tel:$phoneNumber');
    await launchUrl(uri);
  } catch (e) {
    // ignore: avoid_print
    print('Error calling client: $e');
  }
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
        title.contains('Nouveau') || title.contains('Nouvelle')
            ? Row(
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
                    onPressed: () async {
                      if (title.contains('Nouvelle')) {
                        await updateReservation(
                            reservationId: 1, status: 'accepted');
                      } else {
                        await updateTrajet(trajetId: 1, status: 'accepted');
                      }
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
                    onPressed: () async {
                      if (title.contains('Nouvelle')) {
                        await updateReservation(
                            reservationId: 1, status: 'rejected');
                      } else {
                        await updateTrajet(trajetId: 1, status: 'rejected');
                      }
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
                    onPressed: () async {
                      await callClient("+216 97 444 444", 1);
                      // You can implement actual call logic here if needed
                      Get.back();
                    },
                    child: Icon(
                      Icons.call_outlined,
                      size: 20,
                    ),
                  ),
                ],
              )
            : Container(),
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
