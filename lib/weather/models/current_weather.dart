import 'weather_condition.dart';

class CurrentWeather {
  final DateTime epochTime;
  final bool isNight;
  final int temperature;
  final WeatherCondition weatherCondition;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {

    try {
      final DateTime epochTime = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true).toLocal();

      late final bool isNight;

      if (json.containsKey('isNight')) {
        isNight = json['isNight'] as bool;
      } else {
        final DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(
            json['sunrise'] * 1000, isUtc: true).toLocal();
        final DateTime sunset = DateTime.fromMillisecondsSinceEpoch(
            json['sunset'] * 1000, isUtc: true).toLocal();

        isNight = epochTime.isBefore(sunrise) || epochTime.isAfter(sunset);
      }

      final double temperature = json['temp'];

      // 시간별 날씨 상태 - 맑음, 비, 구름 ...
      final int weatherCode = json['weather'][0]['id'] as int;
      WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(
          weatherCode);

      return CurrentWeather(
        epochTime: epochTime,
        isNight: isNight,
        temperature: temperature.round(),
        weatherCondition: weatherCondition,
      );
    } catch (e, stacktrace) {
      // 에러 로그 출력
      print('CurrentWeather.fromJson 에러: $e');
      print(stacktrace);

      return CurrentWeather.empty;
    }

  }

  Map<String, dynamic> toJson() {
    return {
      'dt': epochTime.toUtc().millisecondsSinceEpoch ~/ 1000,
      'isNight': isNight,
      'temp': temperature.toDouble(),
      'weather': [
        {
          'id': weatherCondition.toWeatherCode()
        }
      ]
    };
  }

  CurrentWeather({
    required this.epochTime,
    required this.isNight,
    required this.temperature,
    required this.weatherCondition
  });

  static final empty = CurrentWeather(
    epochTime: DateTime.fromMillisecondsSinceEpoch(1746598815 * 1000, isUtc: true).toLocal(),
    isNight: false,
    temperature: 0,
    weatherCondition: WeatherCondition.unknown
  );
}