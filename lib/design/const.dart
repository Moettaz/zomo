import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

final kPrimaryColor = Color.fromRGBO(253, 186, 27, 1);
final kSecondaryColor = Color.fromRGBO(85, 94, 103, 1);
final kAccentColor = Color.fromRGBO(255, 255, 255, 1);
String language = 'fr';

GetSnackBar kErrorSnackBar(String message, {Color? color}) {
  return GetSnackBar(
    backgroundColor: color ?? kSecondaryColor,
    duration: const Duration(seconds: 2),
    snackStyle: SnackStyle.FLOATING,
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(10.sp),
    messageText: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    borderRadius: 15.sp,
  );
}

GetSnackBar kSuccessSnackBar(String message, {Color? color}) {
  return GetSnackBar(
    backgroundColor: color ?? Colors.green,
    duration: const Duration(seconds: 2),
    snackStyle: SnackStyle.FLOATING,
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(10.sp),
    messageText: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    borderRadius: 15.sp,
  );
}
