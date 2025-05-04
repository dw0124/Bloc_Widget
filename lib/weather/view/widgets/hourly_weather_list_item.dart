import 'package:bloc_widget/weather/models/hourly_weather.dart';
import 'package:bloc_widget/weather/models/weather_condition.dart';
import 'package:flutter/material.dart';

class HourlyWeatherListItem extends StatelessWidget {
  final HourlyWeather hourlyWeather;

  const HourlyWeatherListItem({super.key, required this.hourlyWeather});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Column(
        spacing: 9,
        children: [
          Text(
            hourlyWeather.dateTimeString,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Image.asset(
            hourlyWeather.weatherCondition.imageAsset,
            width: 32,
            height: 32,
          ),
          Text(
            '${hourlyWeather.temperature}°',
            style:
              TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
              ),
          ),
        ],
      ),
    );
  }
}