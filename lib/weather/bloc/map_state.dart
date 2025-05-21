import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_widget/weather/models/weather.dart';

enum MapStatus { initial, loading, success, failure }

extension WeatherStatusX on MapStatus {
  bool get isInitial => this == MapStatus.initial;
  bool get isLoading => this == MapStatus.loading;
  bool get isSuccess => this == MapStatus.success;
  bool get isFailure => this == MapStatus.failure;
}

class MapState extends Equatable {

  final LocationAddress locationAddress;
  final Weather weather;
  final MapStatus weatherStatus;

  MapState({
    this.weatherStatus = MapStatus.initial,
    LocationAddress? locationAddress,
    Weather? weather,
  }) : weather = weather ?? Weather.empty,
        locationAddress = locationAddress ?? LocationAddress.empty;

  // 기존 인스턴스의 값을 유지하면서, 특정 프로퍼티만 변경하여 새로운 객체를 생성
  MapState copyWith({MapStatus? weatherStatus, Weather? weather, LocationAddress? locationAddress}) {
    return MapState(
      weatherStatus: weatherStatus ?? this.weatherStatus,
      weather: weather ?? this.weather,
      locationAddress: locationAddress ?? this.locationAddress,
    );
  }

  factory MapState.fromJson(Map<String, dynamic> json) {
    final lat = json['lat'];
    final lng = json['lng'];

    return MapState(
        locationAddress: LocationAddress.fromJson(json['locationAddress'], lat: lat, lng: lng),
        weather: Weather.fromJson(json['weather']),
        weatherStatus: MapStatus.success
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationAddress': locationAddress.toJson(),
      'weather': weather.toJson()
    };
  }

  @override
  List<Object?> get props => [locationAddress, weather, weatherStatus];
}

