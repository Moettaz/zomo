import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/models/history_model.dart';
import 'package:zomo/models/reservation.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
import 'package:zomo/services/reservationservices.dart';
import 'package:zomo/services/trajetservices.dart';

class Historypage extends StatefulWidget {
  const Historypage({super.key});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  bool loading = false;
  List<TrajetModel> history = [];
  List<Reservation> reservations = [];
  List<dynamic> combinedHistory = [];

  @override
  void initState() {
    super.initState();
    getTrajets();
    getReservations();
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
      final result = await TrajetServices.getTrajetsByClient(clientData!.id!);

      if (result['success']) {
        setState(() {
          history = (result['data'] as List)
              .map((item) => TrajetModel.fromJson(item))
              .toList();
          combineAndSortHistory();
        });
      } else {}
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching history: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> getReservations() async {
    // try {
    setState(() {
      loading = true;
    });
    final result =
        await ReservationServices.getReservationsByClient(clientData!.id!);

    if (result['success']) {
      setState(() {
        reservations = (result['data'] as List<Reservation>);
        combineAndSortHistory();
      });
    } else {}
    // } catch (e) {
    //   print('Error fetching reservations: $e');
    // } finally {
    //   setState(() {
    //     loading = false;
    //   });
    // }
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
                      language == 'fr' ? 'Historique' : 'History',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          history.isEmpty && reservations.isEmpty ? 20.h : 1.h),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
                        )
                      : history.isEmpty && reservations.isEmpty
                          ? Center(child: _buildEmptyState())
                          : SizedBox(
                              height: 70.h,
                              child: ListView.builder(
                                itemCount: combinedHistory.length,
                                itemBuilder: (context, index) {
                                  final item = combinedHistory[index];
                                  if (item is TrajetModel) {
                                    return trajetItem(item);
                                  } else {
                                    return reservationItem(item as Reservation);
                                  }
                                },
                              ),
                            )
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
          language == 'fr' ? "Aucun historique !" : "No history !",
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
              ? "Faire des trajets pour les voir ici."
              : "Make trips to see them here.",
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

  trajetItem(TrajetModel history) {
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
              child: Icon(
                Icons.access_time_rounded,
                size: 30.sp,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(history.startPoint,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 1.h),
                  Text(history.endPoint),
                  SizedBox(height: 1.h),
                  Text(
                      '${history.departureDateTime.toString().substring(0, 16)}\n${history.arrivalDateTime.toString().substring(0, 16)}'),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        language == 'fr' ? 'Chauffeur ' : 'Transporteur ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        history.transporteur!.username.capitalizeFirst!
                            .replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                      language == 'fr'
                          ? "${history.price.toString()} TND"
                          : "${history.price.toString()} DT",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(history.status.capitalizeFirst!.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: history.status == 'accepted'
                            ? Colors.green
                            : history.status == 'rejected'
                                ? Colors.red
                                : kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 12.h),
                  Text(language == 'fr' ? "+ 15 points" : "+ 15 points",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  reservationItem(Reservation reservation) {
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
              child: Icon(
                Icons.access_time_rounded,
                size: 30.sp,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reservation.from,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 1.h),
                  Text(reservation.to),
                  SizedBox(height: 1.h),
                  Text(
                      '${reservation.dateReservation.toString().substring(0, 16)}\n${reservation.heureReservation != null ? reservation.heureReservation!.toString().length > 16 ? reservation.heureReservation!.toString().substring(0, 16) : reservation.heureReservation!.toString() : ''}'),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        language == 'fr' ? 'Chauffeur ' : 'Transporteur ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        reservation.transporteur!.username.capitalizeFirst!
                            .replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                      language == 'fr'
                          ? reservation.serviceId == 2
                              ? "Etage ${reservation.etage.toString()}"
                              : "Taille ${reservation.colisSize}"
                          : reservation.serviceId == 2
                              ? "Etage ${reservation.etage.toString()}"
                              : "Taille ${reservation.colisSize}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(reservation.status.capitalizeFirst!.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: reservation.status == 'accepted'
                            ? Colors.green
                            : reservation.status == 'rejected'
                                ? Colors.red
                                : kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 12.h),
                  Text(language == 'fr' ? "+ 5 points" : "+ 5 points",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
