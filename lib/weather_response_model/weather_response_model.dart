import 'package:intl/intl.dart';

class WeatherResponse {
  final CurrentWeather currentWeather;
  final List<HourlyForecast> hourlyForecast;
  final List<DailyForecast> dailyForecast;

  WeatherResponse({
    required this.currentWeather,
    required this.hourlyForecast,
    required this.dailyForecast,
  });
}

class CurrentWeather {
  final String cityName;
  final int temperature;
  final String condition;
  final String icon;
  final int feelsLike;
  final int humidity;
  final double windSpeed;
  final String windDirection;
  final int pressure;
  final String sunrise;
  final String sunset;
  final int chanceOfRain;

  CurrentWeather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.chanceOfRain,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    String formatTimestamp(int ts) {
      final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000, isUtc: false);
      return DateFormat('HH:mm').format(dt);
    }

    String degreesToDirection(int? degrees) {
      if (degrees == null) return 'N/A';
      if (degrees > 337.5) return 'N';
      if (degrees > 292.5) return 'NW';
      if (degrees > 247.5) return 'W';
      if (degrees > 202.5) return 'SW';
      if (degrees > 157.5) return 'S';
      if (degrees > 112.5) return 'SE';
      if (degrees > 67.5) return 'E';
      if (degrees > 22.5) return 'NE';
      return 'N';
    }

    return CurrentWeather(
      cityName: json['name'] ?? 'Unknown City',
      temperature: (json['main']['temp'] as num).round(),
      condition: json['weather'][0]['main'] ?? 'Unknown',
      icon: json['weather'][0]['icon'] ?? '',
      feelsLike: (json['main']['feels_like'] as num).round(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDirection: degreesToDirection(json['wind']['deg']),
      pressure: json['main']['pressure'] ?? 0,
      sunrise: formatTimestamp(json['sys']['sunrise'] ?? 0),
      sunset: formatTimestamp(json['sys']['sunset'] ?? 0),
      chanceOfRain: ((json['pop'] as num? ?? 0.0) * 100).round(),
    );
  }
}

class HourlyForecast {
  final String time;
  final int temperature;
  final String icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    String formatTimestamp(int ts) {
      final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000, isUtc: false);
      return DateFormat('HH:mm').format(dt);
    }

    return HourlyForecast(
      time: formatTimestamp(json['dt'] ?? 0),
      temperature: (json['main']['temp'] as num).round(),
      icon: json['weather'][0]['icon'] ?? '',
    );
  }
}

class DailyForecast {
  final String dayOfWeek;
  final String icon;
  final int maxTemp;
  final int minTemp;
  final String condition;

  DailyForecast({
    required this.dayOfWeek,
    required this.icon,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
  });
}
