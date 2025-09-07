// hourly_forecast_widget.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_apps/weather_response_model/weather_response_model.dart';
import 'package:weather_apps/widgets/app_text/app_text.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyForecast> hourlyData;
  final String? sunsetTime;

  const HourlyForecastWidget({
    Key? key,
    required this.hourlyData,
    this.sunsetTime,
  }) : super(key: key);

  IconData _getIconData(String iconCode) {
    switch (iconCode) {
      case '01d':
        return Icons.wb_sunny_rounded; // clear sky day
      case '01n':
        return Icons.nights_stay_rounded; // clear sky night
      case '02d':
        return Icons.wb_cloudy_rounded; // few clouds day
      case '02n':
        return Icons.wb_cloudy_rounded; // few clouds night
      case '03d':
      case '03n':
        return Icons.cloud_rounded; // scattered clouds
      case '04d':
      case '04n':
        return Icons.cloudy_snowing; // broken clouds
      case '09d':
      case '09n':
        return Icons.water_drop_rounded; // shower rain
      case '10d':
      case '10n':
        return Icons.beach_access_rounded; // rain day/night
      case '11d':
      case '11n':
        return Icons.thunderstorm_rounded; // thunderstorm
      case '13d':
      case '13n':
        return Icons.ac_unit_rounded; // snow
      case '50d':
      case '50n':
        return Icons.foggy; // mist
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hourlyData.isEmpty) {
      return const Center(child: Text("..."));
    }

    final List<FlSpot> spots = [];
    int sunsetIndex = -1;

    for (int i = 0; i < hourlyData.length; i++) {
      spots.add(FlSpot(i.toDouble(), hourlyData[i].temperature.toDouble()));

      if (sunsetTime != null && hourlyData[i].time == sunsetTime) {
        sunsetIndex = i;
      }
    }

    final minTemp = hourlyData
        .map((e) => e.temperature)
        .reduce((a, b) => a < b ? a : b);
    final maxTemp = hourlyData
        .map((e) => e.temperature)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              Text(
                '24-hour forecast',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),

                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: 0,
                      color: Colors.white.withOpacity(0.5),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ],
                ),

                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= hourlyData.length)
                          return const SizedBox.shrink();

                        if (index == sunsetIndex) {
                          return const Text(
                            "Sunset",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }

                        return Text(
                          '${hourlyData[index].temperature}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.orangeAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        if (index == 0) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: Colors.white,
                          );
                        }
                        return FlDotCirclePainter(color: Colors.white);
                      },
                    ),
                  ),
                ],
                minY: minTemp.toDouble() - 7,
                maxY: maxTemp.toDouble() + 7,
              ),
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(hourlyData.length, (index) {
                final forecast = hourlyData[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconData(forecast.icon),
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: index.isEven ? "8.5km/h" : "13.0km/h",
                      color: Colors.white.withOpacity(0.8),
                      size: 12,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: index == 0 ? "Now" : forecast.time,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      size: 14,
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
