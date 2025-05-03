import 'package:bloc_widget/weather/bloc/weather_cubit.dart';
import 'package:bloc_widget/weather/bloc/weather_state.dart';
import 'package:bloc_widget/weather/models/current_weather.dart';
import 'package:bloc_widget/weather/models/weather_condition.dart';
import 'package:bloc_widget/weather/repository/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocSelector<WeatherCubit, WeatherState, CurrentWeather>(
              selector: (state) => state.weather.current,
              builder: (context, currentWeather) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(currentWeather.weatherCondition.imageAsset),
                        Text(currentWeather.temperature.toString()),
                      ],
                    ),
                    Text(currentWeather.weatherCondition.label),
                  ],
                );
              }
          )
        ),
      ),
    );
  }
}
