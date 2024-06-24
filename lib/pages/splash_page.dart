import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/constants.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkWeatherData();
  }

  Future<void> _checkWeatherData() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasWeatherData = prefs.containsKey('weatherData');

    if (hasWeatherData) {
       Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/logo.png",
                width: 300,
                height: 300,
              ),
              SizedBox(height:20),
              Text(
                "Welcome to WeatherWise",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: getTextColor(context)
                ),
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(getContrastColor(context)),
                strokeWidth: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}