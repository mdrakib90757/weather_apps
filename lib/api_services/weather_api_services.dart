import 'dart:convert';

import 'package:intl/intl.dart';
import '../weather_response_model/weather_response_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = "034b448665ab0974d29380682cf6fe12";
  static const String _baseUrl = "https://api.openweathermap.org/data/2.5";

  // Method to fetch weather data
  Future<WeatherResponse> getWeatherData(double lat, double lon) async {
    try {
      final currentWeatherUrl = Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$_apiKey',
      );
      final forecastUrl = Uri.parse(
        '$_baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=$_apiKey',
      );

      final responses = await Future.wait([
        http.get(currentWeatherUrl),
        http.get(forecastUrl),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final currentWeatherData =
            json.decode(responses[0].body) as Map<String, dynamic>;
        final forecastData = json.decode(responses[1].body);

        if (forecastData['list'] != null &&
            (forecastData['list'] as List).isNotEmpty) {
          currentWeatherData['pop'] = forecastData['list'][0]['pop'] ?? 0.0;
        }

        final currentWeather = CurrentWeather.fromJson(currentWeatherData);
        final hourlyList = (forecastData['list'] as List)
            .take(8)
            .map((item) => HourlyForecast.fromJson(item))
            .toList();

        final List<DailyForecast> dailyList = _parseDailyForecast(
          forecastData['list'],
        );

        return WeatherResponse(
          currentWeather: currentWeather,
          hourlyForecast: hourlyList,
          dailyForecast: dailyList,
        );
      } else {
        throw Exception(
          'Failed to load weather data. Current: ${responses[0].statusCode}, Forecast: ${responses[1].statusCode}',
        );
      }
    } catch (e) {
      print("Error in getWeatherData: $e");
      throw Exception('An error occurred');
    }
  }

  // Helper method to parse daily forecast data
  List<DailyForecast> _parseDailyForecast(List<dynamic> forecastList) {
    final Map<int, List<dynamic>> dailyData = {};
    for (var item in forecastList) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      if (!dailyData.containsKey(date.day)) {
        dailyData[date.day] = [];
      }
      dailyData[date.day]!.add(item);
    }

    final List<DailyForecast> result = [];
    dailyData.forEach((day, items) {
      if (items.isNotEmpty) {
        double maxTemp = -double.infinity;
        double minTemp = double.infinity;

        for (var item in items) {
          if (item['main']['temp_max'] > maxTemp) {
            maxTemp = (item['main']['temp_max'] as num).toDouble();
          }
          if (item['main']['temp_min'] < minTemp) {
            minTemp = (item['main']['temp_min'] as num).toDouble();
          }
        }

        final representativeItem = items.firstWhere(
          (item) =>
              DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000).hour >= 12,
          orElse: () => items.first,
        );

        result.add(
          DailyForecast(
            dayOfWeek: DateFormat('E').format(
              DateTime.fromMillisecondsSinceEpoch(
                representativeItem['dt'] * 1000,
              ),
            ),
            icon: representativeItem['weather'][0]['icon'],
            maxTemp: maxTemp.round(),
            minTemp: minTemp.round(),
            condition: representativeItem['weather'][0]['main'],
          ),
        );
      }
    });
    return result.take(5).toList();
  }
}
