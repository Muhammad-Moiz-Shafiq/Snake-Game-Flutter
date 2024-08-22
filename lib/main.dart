import 'package:flutter/material.dart';
import 'package:snake_game/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:snake_game/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBSm6dLvd-WH1CIFoluZy4u435SaFdY624",
          authDomain: "snake-game-flutter-35edf.firebaseapp.com",
          projectId: "snake-game-flutter-35edf",
          storageBucket: "snake-game-flutter-35edf.appspot.com",
          messagingSenderId: "563393459754",
          appId: "1:563393459754:web:a5ade293386d1b2b39b553",
          measurementId: "G-ZD0HH81FSQ"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: WelcomeScreen(),
    );
  }
}
