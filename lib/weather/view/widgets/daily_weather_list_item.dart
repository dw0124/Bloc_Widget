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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 24,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  dailyWeather.weekdayString,
                  style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(dailyWeather.formattedTime),
            ],
          ),
          SizedBox(
              width: 64,
              height: 64,
              child: Image.asset(dailyWeather.weatherCondition.imageAsset)
          ),
          Text(
              dailyWeather.weatherCondition.label,
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)
          ),
          Expanded(child: SizedBox()),
          Text(
              '${dailyWeather.minTemperature} / ${dailyWeather.maxTemperature}',
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)
            ),
        ],
      ),
    );
  }
}