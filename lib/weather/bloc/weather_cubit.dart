import 'package:bloc/bloc.dart';
import 'package:bloc_widget/weather/bloc/weather_state.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/repository/map_repository.dart';
import 'package:bloc_widget/weather/repository/weather_repository.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(WeatherState()) {
    _init();
  }

  final WeatherRepository _weatherRepository;

  Future<void> _init() async {
    final loaded = await _loadSavedWeather();

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
      emit(
        state.copyWith(
            weatherStatus: WeatherStatus.success,
            weather: weather,
            locationAddress: locationAddress
        )
      );
    } on Exception {
      emit(
        state.copyWith(
            weatherStatus: WeatherStatus.failure
        )
      );
    }
  }

  void updateWeather(Weather weather, LocationAddress locationAddress) {
    emit(
        state.copyWith(
            weather: weather,
            locationAddress: locationAddress
        )
    );
  }
}