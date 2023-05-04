import 'package:app/pages/accueil.dart';
import 'package:flutter/material.dart';
import 'pages/auth.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { // Stateless car le contenu de la page n'est pas modifié
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: Scaffold(
        body: AuthPage(),
      ),
    );
  }
}





