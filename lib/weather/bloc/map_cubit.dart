import 'package:bloc/bloc.dart';
import 'package:bloc_widget/weather/bloc/map_state.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/repository/map_repository.dart';

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
  }
}