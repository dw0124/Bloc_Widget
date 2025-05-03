import 'package:bloc_widget/weather/bloc/weather_cubit.dart';
import 'package:bloc_widget/weather/repository/weather_repository.dart';
import 'package:bloc_widget/weather/view/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (_) => WeatherRepository(),
        dispose: (repository) => repository.dispose(),
        child: BlocProvider(
          create: (context) => WeatherCubit(context.read<WeatherRepository>()),
          child: WeatherPage(),
        ),
      ),
    );
  }
}