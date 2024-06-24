# Weather App

A Flutter application (using Dart) for displaying weather information using the OpenWeatherMap API.

## Libraries Used
- http: for accessing the OpenWeatherMap API
- shared_preferences: for storing data
- provider: for managing the state of the app
- weather_icons: for displaying the weather icons

## Splash Page
![images/splash.png](images/splash.png)

- The splash page is the loading page that pops up when the user opens the app.

## User Profile Page
![images/profile.png](images/profile.png)

- This page allows the users to input and store their basic profile information locally.
- It uses "shared_preferences" for local storage.

## Weather Screen
![images/weather.png](images/weather.png)

- Displays weather information for the user's home location upon opening.

![images/scroll.png](images/scroll.png)
- Shows detailed weather information such as temperature, weather conditions, wind speed, etc., for a city.
- It is vertically scrollable.

![images/search.png](images/search.png)
- Includes a search bar at the top to fetch and display weather for other cities.

## Menu Bar of Weather Screen
![images/menu.png](images/menu.png)

- Allows the user to go back to their home location by pressing on the "go back" button.

![images/darkMode.png](images/darkMode.png)
- Allows the user to toggle between dark and light mode based on their preferences.
