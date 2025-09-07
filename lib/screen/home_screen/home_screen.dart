import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api_services/weather_api_services.dart';
import '../../utils/weather_utils/weather_utils.dart';
import '../../weather_response_model/weather_response_model.dart';
import '../../widgets/app_button/app_button.dart';
import '../../widgets/app_large_text/app_large_text.dart';
import '../../widgets/app_text/app_text.dart';
import 'home_screen_widgets/sunrise_sunset_widget/sunrise_sunset_widget.dart';
import 'home_screen_widgets/weather_chart_painter.dart';
import 'home_screen_widgets/wind_widgets/wind_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  WeatherResponse? _weatherResponse;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      const double lat = 23.6850;
      const double lon = 90.3563;

      final data = await _weatherService.getWeatherData(lat, lon);
      setState(() {
        _weatherResponse = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    if (_weatherResponse == null) {
      return const Center(child: Text("No weather data available."));
    }

    final currentWeather = _weatherResponse!.currentWeather;
    final hourlyForecasts = _weatherResponse!.hourlyForecast;
    final dailyForecasts = _weatherResponse!.dailyForecast;
    final String backgroundImage = getBackgroundForWeather(currentWeather.icon);
    final bool hasEnoughDailyData = dailyForecasts.length >= 3;

    return Scaffold(
      //backgroundColor: Colors.blue[200],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.add, size: 30, weight: 30, color: Colors.white),
                AppLargeText(
                  text: currentWeather.cityName,
                  color: Colors.white,
                ),
                Icon(Icons.settings, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0, bottom: 60.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLargeText(
                              color: Colors.white,
                              size: 130,
                              text: "${currentWeather.temperature}",
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: AppText(
                                text: "°C",
                                size: 45,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        AppText(
                          text:
                              "${currentWeather.condition} Feels like ${currentWeather.feelsLike}°",
                          color: Colors.white.withOpacity(0.9),
                          size: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: MediaQuery.of(context).size.height / 6.5),

                  //day forecast container
                  Container(
                    height: 300,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.transparent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/image/calendar.png",
                                      height: 8,
                                      width: 8,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                AppText(
                                  text: "5-day forecast",
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                AppText(
                                  text: "More details",
                                  color: Colors.grey.shade400,
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        //today
                        if (hasEnoughDailyData)
                          _buildDailyForecastRow(
                            dayName: "Today",
                            iconCode: dailyForecasts[0].icon,
                            condition: dailyForecasts[0].condition,
                            maxTemp: dailyForecasts[0].maxTemp,
                            minTemp: dailyForecasts[0].minTemp,
                          ),

                        const SizedBox(height: 12),

                        //tomorrow
                        if (hasEnoughDailyData)
                          _buildDailyForecastRow(
                            dayName: "Tomorrow",
                            iconCode: dailyForecasts[1].icon,
                            condition: dailyForecasts[1].condition,
                            maxTemp: dailyForecasts[1].maxTemp,
                            minTemp: dailyForecasts[1].minTemp,
                          ),

                        const SizedBox(height: 12),

                        //day after tomorrow
                        if (hasEnoughDailyData)
                          _buildDailyForecastRow(
                            dayName: dailyForecasts[2]
                                .dayOfWeek, // "Mon", "Tue" etc.
                            iconCode: dailyForecasts[2].icon,
                            condition: dailyForecasts[2].condition,
                            maxTemp: dailyForecasts[2].maxTemp,
                            minTemp: dailyForecasts[2].minTemp,
                          ),

                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AppButton(
                            isResponsive: true,
                            color: Colors.white.withOpacity(0.5),
                            text: "5-day forecast",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  //hourly forecast container Custom Widget
                  SizedBox(
                    height: 270,
                    child: HourlyForecastWidget(hourlyData: hourlyForecasts,sunsetTime: currentWeather.sunset,),
                  ),
                  SizedBox(height: 10),
                  //sunrise sunset container custom widget
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SunriseSunsetWidget(
                              sunrise: currentWeather.sunrise,
                              sunset: currentWeather.sunset,
                              sunProgress: _calculateSunProgress(
                                currentWeather.sunrise,
                                currentWeather.sunset,
                              ),
                            ),
                            SizedBox(height: 10),
                            //compass container
                            WindWidget(
                              direction: currentWeather.windDirection,
                              speed: "${currentWeather.windSpeed}km/h",
                              windAngleDegrees: 0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      //additional info container
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  "Humidity",
                                  "${currentWeather.humidity}%",
                                ),
                                const Divider(color: Colors.white24),
                                _buildInfoRow(
                                  "Real feel",
                                  "${currentWeather.feelsLike}°",
                                ),
                                const Divider(color: Colors.white24),
                                _buildInfoRow(
                                  "Pressure",
                                  "${currentWeather.pressure}hPa",
                                ),
                                const Divider(color: Colors.white24),
                                _buildInfoRow("UV", "N/A"),
                                const Divider(color: Colors.white24),
                                _buildInfoRow(
                                  "Chance of rain",
                                  "${currentWeather.chanceOfRain}%",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 80,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.transparent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(text: "AQI 28", color: Colors.white, size: 25),
                        Row(
                          children: [
                            AppText(
                              text: "Full air quality",
                              color: Colors.white,
                              size: 15,
                            ),
                            Icon(Icons.arrow_right, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: "Data Provide in part by",
                        size: 15,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      Row(
                        children: [
                          Icon(Icons.sunny, color: Colors.white),
                          AppText(text: "AccuWeather", color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper function to build a row with title and value for additional info.
Widget _buildInfoRow(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppText(text: title, color: Colors.white, size: 20),
      AppText(
        text: value,
        color: Colors.white,
        size: 20,
        fontWeight: FontWeight.bold,
      ),
    ],
  );
}

// Calculate the progress of the sun based on sunrise and sunset times.
double _calculateSunProgress(String sunriseStr, String sunsetStr) {
  try {
    final now = DateTime.now();
    final sunrise = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(sunriseStr.split(':')[0]),
      int.parse(sunriseStr.split(':')[1]),
    );
    final sunset = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(sunsetStr.split(':')[0]),
      int.parse(sunsetStr.split(':')[1]),
    );

    if (now.isBefore(sunrise)) return 0.0;
    if (now.isAfter(sunset)) return 1.0;

    final totalDaylight = sunset.difference(sunrise).inMinutes;
    final progress = now.difference(sunrise).inMinutes;

    return progress / totalDaylight;
  } catch (e) {
    return 0.5;
  }
}

Widget _buildDailyForecastRow({
  required String dayName,
  required String iconCode,
  required String condition,
  required int maxTemp,
  required int minTemp,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        child: Row(
          children: [
            Image.network(
              'https://openweathermap.org/img/wn/$iconCode@2x.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 5),
            // AppText(text: "$dayName $condition", color: Colors.white),
            AppText(text: "$dayName $condition", color: Colors.white, size: 20),
          ],
        ),
      ),

      // AppText(text: "$maxTemp° / $minTemp°", color: Colors.white, size: 18),
      AppText(text: "$maxTemp° / $minTemp°", color: Colors.white, size: 20),
    ],
  );
}

//034b448665ab0974d29380682cf6fe12
