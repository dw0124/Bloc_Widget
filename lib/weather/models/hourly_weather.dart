import 'package:intl/intl.dart';

import 'weather_condition.dart';

class HourlyWeather {
  final int epochTime;
  final String dateTimeString;
  final int temperature;
  final WeatherCondition weatherCondition;
  final double pop;

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    try {
      // 시간 정보 - 1745982000
      final int epochTime = json['dt'];

      // 시간 표시 - 오후 1시, 오후 3시 ...
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          epochTime * 1000, isUtc: true).toLocal();
      final String formattedTime = DateFormat('a h시', 'ko').format(dateTime);

      // 시간별 온도
      final int temperature = json['temp'].round();

      // 시간별 날씨 상태 - 맑음, 비, 구름 ...
      final int weatherCode = json['weather'][0]['id'] as int;
      WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(
          weatherCode);

      final double pop = (json['pop'] as num).toDouble();

      return HourlyWeather(
        epochTime: epochTime,
        dateTimeString: formattedTime,
        temperature: temperature,
        weatherCondition: weatherCondition,
        pop: pop,
      );
    } catch (e, stacktrace) {
      // 에러 로그 출력
      print('HourlyWeather.fromJson 에러: $e');
      print(stacktrace);

      return HourlyWeather.empty;
    }
  }

  HourlyWeather({
    required this.epochTime,
    required this.dateTimeString,
    required this.temperature,
    required this.weatherCondition,
    required this.pop
  });

  static final empty = HourlyWeather(
    epochTime: 1745982000,
    dateTimeString: '오후 ?시',
    temperature: 0,
    weatherCondition: WeatherCondition.unknown,
    pop: 0.0,
  );
}