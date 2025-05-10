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
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Column(
          spacing: 9,
          children: [
            Text(
              hourlyWeather.dateTimeString,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    hourlyWeather.weatherCondition.imageAsset(
                        dateTime: hourlyWeather.epochTime,
                        sunrise: hourlyWeather.sunrise,
                        sunset: hourlyWeather.sunset
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
            Expanded(child: SizedBox()),
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