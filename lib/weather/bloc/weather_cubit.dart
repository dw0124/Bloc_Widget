import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_widget/weather/bloc/weather_state.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/repository/map_repository.dart';
import 'package:bloc_widget/weather/repository/weather_repository.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(WeatherState()) {
    _init();
  }

  final WeatherRepository _weatherRepository;

  Future<void> _init() async {
    final loaded = await _loadSavedWeatherState();

    if (loaded) {
      final lng = state.locationAddress.longitude;
      final lat = state.locationAddress.latitude;
      fetchWeather(lng, lat); // 갱신
    } else {
      // 로컬에 아무것도 없을 때 -> 기본값
      const defaultLat = 37.5665;
      const defaultLng = 126.9780;
      fetchWeather(defaultLng, defaultLat);
    }
  }

  Future<void> fetchWeather(double lng, double lat) async {
    // 로딩 중 상태로 변경
    emit(state.copyWith(weatherStatus: WeatherStatus.loading));

    try {
      final (weather, locationAddress) = await _weatherRepository.fetchLocationInfo(lng, lat);

      final WeatherState weatherState = state.copyWith(
          weatherStatus: WeatherStatus.success,
          weather: weather,
          locationAddress: locationAddress
      );

      emit(weatherState);

      _saveWeatherState();
    } on Exception {
      emit(
        state.copyWith(
            weatherStatus: WeatherStatus.failure
        )
      );
    }
  }

  void updateWeather(Weather weather, LocationAddress locationAddress) {
    final WeatherState weatherState = state.copyWith(
        weather: weather,
        locationAddress: locationAddress
    );

    emit(weatherState);

    _saveWeatherState();

    _sendWeatherState();
  }

  void _saveWeatherState() async {
    try {
      final json = state.toJson();
      final String data = jsonEncode(json);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('weatherState', data);
    } catch (error) {
      print('saveWeather 저장 실패: $error');
    }
  }

  Future<bool> _loadSavedWeatherState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('weatherState');

    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        final restoredState = WeatherState.fromJson(jsonMap);
        emit(restoredState);

        return true;
      } catch (e) {
        print('로컬 데이터 불러오기 실패: $e');
      }
    }

    return false;
  }

  void _sendWeatherState() async {
    final platform = MethodChannel('com.example.bloc_widget/sendWeatherState');

    final json = state.toJson();

    try {
      final result = await platform.invokeMethod('sendWeatherState', {"weatherState": json});

      print(result);
    } on PlatformException catch (e) {
      print("Failed to doSomething: '${e.message}'.");
    }
  }
}