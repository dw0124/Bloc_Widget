import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/provider/reverse_geocoding_api_provider.dart';

import '../provider/weather_api_provider.dart';

class MapRepository {
  MapRepository({
    ReverseGeocodingApiProvider? reverseGeocodingApiProvider,
    WeatherApiProvider? weatherApiProvider
  })
      : _weatherApiProvider = weatherApiProvider ?? WeatherApiProvider(),
        _reverseGeocodingApiProvider = reverseGeocodingApiProvider ?? ReverseGeocodingApiProvider();

  final ReverseGeocodingApiProvider _reverseGeocodingApiProvider;
  final WeatherApiProvider _weatherApiProvider;

  Future<(Weather, LocationAddress)> fetchLocationInfo(double lng, double lat) async {
    final Map<String, dynamic> weatherJson = await _weatherApiProvider.fetchWeatherJson(lng: lng, lat: lat);
    Weather weather = Weather.fromJson(weatherJson);

    final Map<String, dynamic> locationAddressJson = await _reverseGeocodingApiProvider.fetchWeatherJson(lng, lat);
    LocationAddress locationAddress = LocationAddress.fromJson(locationAddressJson, lat, lng);

    return (weather, locationAddress);
  }

  void dispose() {
    _weatherApiProvider.close();
    _reverseGeocodingApiProvider.close();
  }
}