import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _homeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getBackgroundColor(context),
        title: Text("WeatherWise",
          style: TextStyle(
            color: getTextColor(context)
          ),
        ),
        leading: Image.asset('assets/logo.png'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/logo.png",
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(height:20),
                    Text(
                      "Please Login to Continue to WeatherWise",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: getTextColor(context)
                      ),
                    ),
                    getTextField(context, "Name", _nameController),
                    getTextField(context, "Email", _emailController),
                    SizedBox(height: 20.0),
                    getTextField(context, "Home Location", _homeController),
                    SizedBox(height: 20.0),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _handleLogin,
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  void _handleLogin() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String home = _homeController.text.trim();

    setState(() {
      _isLoading = true;
    });

    var weatherData = await _validateHomeLocation(home);

    if (weatherData != null) {
      // Store user details and weather data locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('name', name);
      await prefs.setString('home', home);
      await prefs.setString('city', home);
      await prefs.setString('weatherData', json.encode(weatherData));

      setState(() {
        _isLoading = false;
      });

      // Navigate to the next screen and pass weather data
      Navigator.pushReplacementNamed(context, '/home', arguments: [email, name, home, weatherData]);
    } else {
      setState(() {
        _isLoading = false;
      });

      // Show error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid home location. Please check and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<Map<String, dynamic>?> _validateHomeLocation(String home) async {
    final locationUrl = getCallUrl(home);

    try {
      final locationResponse = await http.get(Uri.parse(locationUrl));

      if (locationResponse.statusCode == 200) {
        final weatherData = json.decode(locationResponse.body);
        return weatherData;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}