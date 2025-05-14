import 'package:bloc_widget/weather/models/current_weather.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/models/weather_condition.dart';
import 'package:flutter/material.dart';

class LocationWeatherMarker extends StatelessWidget {
  final CurrentWeather weather;
  final LocationAddress locationAddress;

  LocationWeatherMarker({super.key, required this.weather, required this.locationAddress}) {
    print('${weather.temperature}, ${locationAddress.area3}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 125,
            width: 120,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.7),
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                  offset: const Offset(0,7),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                    '${locationAddress.area1}',
                    style: TextStyle(fontSize: 12, color: Colors.black)
                ),
                Text(
                    '${locationAddress.area3}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black)
                ),

                Expanded(child: SizedBox()),

                Text(
                    '${weather.temperature}°',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                Text(
                    '${weather.weatherCondition.label}',
                    style: TextStyle(fontSize: 18, color: Colors.black)
                )
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}