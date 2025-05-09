import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/models/history_model.dart';

class Historypage extends StatefulWidget {
  const Historypage({super.key});

  @override
  State<Historypage> createState() => _HistorypageState();
}

class _HistorypageState extends State<Historypage> {
  bool empty = false;
  List<HistoryModel> history = [
    HistoryModel(
      isTransporteur: true,
      title: 'Livraison 8kg',
      demandeId: 'Demande #002',
      date: '20 avril 2025',
      time: '15:20',
      transporteur: 'Aziz',
      emplacement: 'Tunis, Bab Saadoun - Alger, El Harrach',
      point: '10',
      status: 'En cours',
      amount: 90,
    ),
    HistoryModel(
      isTransporteur: false,
      title: 'Trajet VTC',
      demandeId: 'Demande #001',
      date: '18 avril 2025',
      time: '11:00',
      transporteur: 'Chiheb',
      emplacement: 'Tunis, Bab Saadoun - Alger, El Harrach',
      point: '10',
      status: 'En cours',
      amount: 90,
    ),
  ];
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
                  InkWell(
                    onTap: () => setState(() {
                      empty = !empty;
                    }),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        language == 'fr' ? 'Historique' : 'History',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: empty ? 20.h : 1.h),
                  empty
                      ? Center(child: _buildEmptyState())
                      : SizedBox(
                          height: 70.h,
                          child: ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              return historyItem(history[index]);
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
                color: kSecondaryColor.withOpacity(0.1),
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

  historyItem(HistoryModel history) {
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
                  Text(history.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 1.h),
                  Text(history.demandeId),
                  SizedBox(height: 1.h),
                  Text('${history.date} ${history.time}'),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        language == 'fr'
                            ? '${history.isTransporteur ? 'Transporteur' : 'Chauffeur'} : '
                            : '${history.isTransporteur ? 'Driver' : 'Transporteur'} : ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        history.transporteur,
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
                          ? "${history.amount.toString()} TND"
                          : "${history.amount.toString()} DT",
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
                  Text(history.status,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 12.h),
                  Text(
                      language == 'fr'
                          ? "+ ${history.point} Pts"
                          : "+ ${history.point} Points",
                      style: TextStyle(
                        fontSize: 14.sp,
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
