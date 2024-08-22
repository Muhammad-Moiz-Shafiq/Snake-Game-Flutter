import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:snake_game/main_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 4), vsync: this)
          ..forward()
          ..addListener(() {
            if (_controller.isCompleted) {
              _controller.repeat();
            }
          });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'asset/Animation.json',
                controller: _controller,
                height: 220,
                width: 220,
                fit: BoxFit.fill,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                },
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                'Tap anywhere to continue...',
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
              )
                  .animate(onComplete: (contr) => contr.repeat())
                  .fade(duration: 3.seconds)
                  .then(delay: 500.ms)
                  .fadeOut(duration: 1.seconds),
            ],
          ),
        ),
      ),
    );
  }
}
