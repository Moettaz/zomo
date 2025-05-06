import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zomo/design/const.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/screens/auth/signin.dart';
import 'package:zomo/screens/client/profile/change_profile.dart';
import 'package:zomo/screens/client/profile/language_page.dart';
import 'package:zomo/screens/client/profile/my_points.dart';
import 'package:zomo/screens/client/profile/politique.dart';
import 'package:zomo/screens/client/profile/signal_problem.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text(language == 'fr' ? 'Mon profil' : 'My profile',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor)),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(top: 5.h, left: 2.w, right: 2.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  // Profile avatar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/person.png'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      // Name and email
                      Text(
                        'Nom Prénom',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'email@example.com',
                        style:
                            TextStyle(fontSize: 15.sp, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 1.h),
                      // Edit profile button
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.sp, vertical: 8.sp),
                        ),
                        child: Text(
                            language == 'fr'
                                ? 'Modifier profil'
                                : 'Edit profile',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              // Profile options
              _buildProfileOption(
                  Icons.person_outline_rounded,
                  language == 'fr'
                      ? 'Informations personnelles'
                      : 'Personal information', () {
                Get.to(() => ChangeProfile());
              }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Divider(
                  color: kSecondaryColor,
                ),
              ),

              _buildProfileOption(Icons.language_outlined,
                  language == 'fr' ? 'Langues' : 'Languages', () {
                Get.to(() => LanguagePage());
              }),
              _buildProfileOption(
                  Icons.info_outline,
                  language == 'fr'
                      ? 'Signaler un problème'
                      : 'Report a problem', () {
                Get.to(() => SignalProblem());
              }),
              _buildProfileOption(Icons.star_rounded,
                  language == 'fr' ? 'Système de points' : 'Points system', () {
                Get.to(() => MyPointsPage());
              }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Divider(
                  color: kSecondaryColor,
                ),
              ),
              _buildProfileOption(
                  Icons.privacy_tip_outlined,
                  language == 'fr'
                      ? 'Politique de confidentialité'
                      : 'Privacy policy', () {
                Get.to(() => Politique());
              }),
              _buildProfileOption(
                  Icons.logout, language == 'fr' ? 'Déconnexion' : 'Logout',
                  () {
                Get.offAll(() => SignInScreen());
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, Function() onTap) {
    return ListTile(
      leading: Icon(icon, color: kSecondaryColor),
      title: Text(title,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: kSecondaryColor)),
      trailing: Icon(Icons.chevron_right, color: kSecondaryColor),
      onTap: onTap,
    );
  }
}
