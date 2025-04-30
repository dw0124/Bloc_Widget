import 'package:bloc_widget/counter/counter.dart';
import 'package:bloc_widget/timer/view/timer_app.dart';
import 'package:bloc_widget/weather/view/weather_app.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('ko');
  await dotenv.load(fileName: ".env");
  //runApp(const CounterApp());
  //runApp(const TimerApp());
  runApp(const WeatherApp());
}