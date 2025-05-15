import 'package:bloc/bloc.dart';
import 'package:bloc_widget/weather/bloc/weather_state.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/repository/map_repository.dart';
import 'package:bloc_widget/weather/repository/weather_repository.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepository, double lng, double lat) : super(WeatherState()) {
    fetchWeather(lng, lat);
  }

  final WeatherRepository _weatherRepository;

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
}