import 'package:bloc_widget/weather/bloc/map_cubit.dart';
import 'package:bloc_widget/weather/bloc/weather_cubit.dart';
import 'package:bloc_widget/weather/bloc/weather_state.dart';
import 'package:bloc_widget/weather/models/current_weather.dart';
import 'package:bloc_widget/weather/models/daily_weather.dart';
import 'package:bloc_widget/weather/models/hourly_weather.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/models/weather_condition.dart';
import 'package:bloc_widget/weather/repository/map_repository.dart';
import 'package:bloc_widget/weather/view/map/map_page.dart';
import 'package:bloc_widget/weather/view/weather/widgets/daily_weather_list_item.dart';
import 'package:bloc_widget/weather/view/weather/widgets/hourly_weather_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.map_outlined),
          onPressed: () async {
              final weather = context.read<WeatherCubit>().state.weather;
              final locationAddress = context.read<WeatherCubit>().state.locationAddress;

              final result = await Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) =>
                      RepositoryProvider(
                        create: (context) => MapRepository(),
                        dispose: (repository) => repository.dispose(),
                        child: BlocProvider<MapCubit>(
                          create: (BuildContext context) => MapCubit(
                            context.read<MapRepository>(),
                            weather,
                            locationAddress,
                          ),
                          child: MapPage(),
                        ),
                      ),
                ),
              );

              if (result != null && context.mounted) {
                final (weather, locationAddress) = result as (Weather, LocationAddress);

                context.read<WeatherCubit>().updateWeather(weather, locationAddress);
              }
            },
        ),
      ),
      backgroundColor: switch(context.watch<WeatherCubit>().state.weather.current.weatherCondition) {
        WeatherCondition.clear =>
        context.read<WeatherCubit>().state.weather.current.isNight
            ? const Color(0xFF22375A)
            : const Color(0xFF1475D1),
        WeatherCondition.clouds => const Color(0xFF56595E),
        WeatherCondition.atmosphere => const Color(0xFF899499),
        WeatherCondition.rain => const Color(0xE0105BA5),
        WeatherCondition.thunderstorm => const Color(0xFF616161),
        _ => const Color(0xFF90CAF9),
      },
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<WeatherCubit, WeatherState>(
                    builder: (context, state) {
                      return
                        DefaultTextStyle(
                            style: TextStyle(color: Colors.white),
                            child: Column(
                              children: [
                                Text(state.locationAddress.area3),
                              ],
                            )
                        );
                    }
                ),
                BlocSelector<WeatherCubit, WeatherState, CurrentWeather>(
                    selector: (state) => state.weather.current,
                    builder: (context, currentWeather) {
                      return Column(
                        children: [
                          DefaultTextStyle(
                            style: TextStyle(color: Colors.white),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${currentWeather.temperature.toString()}°',
                                  style: TextStyle(fontSize: 64.0, fontWeight: FontWeight.w300),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -5),
                                  child: Text(
                                    currentWeather.weatherCondition.label,
                                    style: TextStyle(fontSize: 24.0),
                                  )
                                ),
                                Transform.translate(
                                  offset: Offset(0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('최고: ${context.read<WeatherCubit>().state.weather.daily[0].minTemperature}°'),
                                      Text('최저: ${context.read<WeatherCubit>().state.weather.daily[0].maxTemperature}°'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                ),

                SizedBox(height: 30,),

                Container(
                  alignment: Alignment.center,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: BlocSelector<WeatherCubit, WeatherState, List<HourlyWeather>>(
                      selector: (state) => state.weather.hourly,
                      builder: (context, hourlyWeather) {
                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          itemCount: hourlyWeather.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return HourlyWeatherListItem(
                              key: ValueKey(hourlyWeather[index].epochTime),
                              hourlyWeather: hourlyWeather[index],
                            );
                          }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: 16)
                        );
                      }
                  ),
                ),

                SizedBox(height: 12,),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: BlocSelector<WeatherCubit, WeatherState, List<DailyWeather>>(
                      selector: (state) => state.weather.daily,
                      builder: (context, dailyWeather) {
                        return ListView.separated(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            itemCount: dailyWeather.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return DailyWeatherListItem(
                                key: ValueKey(dailyWeather[index].epochTime),
                                // 고유한 키 사용
                                dailyWeather: dailyWeather[index],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) => Divider(
                              color: Colors.white.withValues(alpha: 0.3),
                              height: 1,
                            ),);
                      }
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
