import 'package:bloc_widget/weather/models/current_weather.dart';
import 'package:bloc_widget/weather/models/daily_weather.dart';
import 'package:bloc_widget/weather/models/hourly_weather.dart';

import 'weather_condition.dart';

enum TemperatureUnits { fahrenheit, celsius }

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

class Weather {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  factory Weather.fromJson(Map<String, dynamic> json) {
    final CurrentWeather current = CurrentWeather.fromJson(json['current']);

    final List<Map<String, dynamic>> hourlyJson = json['hourly'];
    final List<HourlyWeather> hourly = hourlyJson.map((item) =>
        HourlyWeather.fromJson(item)).toList();

    final List<Map<String, dynamic>> dailyJson = json['daily'];
    final List<DailyWeather> daily = dailyJson.map((item) =>
        DailyWeather.fromJson(item)).toList();

    return Weather(
        current: current,
        hourly: hourly,
        daily: daily
    );
  }

  Weather({
    required this.current,
    required this.hourly,
    required this.daily
  });

  static final empty = Weather(
      current: CurrentWeather.empty,
      hourly: [
        HourlyWeather.empty,
        HourlyWeather.empty,
        HourlyWeather.empty,
        HourlyWeather.empty,
        HourlyWeather.empty
      ],
      daily: [
        DailyWeather.empty,
        DailyWeather.empty,
        DailyWeather.empty,
        DailyWeather.empty,
        DailyWeather.empty
      ]
  );
}
