import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/models/history_model.dart';
import 'package:zomo/models/reservation.dart';
import 'package:zomo/screens/transporteur/navigation_screen.dart';
import 'package:zomo/services/reservationservices.dart';
import 'package:zomo/services/trajetservices.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/date_symbol_data_local.dart';

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({super.key});

  @override
  State<ActivityHistory> createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  // Example data
  int points = 15; // Replace with actual points
  int maxPoints = 500;
  double progress = 0;
  List<Map<String, dynamic>> historyData = [];
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr');
    points = transporteurData!.points!;
    progress = points / maxPoints;
    getReservations();
    getTrajets();
  }

  bool loading = true;
  List<TrajetModel> history = [];
  List<Reservation> reservations = [];
  List<dynamic> combinedHistory = [];

  Future<void> combineAndSortHistory() async {
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

    // Populate historyData after sorting
    setState(() {
      historyData = combinedHistory.map((data) {
        int points = data is TrajetModel ? 15 : 5;
        return {
          'id': data is TrajetModel ? data.id : data.id,
          'name': data is TrajetModel
              ? data.client!.username
              : data.client!.username,
          'etat': data is TrajetModel ? data.status : data.status,
          'date': data is TrajetModel
              ? data.departureDateTime
              : data.dateReservation,
          'desc': data is TrajetModel
              ? "Trajet : ${data.startPoint} -- ${data.endPoint} (${data.price}DT)"
              : data is Reservation
                  ? "Reservation : ${data.from} -- ${data.to}"
                  : '',
          'pts': '+$points pts',
        };
      }).toList();
    });
  }

  Future<void> getTrajets() async {
    try {
      final result =
          await TrajetServices.getTrajetsByTransporteur(transporteurData!.id!);

      if (result['success']) {
        setState(() {
          history = (result['data'] as List)
              .map((item) => TrajetModel.fromJson(item))
              .toList();
        });
        await combineAndSortHistory();
      }
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

    final result = await ReservationServices.getReservationsByTransporteur(
        transporteurData!.id!);

    if (result['success']) {
      setState(() {
        reservations = (result['data'] as List<Reservation>);
        combineAndSortHistory();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Align(
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
          title: Text(
            language == 'fr' ? 'Historique des activités' : 'Activity history',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  language == 'fr'
                      ? 'Historique des missions complétées'
                      : 'History of completed missions',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 2.h),
              SizedBox(height: 1.5.h),
              loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemCount: historyData.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1.5.h),
                        itemBuilder: (context, index) {
                          final item = historyData[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20.sp,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: AssetImage(
                                      'assets/person${Random().nextInt(4) + 1}.png'),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "7,8 KM, ${DateFormat('HH:mm').format(item['date'])}",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "${item['etat'] == "en_attente" ? language == 'fr' ? 'En attente' : 'En attente' : language == 'fr' ? 'Complétée' : 'Completed'} - Payé",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Text(
                                  DateFormat('dd MMMM, HH:mm', 'fr')
                                      .format((item['date'])),
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color:
                                        item['pts'].toString().startsWith('-')
                                            ? Colors.red
                                            : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
