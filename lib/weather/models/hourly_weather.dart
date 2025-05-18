import 'package:intl/intl.dart';

import 'weather_condition.dart';

class HourlyWeather {
  final DateTime epochTime;
  final bool isNight;
  final String dateTimeString;
  final int temperature;
  final WeatherCondition weatherCondition;
  final double pop;

  factory HourlyWeather.fromJson({required Map<String, dynamic> json, required isNight}) {
    try {
      // 시간 표시 - 오후 1시, 오후 3시 ...
      final DateTime epochTime = DateTime.fromMillisecondsSinceEpoch(
          json['dt'] * 1000, isUtc: true).toLocal();
      final String formattedTime = DateFormat('a h시', 'ko').format(epochTime);

      // 시간별 온도
      final int temperature = json['temp'].round();

      // 시간별 날씨 상태 - 맑음, 비, 구름 ...
      final int weatherCode = json['weather'][0]['id'] as int;
      WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(
          weatherCode);

      final double pop = (json['pop'] as num).toDouble();

      return HourlyWeather(
        epochTime: epochTime,
        isNight: isNight,
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

  Map<String, dynamic> toJson() {
    return {
      'dt': epochTime.toUtc().millisecondsSinceEpoch ~/ 1000,
      'temp': temperature,
      'weather': [
        {
          'id': weatherCondition.toWeatherCode(),
        }
      ],
      'pop': pop,
    };
  }


  HourlyWeather({
    required this.epochTime,
    required this.isNight,
    required this.dateTimeString,
    required this.temperature,
    required this.weatherCondition,
    required this.pop
  });

  static final empty = HourlyWeather(
    epochTime: DateTime.fromMillisecondsSinceEpoch(1745982000 * 1000, isUtc: true).toLocal(),
    isNight: false,
    dateTimeString: '오후 ?시',
    temperature: 0,
    weatherCondition: WeatherCondition.unknown,
    pop: 0.0,
  );
}