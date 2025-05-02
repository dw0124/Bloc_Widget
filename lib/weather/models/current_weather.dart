import 'weather_condition.dart';

class CurrentWeather {
  final int temperature;
  final WeatherCondition weatherCondition;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {

    try {
      final double temperature = json['temp'];

      // 시간별 날씨 상태 - 맑음, 비, 구름 ...
      final int weatherCode = json['weather'][0]['id'] as int;
      WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(
          weatherCode);

      return CurrentWeather(
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
    required this.temperature,
    required this.weatherCondition
  });

  static final empty = CurrentWeather(
      temperature: 0,
      weatherCondition: WeatherCondition.unknown
  );
}