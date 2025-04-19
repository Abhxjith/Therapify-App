import 'package:flutter/material.dart';
import 'package:therapify/main/navbar.dart';
import 'package:therapify/services/notification_service.dart';
import 'splash.dart';  
import 'theme.dart';  
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Request all necessary permissions
    await Future.wait([
      Permission.microphone.request(),
      Permission.notification.request(),
    ]);
    
    // Initialize notification service
    final notificationService = NotificationService();
    await notificationService.init();
    await notificationService.scheduleDailyNotifications();
  } catch (e) {
    print('Error initializing app: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
