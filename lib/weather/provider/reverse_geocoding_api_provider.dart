import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReverseGeocodingApiProvider {
  ReverseGeocodingApiProvider({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<Map<String, dynamic>> fetchWeatherJson(lng, lat) async {
    final clientID = dotenv.env['NAVER_CLIENT_ID']!;
    final clientSecret = dotenv.env['NAVER_CLIENT_SECRET']!;

    final headers = {
      'x-ncp-apigw-api-key-id': clientID,
      'x-ncp-apigw-api-key': clientSecret,
    };

    final query = {
      'request': 'coordsToaddr',
      'coords': '$lng,$lat',
      'orders': 'admcode',
      'output': 'json',
    };

    final url = Uri.https(
        "maps.apigw.ntruss.com",
        "/map-reversegeocode/v2/gc",
        query
    );

    var response = await _httpClient.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch Geocoding: ${response.statusCode}');
    }
  }

  void close() { _httpClient.close(); }
}