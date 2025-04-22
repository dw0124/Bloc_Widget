import 'package:equatable/equatable.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState extends Equatable {

  //Weather weather;
  WeatherStatus weatherStatus;

  WeatherState({
    this.weatherStatus = WeatherStatus.initial
  });

  @override
  List<Object?> get props => [weatherStatus];
}

