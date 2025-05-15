import 'package:bloc_widget/counter/counter.dart';
import 'package:bloc_widget/timer/view/timer_app.dart';

import 'package:bloc_widget/weather/view/weather/weather_app.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('ko');
  await dotenv.load(fileName: ".env");

  await FlutterNaverMap().init(
      clientId: dotenv.env['NAVER_CLIENT_ID'],
      onAuthFailed: (ex) => switch (ex) {
        NQuotaExceededException(:final message) =>
            print("사용량 초과 (message: $message)"),
        NUnauthorizedClientException() ||
        NClientUnspecifiedException() ||
        NAnotherAuthFailedException() =>
            print("인증 실패: $ex"),
      });

  //runApp(const CounterApp());
  //runApp(const TimerApp());
  runApp(const WeatherApp());
}