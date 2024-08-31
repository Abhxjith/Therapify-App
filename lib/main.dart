import 'package:flutter/material.dart';
import 'splash.dart';  
import 'theme.dart';  

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therapify',
      theme: appTheme,  
      home: SplashScreen(),  
      debugShowCheckedModeBanner: false, 
    );
  }
}
