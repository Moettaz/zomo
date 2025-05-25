import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zomo/design/const.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/models/transporteur.dart';
import 'package:zomo/screens/transporteur/navigation_screen.dart';
import 'package:zomo/screens/transporteur/profile/activity_history.dart';
import 'package:zomo/screens/transporteur/profile/change_profile.dart';
import 'package:zomo/screens/transporteur/profile/information.dart';
import 'package:zomo/screens/transporteur/profile/solde.dart';
import 'package:zomo/services/authserices.dart';
import 'package:zomo/screens/auth/signin.dart';
import 'package:zomo/screens/client/profile/language_page.dart';
import 'package:zomo/screens/client/profile/politique.dart';

class ProfilePageTransporteur extends StatefulWidget {
  const ProfilePageTransporteur({super.key});

  @override
  State<ProfilePageTransporteur> createState() =>
      _ProfilePageTransporteurState();
}

class _ProfilePageTransporteurState extends State<ProfilePageTransporteur> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final result = await AuthServices.getProfile(transporteurData!.id!);
      if (result['success']) {
        setState(() {
          _isLoading = false;
        });
        getUserData();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
    } finally {}
  }

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
                    child: _isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: transporteurData?.imageUrl !=
                                      null
                                  ? NetworkImage(
                                      "${AuthServices.baseUrl}/${transporteurData!.imageUrl!}")
                                  : AssetImage('assets/person.png')
                                      as ImageProvider,
                            ),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: transporteurData?.imageUrl != null
                                ? NetworkImage(
                                    "${AuthServices.baseUrl}/${transporteurData!.imageUrl!}")
                                : AssetImage('assets/person.png')
                                    as ImageProvider,
                          ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      // Name and email
                      _isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Text(
                                transporteurData?.username ?? 'Nom Prénom',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Text(
                              transporteurData?.username ?? 'Nom Prénom',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                      SizedBox(height: 1.h),
                      _isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Text(
                                transporteurData?.email ?? 'email@example.com',
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.grey[600]),
                              ),
                            )
                          : Text(
                              transporteurData?.email ?? 'email@example.com',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.grey[600]),
                            ),
                      SizedBox(height: 1.h),
                      // Edit profile button
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => ChangeProfileTransporteur(
                                changingProfile: true,
                              ));
                        },
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
                Get.to(() => InformationPersonal());
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
                      ? 'Historique et activités'
                      : 'History and activities', () {
                Get.to(() => ActivityHistory());
              }),
              _buildProfileOption(Icons.monetization_on_outlined,
                  language == 'fr' ? 'Paiement' : 'Payment', () {
                Get.to(() => MyPointsTransporteurPage());
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
