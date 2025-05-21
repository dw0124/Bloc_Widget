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

    final dailyJson = json['daily'];
    final List<DailyWeather> daily = (json['daily'] as List)
        .map((item) => DailyWeather.fromJson(item as Map<String, dynamic>))
        .toList();

    final hourlyJson = json['hourly'];
    final List<HourlyWeather> hourly = (hourlyJson as List)
        .take(24) // 앞 24개만 유지
        .map((item) {
      final hourlyDt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);

      final sunrise = daily[0].sunrise;
      final sunset = daily[0].sunset;
      final sunriseNext = daily[1].sunrise;
      final sunsetNext = daily[1].sunset;

      bool isNight = false;

      if (hourlyDt.isBefore(sunrise)) {
        isNight = true;
      } else if (hourlyDt.isAfter(sunrise) && hourlyDt.isBefore(sunset)) {
        isNight = false;
      } else if (hourlyDt.isAfter(sunset) && hourlyDt.isBefore(sunriseNext)) {
        isNight = true;
      } else
      if (hourlyDt.isAfter(sunriseNext) && hourlyDt.isBefore(sunsetNext)) {
        isNight = false;
      } else {
        isNight = true;
      }

      return HourlyWeather.fromJson(
        json: item as Map<String, dynamic>,
        isNight: isNight,
      );
    }).toList();


    return Weather(
        current: current,
        hourly: hourly,
        daily: daily
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'hourly': hourly.map((weather) => weather.toJson()).toList(),
      'daily': daily.map((weather) => weather.toJson()).toList(),
    };
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
