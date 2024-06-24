import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/main.dart';
import 'package:weather_icons/weather_icons.dart';

class HamburgerMenuBar extends StatelessWidget {
  final _HomePageState state;

  HamburgerMenuBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Container(
        color: themeProvider.darkMode ? Colors.grey[900] : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text(
                  'WeatherWise',
                  style: TextStyle(
                    fontSize: 30,
                    color: getContrastColor(context),
                )
              ),
              ),
              decoration: BoxDecoration(
                color: themeProvider.darkMode ? Colors.black : Colors.blue,
              ),
            ),
            ListTile(
              title: FutureBuilder<String?>(
                future: getName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Text(
                        "Name: " + (snapshot.data ?? 'No Name found'),
                        style: const TextStyle(
                          fontSize: 25
                        ),
                    );
                  }
                },
              ),
              onTap: () {
                // Handle item tap
              },
            ),
            const SizedBox(height: 40,),
            ListTile(
              title: FutureBuilder<String?>(
              future: getEmail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return Text(
                      "Email: " + (snapshot.data ?? 'No Email found'),
                      style: const TextStyle(
                        fontSize: 25
                      ),
                  );
                }
              },
              ),
            ),
            const SizedBox(height: 40,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: getWhiteBlack(context),
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  // Handle button press
                  String? homeCity = await getHomeCity();
                  if(homeCity != null)
                    state._updateWeatherData(homeCity);
                  Navigator.of(context).pop();
                },
                child: FutureBuilder<String?>(
                  future: getHomeCity(),
                  builder: (context, snapshot) {
                    return Text(
                        "Go Home: " + (snapshot.data ?? 'No Home found'),
                        style: const TextStyle(
                        fontSize: 25
                        )
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40,),
            ListTile(
              title: const Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              leading: const Icon(Icons.dark_mode, size: 30),
              trailing: Switch(
                value: themeProvider.darkMode,
                onChanged: (value) {
                  themeProvider.darkMode = value;
                  Navigator.of(context).pop();
                },
                activeColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");

    return name;
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");

    return email;
  }

  Future<String?> getHomeCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? home = prefs.getString("home");

    return home;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getBackgroundColor(context),
        title: Row(
          children: [
            const SizedBox(width: 8),
            Image.asset(
              'assets/logo.png',
              height: 32,
            ),
            const SizedBox(width: 8),
            const Text(
              'WeatherWise',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search city...',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey), // Color of the hint text
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue), // Border color when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // Border color when not focused
                      ),
                      filled: true,
                      fillColor: Colors.white, // Background color of the TextField
                    ),
                    style: const TextStyle(color: Colors.black), // Text color of the entered text
                    cursorColor: Colors.blue, // Color of the cursor
                    onSubmitted: (value) {
                      _updateWeatherData(value.trim());
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _updateWeatherData(_searchController.text.trim());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: HamburgerMenuBar(state: this),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: getWeatherData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              var data = snapshot.data;
              return data != null?
                Scaffold(
                  body: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  size: 75,
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                data["name"],
                                style: TextStyle(
                                    fontSize: 40,
                                    color: getTextColor(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50), // Space between top and center content
                          BoxedIcon(
                            getWeatherIcon(data["weather"][0]["icon"]),
                            size: 100,
                            color:getContrastColor(context),
                          ),
                          Text(
                            data["main"]["temp"].toString() + '°C',
                            style: TextStyle(
                                fontSize: 50,
                                color: getTextColor(context),
                            ),
                          ),
                          Text(
                            "Feels Like: " + data["main"]["feels_like"].toString() + '°C',
                            style: TextStyle(
                                fontSize: 30,
                                color: getTextColor(context),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            color: getBackgroundColor(context),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _buildWeatherInfoRow(Icons.arrow_circle_down, "Min Temp", "${data["main"]["temp_min"]}°C"),
                                  _buildWeatherInfoRow(Icons.arrow_circle_up, "Max Temp", "${data["main"]["temp_max"]}°C"),
                                  _buildWeatherInfoRow(Icons.speed, "Wind Speed", "${data["wind"]["speed"]} m/s"),
                                  _buildWeatherInfoRow(Icons.cloud, "Humidity", "${data["main"]["humidity"]}%"),
                                  _buildWeatherInfoRow(Icons.visibility, "Visibility", "${data["visibility"] / 1000} km"),
                                  _buildWeatherInfoRow(Icons.terrain, "Pressure", "${data["main"]["pressure"]} hPa"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ) :
              Text(
                  'No data available',
                  style: TextStyle(
                    color: getTextColor(context),
                    fontSize: 40,
                  )
              );
            } else {
              return Text(
                  'No data available',
                  style: TextStyle(
                    color: getTextColor(context),
                    fontSize: 40,
                  )
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildWeatherInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 50),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateWeatherData(String city) async {
    if (city.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('city', city);
      setState(() {}); // Refresh UI
    }
  }

  Future<Map<String, dynamic>?> getWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String?city = prefs.getString("city");

    if(city == null) {
      String?home = prefs.getString("home");
      if(home == null)
        return null;
      return getData(home);
    }
    else
      return getData(city);
  }
}