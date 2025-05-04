import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zomo/design/const.dart';

class Politique extends StatefulWidget {
  const Politique({super.key});

  @override
  State<Politique> createState() => _PolitiqueState();
}

class _PolitiqueState extends State<Politique> {
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
            'Politique de confidentialité',
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
          child: Text(
              language == 'fr'
                  ? '1. Généralités\nZomo s\'engage à protéger votre vie privée. Cette politique explique comment nous collectons, utilisons et partageons vos données lorsque vous utilisez notre application.\n\n2. Collecte des informations\nNous collectons :\nVos informations personnelles.\nVos données d\'utilisation.\nVos données techniques.\n\n3. Utilisation des données\nVos données servent à :\nGérer votre compte et votre expérience.\nFournir et améliorer nos services.\nVous envoyer des notifications utiles.\n\n4. Partage des données\nNous ne partageons vos données que :\nAvec des partenaires de confiance (hébergement, support technique).\nSi la loi l\'exige.\nAvec votre accord.'
                  : '1. General\nZomo is committed to protecting your privacy. This policy explains how we collect, use and share your data when you use our application.\n\n2. Information Collection\nWe collect:\nYour personal information.\nYour usage data.\nYour technical data.\n\n3. Data Usage\nYour data is used to:\nManage your account and experience.\nProvide and improve our services.\nSend you useful notifications.\n\n4. Data Sharing\nWe only share your data:\nWith trusted partners (hosting, technical support).\nIf required by law.\nWith your consent.',
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
        ),
      ),
    );
  }
}
