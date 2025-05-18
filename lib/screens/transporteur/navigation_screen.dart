import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/models/transporteur.dart';
import 'package:zomo/screens/transporteur/history_page.dart';
import 'package:zomo/screens/transporteur/home.dart';
import 'package:zomo/screens/transporteur/mission_screen.dart';
import 'package:zomo/screens/transporteur/profile/profile.dart';
import 'package:zomo/services/authserices.dart';

class NavigationScreenTransporteur extends StatefulWidget {
  final int? index;
  const NavigationScreenTransporteur({
    super.key,
    this.index,
  });

  @override
  State<NavigationScreenTransporteur> createState() =>
      _NavigationScreenTransporteurState();
}

Transporteur? transporteurData;
bool? showwDialog;

class _NavigationScreenTransporteurState
    extends State<NavigationScreenTransporteur>
    with SingleTickerProviderStateMixin {
  Future<void> getUserData() async {
    try {
      final response = await AuthServices.getCurrentUser();
      if (response != null) {
        setState(() {
          if (response['specific_data'] != null) {
            if (response['specific_data'] is Transporteur) {
              transporteurData = response['specific_data'];
            } else {
              transporteurData =
                  Transporteur.fromJson(response['specific_data']);
            }
          }
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting user data: $e');
    }
  }

  int _selectedIndex = 0;
  late TabController _tabController;
  final List<Color> colors = [
    kPrimaryColor,
    kPrimaryColor,
    kPrimaryColor,
    kPrimaryColor
  ];

  @override
  void initState() {
    getUserData();

    _selectedIndex = widget.index ?? 0;
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: _selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      fit: StackFit.expand,
      borderRadius: BorderRadius.circular(30.sp),
      duration: Duration(seconds: 1),
      curve: Curves.bounceIn,
      showIcon: true,
      width: 90.w,
      barColor: Colors.white,
      start: 2,
      end: 0,
      offset: 1.h,
      barAlignment: Alignment.bottomCenter,
      iconHeight: 10.sp,
      iconWidth: 10.sp,
      reverse: false,
      barDecoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: colors[_selectedIndex],
        borderRadius: BorderRadius.circular(30.sp),
      ),
      iconDecoration: BoxDecoration(
        color: colors[_selectedIndex],
        borderRadius: BorderRadius.circular(30.sp),
      ),
      hideOnScroll: false,
      scrollOpposite: false,
      onBottomBarHidden: () {},
      onBottomBarShown: () {},
      body: (context, controller) => TabBarView(
        controller: _tabController,
        dragStartBehavior: DragStartBehavior.down,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePageTransporteur(),
          MissionScreen(),
          HistorypageTransporteur(),
          ProfilePageTransporteur(),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        tabs: [
          Tab(
            icon: Icon(Icons.map_outlined),
          ),
          Tab(
            icon: Icon(Icons.edit_calendar_sharp),
          ),
          Tab(
            icon: Icon(Icons.message_outlined),
          ),
          Tab(
            icon: Icon(Icons.person_outline),
          ),
        ],
        labelColor: kPrimaryColor,
        unselectedLabelColor: kSecondaryColor,
        indicator: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(color: kPrimaryColor),
          ),
        ),
        dividerColor: Colors.transparent,
      ),
    );
  }
}
