import 'dart:convert';

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

  factory WeatherState.fromJson(Map<String, dynamic> json) {
    final lat = json['lat'];
    final lng = json['lng'];

    final locationJson = jsonDecode(json['locationAddress']);
    final weatherJson = jsonDecode(json['weather']);

    return WeatherState(
      locationAddress: LocationAddress.fromJson(locationJson, lat: lat, lng: lng),
      weather: Weather.fromJson(weatherJson),
      weatherStatus: WeatherStatus.success
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': locationAddress.latitude,
      'lng': locationAddress.longitude,
      'locationAddress': locationAddress.jsonString,
      'weather': weather.jsonString
    };
  }

  @override
  List<Object?> get props => [locationAddress, weather, weatherStatus];
}

