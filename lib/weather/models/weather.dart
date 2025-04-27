enum WeatherCondition {clear, rainy, cloudy, snowy, unknown,}

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
  final String description;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      minTemperature: (json['main']['temp_min'] as num).toDouble(),
      maxTemperature: (json['main']['temp_max'] as num).toDouble(),
      description: (json['weather'][0]['description']) as String,
    );
  }

  static final empty = Weather(
    cityName: '',
    temperature: 0,
    minTemperature: 0,
    maxTemperature: 0,
    description: "unknown"
  );
}
