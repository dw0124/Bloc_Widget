import 'package:bloc_widget/weather/models/location_address.dart';
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

  final LocationAddress locationAddress;
  final Weather weather;
  final WeatherStatus weatherStatus;

  WeatherState({
    this.weatherStatus = WeatherStatus.initial,
    LocationAddress? locationAddress,
    Weather? weather,
  }) : weather = weather ?? Weather.empty,
       locationAddress = locationAddress ?? LocationAddress.empty;

  // 기존 인스턴스의 값을 유지하면서, 특정 프로퍼티만 변경하여 새로운 객체를 생성
  WeatherState copyWith({WeatherStatus? weatherStatus, Weather? weather, LocationAddress? locationAddress}) {
    return WeatherState(
      weatherStatus: weatherStatus ?? this.weatherStatus,
      weather: weather ?? this.weather,
      locationAddress: locationAddress ?? this.locationAddress,
    );
  }

  @override
  List<Object?> get props => [weather, weatherStatus];
}

