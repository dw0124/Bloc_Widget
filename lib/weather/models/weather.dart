enum WeatherCondition {clear, rainy, cloudy, snowy, unknown,}

enum TemperatureUnits { fahrenheit, celsius }

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelsius => this == TemperatureUnits.celsius;
}

class Weather {
  const Weather({
    required this.condition,
    required this.location,
    required this.temperature,
  });

  final WeatherCondition condition;
  final String location;
  final double temperature;

  static final empty = Weather(
    condition: WeatherCondition.unknown,
    temperature: 0,
    location: '--',
  );
}