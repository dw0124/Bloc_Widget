import 'weather_condition.dart';

class CurrentWeather {
  final DateTime epochTime;
  final DateTime sunrise;
  final DateTime sunset;
  final int temperature;
  final WeatherCondition weatherCondition;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {

    try {
      final DateTime epochTime = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true).toLocal();

      final DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(json['sunrise'] * 1000, isUtc: true).toLocal();
      final DateTime sunset = DateTime.fromMillisecondsSinceEpoch(json['sunset'] * 1000, isUtc: true).toLocal();

      final double temperature = json['temp'];

      // 시간별 날씨 상태 - 맑음, 비, 구름 ...
      final int weatherCode = json['weather'][0]['id'] as int;
      WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(
          weatherCode);

      return CurrentWeather(
        epochTime: epochTime,
        sunrise: sunrise,
        sunset: sunset,
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

  CurrentWeather({
    required this.epochTime,
    required this.sunrise,
    required this.sunset,
    required this.temperature,
    required this.weatherCondition
  });

  static final empty = CurrentWeather(
    epochTime: DateTime.fromMillisecondsSinceEpoch(1746598815 * 1000, isUtc: true).toLocal(),
    sunrise: DateTime.fromMillisecondsSinceEpoch(1746563555 * 1000, isUtc: true).toLocal(),
    sunset: DateTime.fromMillisecondsSinceEpoch(1746613471 * 1000, isUtc: true).toLocal(),
    temperature: 0,
    weatherCondition: WeatherCondition.unknown
  );
}