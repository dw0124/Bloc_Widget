import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApiProvider {
  WeatherApiProvider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<Map<String, dynamic>> fetchWeatherJson({double? lng, double? lat}) async {
    final apiKey = dotenv.env['WEATHER_API_KEY'];

    final longitude = (lng ?? 126.86459566919459).toString();
    final latitude = (lat ?? 37.52623959815854).toString();

    print('$longitude, $latitude');

    final query = {
      'lat': latitude,
      'lon': longitude,
      'units': 'metric',
      'lang': 'kr',
      'appid': apiKey,
    };

    final url = Uri.https(
        "api.openweathermap.org",
        "/data/3.0/onecall",
        query
    );

    var response = await _httpClient.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch weather: ${response.statusCode}');
    }
  }

  void close() { _httpClient.close(); }
}