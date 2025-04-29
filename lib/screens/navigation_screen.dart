import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:zomo/design/const.dart';
import 'package:zomo/screens/history_page.dart';
import 'package:zomo/screens/home.dart';
import 'package:zomo/screens/notification_screen.dart';
import 'package:zomo/screens/profile/profile.dart';

class NavigationScreen extends StatefulWidget {
  final int? index;
  const NavigationScreen({super.key, this.index});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  late PersistentTabController _controller;
  @override
  void initState() {
    _selectedIndex = widget.index ?? 0;
    _controller = PersistentTabController(initialIndex: _selectedIndex);
    super.initState();
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      Notificationscreen(),
      Historypage(),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: (language == 'fr'
            ? "Accueil"
            : "Home"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: kSecondaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notifications),
        title: (language == 'fr'
            ? "Notifications"
            : "Notifications"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: kSecondaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.access_time_rounded),
        title: (language == 'fr'
            ? "Historique"
            : "History"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: kSecondaryColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: (language == 'fr'
            ? "Profil"
            : "Profile"),
        activeColorPrimary: kPrimaryColor,
        inactiveColorPrimary: kSecondaryColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardAppears: true,
        popBehaviorOnSelectedNavBarItemPress:
            PopBehavior.all, // Default is PopActionScreensType.all.
        // padding: const EdgeInsets.only(top: 8),
        backgroundColor: Colors.white,
        isVisible: true,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          ),
        ),
        confineToSafeArea: true,
        navBarHeight: kBottomNavigationBarHeight,
        navBarStyle:
            NavBarStyle.style13, // Choose the nav bar style with this property
      ),
    );
  }
}
