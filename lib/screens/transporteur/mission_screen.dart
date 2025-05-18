import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zomo/models/client.dart';
import 'package:zomo/models/mission_model.dart';
import 'package:intl/intl.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  bool empty = false;
  List<MissionModel> missions = [
    MissionModel(
      id: '1',
      client: Client(
        id: 1,
        userId: 1,
        username: 'John Doe',
        email: 'john.doe@example.com',
        phone: '1234567890',
        imageUrl: 'assets/miniLogo.png',
      ),
      from: 'Sfax, Tunisia',
      to: 'Danden, Tunisia',
      date: DateTime.parse('2021-01-01'),
      time: '10:00',
      status: 'pending',
      items: [
        MissionItem(
          id: '1',
          name: 'Article 1',
          quantity: 1,
        ),
        MissionItem(
          id: '2',
          name: 'Article 2',
          quantity: 2,
        ),
      ],
    ),
    MissionModel(
      id: '2',
      client: Client(
        id: 2,
        userId: 2,
        username: 'Jane Doe',
        email: 'jane.doe@example.com',
        phone: '1234567890',
        imageUrl: 'assets/miniLogo.png',
      ),
      from: 'Danden, Tunisia',
      to: 'Sfax, Tunisia',
      date: DateTime.parse('2021-01-01'),
      time: '10:00',
      status: 'accepted',
      items: [
        MissionItem(
          id: '1',
          name: 'Article 1',
          quantity: 1,
        ),
      ],
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
                  empty
                      ? Center(child: _buildEmptyState())
                      : SizedBox(
                          height: 70.h,
                          child: ListView.builder(
                            itemCount: missions.length,
                            itemBuilder: (context, index) {
                              return missionItem(missions[index]);
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

  missionItem(MissionModel mission) {
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
                  mission.status == 'pending'
                      ? language == 'fr'
                          ? 'En attente'
                          : 'Pending'
                      : mission.status == 'accepted'
                          ? language == 'fr'
                              ? 'Courses acceptées'
                              : 'Accepted'
                          : language == 'fr'
                              ? 'Terminée'
                              : 'Completed',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: mission.status == 'pending'
                        ? Colors.orange
                        : mission.status == 'accepted'
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
                        Text(mission.client.username,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 2.w),
                        Text(
                            DateTime.now().day == mission.date.day &&
                                    DateTime.now().month ==
                                        mission.date.month &&
                                    DateTime.now().year == mission.date.year
                                ? language == 'fr'
                                    ? 'Aujourd\'hui'
                                    : 'Today'
                                : DateFormat('EEEE, HH:mm')
                                    .format(mission.date),
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
                            child: Text(mission.from,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis)),
                        SizedBox(
                            width: 70.w,
                            child: Text(mission.to,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis)),
                        SizedBox(
                            width: 70.w,
                            child: Text(
                                mission.items.length.toString() +
                                            ' ' +
                                            language ==
                                        'fr'
                                    ? 'articles'
                                    : 'articles',
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
                          onPressed: () async {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (mission.status == 'accepted')
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              SizedBox(width: 1.w),
                              Text(
                                mission.status == 'pending'
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
                          onPressed: () async {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (mission.status == 'accepted')
                                Icon(
                                  Icons.place,
                                  color: kSecondaryColor,
                                  size: 20.sp,
                                ),
                              SizedBox(width: 1.w),
                              Text(
                                mission.status == 'pending'
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
                  if (mission.status != 'pending')
                    SizedBox(
                      width: 100.w,
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
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
