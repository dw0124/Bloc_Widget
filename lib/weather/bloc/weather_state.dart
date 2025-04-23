import 'package:equatable/equatable.dart';
import 'package:bloc_widget/weather/models/weather.dart';

enum WeatherStatus { initial, loading, success, failure }

extension WeatherStatusX on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}

class WeatherState extends Equatable {

  final Weather weather;
  final WeatherStatus weatherStatus;

  WeatherState({
    this.weatherStatus = WeatherStatus.initial,
    Weather? weather,
  }) : weather = weather ?? Weather.empty;

  // 기존 인스턴스의 값을 유지하면서, 특정 프로퍼티만 변경하여 새로운 객체를 생성
  WeatherState copyWith({WeatherStatus? weatherStatus, Weather? weather}) {
    return WeatherState(
      weatherStatus: weatherStatus ?? this.weatherStatus,
      weather: weather ?? this.weather,
    );
  }

  @override
  List<Object?> get props => [weatherStatus];
}

