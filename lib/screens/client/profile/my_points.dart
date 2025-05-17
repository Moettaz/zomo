import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/models/history_model.dart';
import 'package:zomo/models/reservation.dart';
import 'package:zomo/screens/client/navigation_screen.dart';
import 'package:zomo/services/reservationservices.dart';
import 'package:zomo/services/trajetservices.dart';

class MyPointsPage extends StatefulWidget {
  const MyPointsPage({super.key});

  @override
  State<MyPointsPage> createState() => _MyPointsPageState();
}

class _MyPointsPageState extends State<MyPointsPage> {
  // Example data
  int points = 15; // Replace with actual points
  int maxPoints = 500;
  double progress = 0;
  List<Map<String, dynamic>> historyData = [];
  @override
  void initState() {
    super.initState();
    points = clientData!.points!;
    progress = points / maxPoints;
    getReservations();
    getTrajets();
    setState(() {
      for (var data in combinedHistory) {
        int points = data is TrajetModel ? 15 : 5;
        historyData.add({
          'desc': data is TrajetModel
              ? "Trajet : ${data.startPoint} -- ${data.endPoint} (${data.price}DT)"
              : data is Reservation
                  ? "Reservation : ${data.from} -- ${data.to}"
                  : '',
          'pts': '+$points pts',
        });
      }
      loading = false;
    });
  }

  bool loading = true;
  List<TrajetModel> history = [];
  List<Reservation> reservations = [];
  List<dynamic> combinedHistory = [];

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
  }

  Future<void> getTrajets() async {
    try {
      final result = await TrajetServices.getTrajetsByClient(clientData!.id!);

      if (result['success']) {
        setState(() {
          history = (result['data'] as List)
              .map((item) => TrajetModel.fromJson(item))
              .toList();
          combineAndSortHistory();
        });
      } else {
        print('Failed to fetch history: ${result['message']}');
      }
    } catch (e) {
      print('Error fetching history: $e');
    } finally {}
  }

  Future<void> getReservations() async {
    // try {

    final result =
        await ReservationServices.getReservationsByClient(clientData!.id!);

    if (result['success']) {
      setState(() {
        reservations = (result['data'] as List<Reservation>);
        combineAndSortHistory();
      });
    } else {
      print('Failed to fetch reservations: ${result['message']}');
    }
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
            language == 'fr' ? 'Système de points' : 'Points system',
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
              Text(language == 'fr' ? 'Mes points' : 'My points',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      padding: EdgeInsets.all(10.sp),
                      child: Image.asset("assets/dollar-circle.png")),
                  SizedBox(width: 3.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          language == 'fr'
                              ? 'Vous avez: $points points'
                              : 'You have: $points points',
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: kSecondaryColor)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              // Progress bar
              Stack(
                children: [
                  Container(
                    height: 1.5.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                  Container(
                    height: 1.5.h,
                    width: MediaQuery.of(context).size.width * progress * 0.85,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                  language == 'fr'
                      ? '$points/$maxPoints points'
                      : '$points/$maxPoints points',
                  style: TextStyle(fontSize: 15.sp, color: kSecondaryColor)),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.sp),
                      ),
                      child: Text(
                          language == 'fr'
                              ? 'Transformer mes points'
                              : 'Transform my points',
                          style: TextStyle(
                            fontSize: 15.sp,
                          )),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.sp),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.sp),
                      ),
                      child: Text(
                          language == 'fr'
                              ? 'Utiliser mes points'
                              : 'Use my points',
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Divider(),
              Text(
                  language == 'fr'
                      ? 'Historique des gains'
                      : 'History of gains',
                  style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
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
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['desc'],
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      color: kSecondaryColor,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                item['pts'],
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: item['pts'].toString().startsWith('-')
                                      ? Colors.red
                                      : kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
