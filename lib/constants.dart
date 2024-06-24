import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_icons/weather_icons.dart';

const String API_KEY = "de93ece13e4d8e6615f76edfac6a7948";

class AppColors {
  static const backgroundColor = Color(0xFF2DC8EA);
  static const Color darkBackgroundColor = Color(0xFF134CB5);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color darkTextColor = Color(0xFFFFFFFF);
  static const Color contrastColor = Colors.brown;
  static const Color darkContrastColor = Colors.amber;
}

class CustomImageIcon extends StatelessWidget {
  final String imageUrl;
  final double size;

  CustomImageIcon({
    required this.imageUrl,
    this.size = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: size,
        height: size,
      ),
    );
  }
}

Color getTextColor(BuildContext context)
{
  if(Theme.of(context).brightness == Brightness.dark)
    return AppColors.darkTextColor;
  else
    return AppColors.textColor;
}

Color getContrastColor(BuildContext context)
{
  if(Theme.of(context).brightness == Brightness.dark)
    return AppColors.darkContrastColor;
  else
    return AppColors.contrastColor;
}

Color getBackgroundColor(BuildContext context)
{
  if(Theme.of(context).brightness == Brightness.dark)
    return AppColors.darkBackgroundColor;
  else
    return AppColors.backgroundColor;
}

Color getWhiteBlack(BuildContext context)
{
  if(Theme.of(context).brightness == Brightness.dark)
    return Colors.white;
  else
    return Colors.black;
}

TextField getTextField(BuildContext context, String name, TextEditingController controller)
{
  return TextField(
    controller: controller,
    style: TextStyle(fontSize: 22, color: getTextColor(context)),
    decoration: InputDecoration(
      labelText: name,
      labelStyle: TextStyle(fontSize: 20, color: getTextColor(context)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: getContrastColor(context)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: getContrastColor(context)),
      ),
    ),
  );
}

String getCallUrl(String city)
{
  return 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$API_KEY&units=metric';
}

Future<Map<String, dynamic>?> getData(String city) async {
  final locationUrl = getCallUrl(city);

  try {
    final locationResponse = await http.get(Uri.parse(locationUrl));

    if (locationResponse.statusCode == 200) {
      final locationData = json.decode(locationResponse.body);
      return locationData;
    }
    return null;
  } catch (e) {
    return null;
  }
}

IconData getWeatherIcon(String iconCode)
{
  switch(iconCode){
    case "01d":
      return WeatherIcons.day_sunny;
    case "01n":
      return WeatherIcons.night_clear;
    case "02d":
      return WeatherIcons.day_cloudy_high;
    case "02n":
      return WeatherIcons.night_cloudy_high;
    case "03d":
    case "04d":
      return WeatherIcons.day_cloudy;
    case "03n":
    case "04n":
      return WeatherIcons.day_cloudy;
    case "09d":
      return WeatherIcons.day_showers;
    case "09n":
      return WeatherIcons.night_showers;
    case "10d":
      return WeatherIcons.day_rain;
    case "10n":
      return WeatherIcons.night_rain;
    case "11d":
      return WeatherIcons.day_thunderstorm;
    case "11n":
      return WeatherIcons.night_thunderstorm;
    case "13d":
      return WeatherIcons.day_snow;
    case "13n":
      return WeatherIcons.night_snow;
    case "50d":
      return WeatherIcons.day_fog;
    default:
      return WeatherIcons.night_fog;
  }
}