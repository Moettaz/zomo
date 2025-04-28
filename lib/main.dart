import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'screens/firstpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            surface: Colors.white,
            seedColor: Color.fromRGBO(253, 186, 27, 0),
          ),
        ),
        home: const FirstPage(),
      );
    });
  }
}
