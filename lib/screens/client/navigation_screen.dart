import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/screens/client/history_page.dart';
import 'package:zomo/screens/client/home.dart';
import 'package:zomo/screens/client/notification_screen.dart';
import 'package:zomo/screens/client/profile/profile.dart';

class NavigationScreen extends StatefulWidget {
  final int? index;
  final bool showDialog;
  const NavigationScreen({super.key, this.index, this.showDialog = false});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
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
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: colors[_selectedIndex],
        borderRadius: BorderRadius.circular(30.sp),
        border: Border.all(color: Colors.white),
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
        physics: const BouncingScrollPhysics(),
        children: [
          HomePage(showDialog: widget.showDialog),
          Notificationscreen(),
          Historypage(),
          ProfilePage(),
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
            icon: Icon(Icons.home),
          ),
          Tab(
            icon: Icon(Icons.notifications),
          ),
          Tab(
            icon: Icon(Icons.access_time_rounded),
          ),
          Tab(
            icon: Icon(Icons.person),
          ),
        ],
        labelColor: kPrimaryColor,
        unselectedLabelColor: kSecondaryColor,
        indicatorColor: kPrimaryColor,
      ),
    );
  }
}
