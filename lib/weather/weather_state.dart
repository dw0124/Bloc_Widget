import 'package:equatable/equatable.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState extends Equatable {

  //Weather weather;
  final WeatherStatus weatherStatus;

  const WeatherState({
    this.weatherStatus = WeatherStatus.initial
  });

  // 기존 인스턴스의 값을 유지하면서, 특정 프로퍼티만 변경하여 새로운 객체를 생성
  WeatherState copyWith({WeatherStatus? weatherStatus}) {
    return WeatherState(
      weatherStatus: weatherStatus ?? this.weatherStatus,
    );
  }

  @override
  List<Object?> get props => [weatherStatus];
}

