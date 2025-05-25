// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/models/paiement_model.dart';
import 'package:zomo/screens/transporteur/navigation_screen.dart';
import 'package:zomo/services/paiementservice.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MyPointsTransporteurPage extends StatefulWidget {
  const MyPointsTransporteurPage({super.key});

  @override
  State<MyPointsTransporteurPage> createState() =>
      _MyPointsTransporteurPageState();
}

class _MyPointsTransporteurPageState extends State<MyPointsTransporteurPage> {
  // Example data
  int points = 15; // Replace with actual points
  int maxPoints = 500;
  double progress = 0;
  List<Payment> payments = [];
  Future<void> getPoints() async {
    final result = await PaymentService()
        .getPaymentsByTransporteurId(transporteurData!.id!);
    setState(() {
      payments = result;
      points =
          payments.fold(0, (sum, payment) => sum + payment.montant.toInt());
      progress = points / maxPoints;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr');
    getPoints();
  }

  bool loading = true;

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
            language == 'fr' ? 'Paiements' : 'Payments',
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
              Text(language == 'fr' ? 'Solde actuel' : 'Current balance',
                  style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 5.h),

              // Progress bar

              Center(
                child: Text(language == 'fr' ? '$points TND' : '$points TND',
                    style: TextStyle(
                        fontSize: 25.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 5.h),

              Divider(),
              Text(
                  language == 'fr'
                      ? 'Historique des paiements'
                      : 'History of payments',
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
                        itemCount: payments.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1.5.h),
                        itemBuilder: (context, index) {
                          final item = payments[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 4.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('EEEE, dd MMMM yyyy', 'fr')
                                          .format(item.datePaiement)
                                          .capitalizeFirst!,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "${item.service.nom} - ${item.reference}",
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      item.client.username,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${item.montant.toString()} TND",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color:
                                        item.montant.toString().startsWith('-')
                                            ? Colors.red
                                            : Colors.black,
                                    fontWeight: FontWeight.w600,
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
