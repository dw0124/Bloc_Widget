import 'package:bloc_widget/weather/models/hourly_weather.dart';
import 'package:bloc_widget/weather/models/weather_condition.dart';
import 'package:flutter/material.dart';

class HourlyWeatherListItem extends StatelessWidget {
  final HourlyWeather hourlyWeather;

  final Color textColor;

  const HourlyWeatherListItem({super.key, required this.hourlyWeather, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: Column(
          //spacing: 9,
          children: [
            Text(
              hourlyWeather.dateTimeString,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Container(
              height: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    hourlyWeather.weatherCondition.imageAsset(
                      isNight: hourlyWeather.isNight
                    ),
                    width: 32,
                    height: 32,
                  ),
                  hourlyWeather.weatherCondition == WeatherCondition.rain ?
                  Text(
                    '${(hourlyWeather.pop * 100).toInt()}%',
                    style: TextStyle(fontSize: 12),
                  )
                      : SizedBox(width: 0)
                ],
              ),
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
      ),
    );
  }
}