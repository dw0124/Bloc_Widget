import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApiProvider {
  Future<Map<String, dynamic>> fetchWeatherJson() async {
    final apiKey = dotenv.env['WEATHER_API_KEY'];

    final query = {
      'q': 'seoul',
      'lang': 'kr',
      'units': 'metric',
      'appid': apiKey,
    };

    final url = Uri.https(
        "api.openweathermap.org",
        "/data/2.5/weather",
        query
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch weather: ${response.statusCode}');
    }
  }
}