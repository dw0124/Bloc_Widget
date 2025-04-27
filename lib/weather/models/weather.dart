enum WeatherCondition {
  clear,
  clouds,
  rain,
  snow,
  thunderstorm,
  drizzle,
  atmosphere,
  unknown,
}

extension WeatherConditionX on WeatherCondition {
  static WeatherCondition fromWeatherCode(int code) {
    if (code >= 200 && code < 300) {
      return WeatherCondition.thunderstorm;
    } else if (code >= 300 && code < 400) {
      return WeatherCondition.drizzle;
    } else if (code >= 500 && code < 600) {
      return WeatherCondition.rain;
    } else if (code >= 600 && code < 700) {
      return WeatherCondition.snow;
    } else if (code >= 700 && code < 800) {
      return WeatherCondition.atmosphere;
    } else if (code == 800) {
      return WeatherCondition.clear;
    } else if (code >= 801 && code < 900) {
      return WeatherCondition.clouds;
    } else {
      return WeatherCondition.unknown;
    }
  }
}

enum TemperatureUnits { fahrenheit, celsius }

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

class Weather {
  final String cityName;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final WeatherCondition weatherCondition;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.weatherCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final int weatherCode = json['weather'][0]['id'] as int;
    WeatherCondition weatherCondition = WeatherConditionX.fromWeatherCode(weatherCode);

    return Weather(
      cityName: json['name'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      minTemperature: (json['main']['temp_min'] as num).toDouble(),
      maxTemperature: (json['main']['temp_max'] as num).toDouble(),
      weatherCondition: weatherCondition,
    );
  }

  static final empty = Weather(
      cityName: '',
      temperature: 0,
      minTemperature: 0,
      maxTemperature: 0,
      weatherCondition: WeatherCondition.unknown
  );
}
