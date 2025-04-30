import 'package:intl/intl.dart';

import 'weather_condition.dart';

class DailyWeather {
  final int epochTime;
  final String weekdayString;
  final double maxTemperature;
  final double minTemperature;
  final WeatherCondition weatherCondition;
  final double pop;

  factory DailyWeather.fromJson(Map<String, dynamic> json) {

    try {
      // 시간 정보 - 1745982000
      final epochTime = json['dt'];

      // 시간 표시 - 오후 1시, 오후 3시 ...
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          epochTime * 1000, isUtc: true).toLocal();
      final String formattedTime = DateFormat('a h시', 'ko').format(dateTime);

      // 시간별 온도
      final double maxTemperature = (json['temp']['max'] as num).toDouble();
      final double minTemperature = (json['temp']['min'] as num).toDouble();

      // 시간별 날씨 상태 - 맑음, 비, 구름 ...
      final int weatherCode = json['weather'][0]['id'] as int;
      WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(
          weatherCode);

      final double pop = (json['pop'] as num).toDouble();

      return DailyWeather(
        epochTime: epochTime,
        weekdayString: formattedTime,
        maxTemperature: maxTemperature,
        minTemperature: minTemperature,
        weatherCondition: weatherCondition,
        pop: pop,
      );
    } catch (e, stacktrace) {
      // 에러 로그 출력
      print('DailyWeather.fromJson 에러: $e');
      print(stacktrace);

      return DailyWeather.empty;
    }
  }

  DailyWeather({
    required this.epochTime,
    required this.weekdayString,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCondition,
    required this.pop
  });

  static final empty = DailyWeather(
    epochTime: 1745982000,
    weekdayString: '목',
    maxTemperature: 0.0,
    minTemperature: 0.0,
    weatherCondition: WeatherCondition.unknown,
    pop: 0.0,
  );
}