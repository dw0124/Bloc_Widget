import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/provider/weather_api_provider.dart';

class WeatherRepository {
  WeatherRepository({WeatherApiProvider? weatherApiProvider})
      : _weatherApiProvider = weatherApiProvider ?? WeatherApiProvider();

  final WeatherApiProvider _weatherApiProvider;

  Future<Weather> fetchWeather() async {
    final Map<String, dynamic> weatherJson = await _weatherApiProvider.fetchWeatherJson();

    Weather weather = Weather.fromJson(weatherJson);

    return weather;
  }

  void dispose() => _weatherApiProvider.close();
}