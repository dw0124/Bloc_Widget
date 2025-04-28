import 'package:bloc/bloc.dart';
import 'package:bloc_widget/weather/bloc/weather_state.dart';
import 'package:bloc_widget/weather/repository/weather_repository.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepository) : super(WeatherState()) {
    fetchWeather();
  }

  final WeatherRepository _weatherRepository;

  Future<void> fetchWeather() async {
    // 로딩 중 상태로 변경
    emit(state.copyWith(weatherStatus: WeatherStatus.loading));

    try {
      final weather = await _weatherRepository.fetchWeather();
      emit(
        state.copyWith(
            weatherStatus: WeatherStatus.success,
            weather: weather)
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