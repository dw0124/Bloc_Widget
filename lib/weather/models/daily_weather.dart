import 'package:intl/intl.dart';

import 'weather_condition.dart';

class DailyWeather {
  final int epochTime;
  final String formattedTime;
  final String weekdayString;
  final DateTime sunrise;
  final DateTime sunset;
  final int maxTemperature;
  final int minTemperature;
  final WeatherCondition weatherCondition;
  final double pop;

  factory DailyWeather.fromJson(Map<String, dynamic> json) {

    try {
      // 시간 정보 - 1745982000
      final epochTime = json['dt'];

      // 시간 표시 - 오후 1시, 오후 3시 ...
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          epochTime * 1000, isUtc: true).toLocal();
      // 월/일 형태 (5/7)
      final String formattedTime = DateFormat('M/d').format(dateTime);
      // 요일 (월, 화, 수, ...)
      final String weekday = DateFormat.E('ko').format(dateTime);

      final DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(json['sunrise'] * 1000, isUtc: true).toLocal();
      final DateTime sunset = DateTime.fromMillisecondsSinceEpoch(json['sunset'] * 1000, isUtc: true).toLocal();

      // 시간별 온도
      final int maxTemperature = json['temp']['max'].round();
      final int minTemperature = json['temp']['min'].round();

      // 시간별 날씨 상태 - 맑음, 비, 구름 ...
      final int weatherCode = json['weather'][0]['id'] as int;
      WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(
          weatherCode);

      final double pop = (json['pop'] as num).toDouble();

      return DailyWeather(
        epochTime: epochTime,
        formattedTime: formattedTime,
        weekdayString: weekday,
        sunrise: sunrise,
        sunset: sunset,
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

  Map<String, dynamic> toJson() {
    return {
      'dt': epochTime,
      'sunrise': sunrise.toUtc().millisecondsSinceEpoch ~/ 1000,
      'sunset': sunset.toUtc().millisecondsSinceEpoch ~/ 1000,
      'temp': {
        'max': maxTemperature,
        'min': minTemperature,
      },
      'weather': [
        {
          'id': weatherCondition.toWeatherCode(),
        }
      ],
      'pop': pop,
    };
  }

  DailyWeather({
    required this.epochTime,
    required this.formattedTime,
    required this.weekdayString,
    required this.sunrise,
    required this.sunset,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCondition,
    required this.pop
  });

  static final empty = DailyWeather(
    epochTime: 1746846000,
    formattedTime: '5/11',
    weekdayString: '일',
    sunrise: DateTime.fromMillisecondsSinceEpoch(1746822585 * 1000, isUtc: true).toLocal(),
    sunset: DateTime.fromMillisecondsSinceEpoch(1746872828 * 1000, isUtc: true).toLocal(),
    maxTemperature: 0,
    minTemperature: 0,
    weatherCondition: WeatherCondition.unknown,
    pop: 0.0,
  );
}