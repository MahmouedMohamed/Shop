// ignore_for_file: file_names, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ny_shop/Session/SessionManager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late SessionManager sessionManager;
  late AnimationController _animationController;
  late Animation<Color> _colorAnimation;
  double value = 0.0;
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _colorAnimation = Tween<Color>(begin: Colors.green, end: Colors.blue)
        .animate(_animationController);
    sessionManager = SessionManager();
    getSession();
    changeOpacity();
  }

  getSession() async {
    await sessionManager.getSessionManager();
    setState(() {});
  }

  getHomePage() {
    if (sessionManager.isLoggedIn()) {
      sessionManager.loadSession();
      return 'MainScreen';
    }
    return 'LoginScreen';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  changeOpacity() {
    if (value < 1.0) {
      Timer.periodic(
          const Duration(seconds: 1),
          (timer) => {
                if (mounted)
                  {
                    setState(() {
                      // value += 0.02;
                      value += 0.2;
                    })
                  }
              });
      Timer.periodic(
          const Duration(seconds: 3),
          (timer) => {
                if (mounted)
                  {
                    setState(() {
                      opacity = 1 - opacity;
                      changeOpacity();
                    })
                  }
              });
    } else {
      opacity = 1.0;
      navigate();
    }
  }

  navigate() {
    sessionManager.sharedPreferences == null
        ? Future.delayed(const Duration(seconds: 5), navigate())
        : Navigator.popAndPushNamed(context, getHomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 40, left: 40),
          duration: const Duration(seconds: 3),
          decoration: const BoxDecoration(color: Colors.black),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(seconds: 2),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Image.asset('assets/images/NY.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                            value < 1.0
                                ? '${(value * 100).toStringAsPrecision(3)}%'
                                : 'Welcome',
                            style: const TextStyle(color: Colors.white)),
                        LinearProgressIndicator(
                          value: value,
                          valueColor: _colorAnimation,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
