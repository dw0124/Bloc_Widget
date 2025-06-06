import 'package:bloc_widget/weather/bloc/map_cubit.dart';
import 'package:bloc_widget/weather/bloc/map_state.dart';
import 'package:bloc_widget/weather/view/map/widgets/location_weather_marker.dart';
import 'package:bloc_widget/weather/view/weather/widgets/hourly_weather_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  late NaverMapController _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent.withValues(alpha: 0),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
            ),
            onPressed: () {
              Navigator.pop(
                  context,
                  (
                    context.read<MapCubit>().state.weather,
                    context.read<MapCubit>().state.locationAddress
                  )
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(
                        context.read<MapCubit>().state.locationAddress.latitude,
                        context.read<MapCubit>().state.locationAddress.longitude
                    ),
                    zoom: 15
                  )
                ),
                onMapReady: (controller) async {
                  _mapController = controller;

                  final weather = context.read<MapCubit>().state.weather;
                  final locationAddress = context.read<MapCubit>().state.locationAddress;
                  final lng = locationAddress.longitude;
                  final lat = locationAddress.latitude;

                  final locationWeatherMarker = await NOverlayImage.fromWidget(
                      widget: LocationWeatherMarker(
                          weather: weather.current,
                          locationAddress: locationAddress
                      ),
                      size: const Size(130, 140),
                      context: context);

                  final marker = NMarker(
                      id: "icon_test",
                      position: NLatLng(lat, lng),
                      icon: locationWeatherMarker
                  );

                  _mapController.addOverlay(marker);
                },
                onMapTapped: (point, latLng) async {
                    final lat = latLng.latitude;
                    final lng = latLng.longitude;

                    await context.read<MapCubit>().fetchWeather(lng, lat);

                    final state = context.read<MapCubit>().state;
                    final weather = state.weather;
                    final locationAddress = state.locationAddress;

                    final locationWeatherMarker = await NOverlayImage.fromWidget(
                        widget: LocationWeatherMarker(
                            weather: weather.current,
                            locationAddress: locationAddress
                        ),
                        size: const Size(130, 140),
                        context: context
                    );

                    final marker = NMarker(
                        id: "icon_test",
                        position: latLng,
                        icon: locationWeatherMarker
                    );

                    _mapController.addOverlay(marker);

                    // 카메라 업데이트
                    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
                      target: NLatLng(lat, lng),
                    );

                    _mapController.updateCamera(cameraUpdate);
                  },
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                          height: 32,
                            child: BlocBuilder<MapCubit, MapState>(
                              builder: (context, state) {
                                return Text(
                                  '${state.locationAddress.area1} ${state.locationAddress
                                      .area2} ${state.locationAddress.area3}',
                                  style: TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            )
                        ),
                        Divider(),
                        Container(
                            height: 112,
                            child: BlocBuilder<MapCubit, MapState>(
                              builder: (context, state) {
                                return ListView.separated(
                                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    itemCount: state.weather.hourly.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return HourlyWeatherListItem(
                                        key: ValueKey(state.weather.hourly[index].epochTime),
                                        hourlyWeather: state.weather.hourly[index],
                                        textColor: Colors.black,
                                      );
                                    }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: 16)
                                );
                              }
                            )
                        ),
                      ],
                    ),
                  ),
                )
            ]
          ),
        ),
      ),
    );
  }
}