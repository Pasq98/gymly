import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'Home/Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(height: 250, width: 300, child: Image.asset('assets/Logo.png')),
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Lottie.asset(
                'assets/Animation - 170203776192.json', // Replace with the path to your Lottie JSON file
                fit: BoxFit.cover,
                width: 200, // Adjust the width and height as needed
                height: 200,
                repeat: true, // Set to true if you want the animation to loop
              ),
            ),
          ],
        ),
      ),
    );
  }
}
