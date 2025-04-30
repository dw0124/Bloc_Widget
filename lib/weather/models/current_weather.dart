import 'weather_condition.dart';

class CurrentWeather {
  final double temperature;
  final WeatherCondition weatherCondition;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final double temperature = json['temp'];

    // 시간별 날씨 상태 - 맑음, 비, 구름 ...
    final int weatherCode = json['weather'][0]['id'] as int;
    WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(weatherCode);

    return CurrentWeather(
      temperature: temperature,
      weatherCondition: weatherCondition,
    );
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