import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_widget/weather/bloc/map_state.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/repository/map_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit(this._mapRepository, Weather weather, LocationAddress locationAddress)
      : super(MapState(weather: weather, locationAddress: locationAddress));

  final MapRepository _mapRepository;

  Future<void> fetchWeather(double lng, double lat) async {
    // 로딩 중 상태로 변경
    emit(state.copyWith(weatherStatus: MapStatus.loading));

    try {
      final (weather, locationAddress) = await _mapRepository.fetchLocationInfo(lng, lat);

      final MapState weatherState = state.copyWith(
          weatherStatus: MapStatus.success,
          weather: weather,
          locationAddress: locationAddress
      );

      emit(weatherState);

      _saveWeather();
    } on Exception {
      emit(
          state.copyWith(
              weatherStatus: MapStatus.failure
          )
      );
    }
  }

  void updateWeather(Weather weather, LocationAddress locationAddress) {
    final MapState weatherState = state.copyWith(
        weather: weather,
        locationAddress: locationAddress
    );

    emit(weatherState);

    _saveWeather();
  }

  void _saveWeather() async {
    try {
      final json = state.toJson();
      final String data = jsonEncode(json);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('weatherState', data);
    } catch (error) {
      print('saveWeather 저장 실패: $error');
    }
  }

  Future<bool> _loadSavedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('weatherState');

    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        final restoredState = MapState.fromJson(jsonMap);
        emit(restoredState);

        return true;
      } catch (e) {
        print('로컬 데이터 불러오기 실패: $e');
      }
    }

    return false;
  }
}