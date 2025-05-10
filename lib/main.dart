import 'package:flutter/material.dart';
import 'bookingpage.dart';

void main() {
  runApp(RestaurantApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFD4AF37),
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Georgia', fontSize: 18),
          titleLarge: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
      home: BookingPage(),
    );
  }
}
