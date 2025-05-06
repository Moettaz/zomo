import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';

class MyPointsPage extends StatelessWidget {
  const MyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data
    int points = 25; // Replace with actual points
    int maxPoints = 500;
    double progress = points / maxPoints;
    List<Map<String, dynamic>> history = [
      {'desc': 'Trajet Manouba -- Lac 2 (15DT)', 'pts': '+15 pts'},
      {'desc': 'Livraison colis num 14', 'pts': '+5 pts'},
      {'desc': 'Trajet gratuit utilisé', 'pts': '-500 pts'},
      {'desc': 'Livraison colis num 13', 'pts': '+5 pts'},
      {'desc': 'Livraison colis num 12', 'pts': '+5 pts'},
    ];

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
                        color: kPrimaryColor.withOpacity(0.1),
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
                  language == 'fr' ? '$points/$maxPoints points' : '$points/$maxPoints points',
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
              Expanded(
                child: ListView.separated(
                  itemCount: history.length,
                  separatorBuilder: (context, index) => Divider(height: 1.5.h),
                  itemBuilder: (context, index) {
                    final item = history[index];
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
