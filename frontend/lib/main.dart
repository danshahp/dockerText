import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanzanian_bms/features/auth/application/auth_controller.dart';
import 'package:tanzanian_bms/features/auth/infrastructure/mock_auth_service.dart';
import 'package:tanzanian_bms/screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<AuthController>(AuthController(authService: MockAuthService()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData.dark(),
      title: 'Tanzanian BMS',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DashboardScreen(),
    );
  }
}

// Simple placeholder widget for unimplemented routes
class PlaceholderWidget extends StatelessWidget {
  final String title;
  const PlaceholderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title is under construction.')),
    );
  }
}
