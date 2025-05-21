import 'package:bloc_widget/weather/models/daily_weather.dart';
import 'package:bloc_widget/weather/models/weather_condition.dart';
import 'package:flutter/material.dart';

class DailyWeatherListItem extends StatelessWidget {
  final DailyWeather dailyWeather;

  const DailyWeatherListItem({super.key, required this.dailyWeather});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 64,
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24,
          children: [
            SizedBox(
              width: 34,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dailyWeather.weekdayString,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    dailyWeather.formattedTime,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
            Container(
                height: 64,
                //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        dailyWeather.weatherCondition.imageAsset(),
                        fit: BoxFit.contain,
                        width: 32,
                        height: 32,
                      ),

                      dailyWeather.weatherCondition == WeatherCondition.rain ?
                      Text(
                          '${(dailyWeather.pop * 100).toInt()}%',
                          style: TextStyle(fontSize: 12),

                      )
                          : SizedBox(width: 0,)
                    ]
                )
            ),
            Text(
                dailyWeather.weatherCondition.label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            Expanded(child: SizedBox()),
            Text(
                '${dailyWeather.minTemperature} / ${dailyWeather.maxTemperature}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
          ],
        ),
      ),
    );
  }
}