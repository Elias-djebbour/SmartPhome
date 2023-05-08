import 'package:flutter/material.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/auth_page.dart';

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Authentification_page(),
    );
  }
}
