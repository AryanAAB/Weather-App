import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: MyApp()
      ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackgroundColor,
      ),
      themeMode: Provider.of<ThemeProvider>(context).darkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: "/",
      routes: {
        '/': (context) => SplashPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }
}