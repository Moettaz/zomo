// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/models/history_model.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:zomo/models/reservation.dart';
import 'package:zomo/screens/transporteur/navigation_screen.dart';
import 'package:zomo/services/callhistory.dart';
import 'package:zomo/services/reservationservices.dart';
import 'package:zomo/services/trajetservices.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  bool loading = true;
  List<TrajetModel> history = [];
  List<Reservation> reservations = [];
  List<dynamic> combinedHistory = [];

  @override
  void initState() {
    super.initState();
    getReservations();
    getTrajets();
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
    }
  }

  void combineAndSortHistory() {
    combinedHistory = [...history, ...reservations];
    combinedHistory.sort((a, b) {
      DateTime dateA;
      DateTime dateB;

      if (a is TrajetModel) {
        dateA = a.departureDateTime;
      } else {
        dateA = DateTime.parse(a.dateReservation);
      }

      if (b is TrajetModel) {
        dateB = b.departureDateTime;
      } else {
        dateB = DateTime.parse(b.dateReservation);
      }

      return dateB.compareTo(dateA); // Sort in descending order (newest first)
    });
    setState(() {});
  }

  Future<void> getTrajets() async {
    try {
      setState(() {
        loading = true;
      });
      final result =
          await TrajetServices.getTrajetsByTransporteur(transporteurData!.id!);

      if (result['success']) {
        setState(() {
          history = (result['data'] as List)
              .map((item) => TrajetModel.fromJson(item))
              .toList();
          combineAndSortHistory();
        });
      } else {}
    } catch (e) {
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> getReservations() async {
    try {
      setState(() {
        loading = true;
      });
      final result = await ReservationServices.getReservationsByTransporteur(
          transporteurData!.id!);

      if (result['success']) {
        setState(() {
          reservations = result['data'] as List<Reservation>;
          combineAndSortHistory();
        });
      } else {}
    } catch (e) {
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> updateReservation({
    required int reservationId,
    required String status,
  }) async {
    try {
      setState(() {
        uploading = true;
      });
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
      setState(() {
        uploading = false;
      });
    }
  }

  Future<void> refresh() async {
    await getReservations();
    await getTrajets();
  }

  bool uploading = false;
  Future<bool> updateTrajet({
    required int trajetId,
    required String status,
  }) async {
    try {
      setState(() {
        uploading = true;
      });
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
      setState(() {
        uploading = false;
      });
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
              child: RefreshIndicator(
                onRefresh: refresh,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.h),
                    InkWell(
                      onTap: () => setState(() {
                        empty = !empty;
                      }),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text(
                          language == 'fr' ? 'Missions' : 'Missions',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: empty ? 20.h : 0.h),
                    loading
                        ? Center(child: CircularProgressIndicator())
                        : combinedHistory.isEmpty
                            ? Center(child: _buildEmptyState())
                            : SizedBox(
                                height: 70.h,
                                child: ListView.builder(
                                  itemCount: combinedHistory.length,
                                  itemBuilder: (context, index) {
                                    return missionItem(combinedHistory[index]);
                                  },
                                ),
                              )
                  ],
                ).animate().slideX(duration: 500.ms, begin: -1, end: 0),
              ),
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
                color: kSecondaryColor.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.access_time_rounded,
            size: 45.sp,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          language == 'fr' ? "Aucune mission !" : "No mission !",
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
              ? "Aucune mission à vous pour le moment."
              : "No mission for you at the moment.",
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

  Widget missionItem(dynamic mission) {
    // Determine if it's a TrajetModel or Reservation
    final bool isTrajet = mission is TrajetModel;
    final String status = isTrajet ? mission.status : mission.status;
    final String username = isTrajet
        ? mission.client?.username ?? ''
        : mission.client?.username ?? '';
    final DateTime date = isTrajet
        ? mission.departureDateTime
        : DateTime.parse(mission.dateReservation);
    final String from = isTrajet ? mission.startPoint : mission.from;
    final String to = isTrajet ? mission.endPoint : mission.to;
    final int itemsCount = isTrajet ? 0 : (mission.products?.length ?? 0);
    final String phoneNumber = "+216${mission.client?.phone}";
    final int clientId = mission.client?.id ?? 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
      child: Material(
        elevation: 0,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  status == 'en_attente'
                      ? language == 'fr'
                          ? 'En attente'
                          : 'Pending'
                      : status == 'accepted'
                          ? language == 'fr'
                              ? 'Acceptées'
                              : 'Accepted'
                          : status == 'refuse'
                              ? language == 'fr'
                                  ? 'Refusées'
                                  : 'Refused'
                              : language == 'fr'
                                  ? 'Terminée'
                                  : 'Completed',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: status == 'en_attente'
                        ? Colors.orange
                        : status == 'accepted'
                            ? Colors.green
                            : Colors.red,
                  )),
              SizedBox(height: 1.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(username,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 2.w),
                        Text(
                            DateTime.now().day == date.day &&
                                    DateTime.now().month == date.month &&
                                    DateTime.now().year == date.year
                                ? language == 'fr'
                                    ? 'Aujourd\'hui'
                                    : 'Today'
                                : DateFormat('EEEE, HH:mm').format(date),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: [
                        SizedBox(
                            width: 70.w,
                            child: Text(from,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis)),
                        SizedBox(
                            width: 70.w,
                            child: Text(to,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis)),
                        if (!isTrajet && itemsCount > 0)
                          SizedBox(
                              width: 70.w,
                              child: Text(
                                  '$itemsCount ${language == 'fr'
                                          ? 'articles'
                                          : 'articles'}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  if (status == 'en_attente' || status == 'accepted')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(40.w, 5.h),
                              elevation: 0,
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () async {
                              if (status == 'en_attente') {
                                final bool result;
                                if (isTrajet) {
                                  result = await updateTrajet(
                                    trajetId: mission.id,
                                    status: 'accepted',
                                  );
                                } else {
                                  result = await updateReservation(
                                    reservationId: mission.id,
                                    status: 'accepted',
                                  );
                                }

                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
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
                                                  result
                                                      ? Icons
                                                          .attach_money_outlined
                                                      : Icons.error_outline,
                                                  color: result
                                                      ? kPrimaryColor
                                                      : Colors.red,
                                                  size: 40.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              result
                                                  ? language == 'fr'
                                                      ? 'Vous avez gagné 15 points'
                                                      : 'You have won 15 points'
                                                  : language == 'fr'
                                                      ? 'Une erreur est survenue'
                                                      : 'An error occurred',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16.sp),
                                            ),
                                            SizedBox(height: 1.h),
                                            Divider(
                                              color: kPrimaryColor,
                                            ),
                                            SizedBox(height: 1.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    await refresh();
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    result
                                                        ? language == 'fr'
                                                            ? 'Génial'
                                                            : 'Great'
                                                        : language == 'fr'
                                                            ? 'Ok'
                                                            : 'Ok',
                                                    style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontSize: 17.sp,
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
                              } else {
                                //call the client
                                callClient(phoneNumber, clientId);
                              }
                            },
                            child: uploading
                                ? Center(
                                    child: CircularProgressIndicator(
                                        color: kPrimaryColor))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (status == 'accepted')
                                        Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        status == 'en_attente'
                                            ? language == 'fr'
                                                ? 'Accepter'
                                                : 'Accept'
                                            : language == 'fr'
                                                ? 'Appeler'
                                                : 'Call',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(40.w, 5.h),
                              elevation: 0,
                              backgroundColor:
                                  kSecondaryColor.withValues(alpha: 0.2),
                              foregroundColor: kSecondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () async {
                              if (status == 'en_attente') {
                                final bool result;
                                if (isTrajet) {
                                  result = await updateTrajet(
                                    trajetId: mission.id,
                                    status: 'refuse',
                                  );
                                } else {
                                  result = await updateReservation(
                                    reservationId: mission.id,
                                    status: 'refuse',
                                  );
                                }
                                if (result) {
                                  await refresh();
                                  Get.showSnackbar(
                                    GetSnackBar(
                                      title: 'Mission refusée',
                                      message: 'La mission a été refusée',
                                      backgroundColor: kPrimaryColor,
                                    ),
                                  );
                                }
                              } else {
                                //navigate to the client
                                Get.offAll(
                                    () => NavigationScreenTransporteur());
                              }
                            },
                            child: uploading
                                ? Center(
                                    child: CircularProgressIndicator(
                                        color: kPrimaryColor))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (status == 'accepted')
                                        Icon(
                                          Icons.place,
                                          color: kSecondaryColor,
                                          size: 20.sp,
                                        ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        status == 'en_attente'
                                            ? language == 'fr'
                                                ? 'Réfuser'
                                                : 'Refuse'
                                            : language == 'fr'
                                                ? 'Navigation'
                                                : 'Navigation',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                      ],
                    ),
                  SizedBox(height: 1.h),
                  if (status == 'accepted')
                    SizedBox(
                      width: 100.w,
                      child: TextButton(
                          onPressed: () async {
                            final bool result;
                            if (isTrajet) {
                              result = await updateTrajet(
                                trajetId: mission.id,
                                status: 'completed',
                              );
                            } else {
                              result = await updateReservation(
                                reservationId: mission.id,
                                status: 'completed',
                              );
                            }
                            if (result) {
                              await refresh();
                              Get.showSnackbar(
                                GetSnackBar(
                                  title: 'Mission terminée',
                                  message: 'La mission a été terminée',
                                  backgroundColor: kPrimaryColor,
                                ),
                              );
                            }
                          },
                          child: uploading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: kPrimaryColor))
                              : Text(
                                  language == 'fr'
                                      ? 'MARQUER COMME LIVREE'
                                      : 'MARK AS DELIVERED',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                )),
                    )
                ],
              ),
              Divider(
                color: Colors.grey,
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
