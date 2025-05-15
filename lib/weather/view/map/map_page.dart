import 'package:bloc_widget/weather/bloc/weather_cubit.dart';
import 'package:bloc_widget/weather/bloc/weather_state.dart';
import 'package:bloc_widget/weather/models/hourly_weather.dart';
import 'package:bloc_widget/weather/models/location_address.dart';
import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/repository/map_repository.dart';
import 'package:bloc_widget/weather/view/map/widgets/location_weather_marker.dart';
import 'package:bloc_widget/weather/view/weather/widgets/hourly_weather_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapPage extends StatefulWidget {

  final Weather weather;
  final LocationAddress locationAddress;

  const MapPage({super.key, required this.weather, required this.locationAddress});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Weather _weather;
  late LocationAddress _locationAddress;
  late NaverMapController _mapController;

  @override
  void initState() {
    super.initState();

    _weather = widget.weather;
    _locationAddress = widget.locationAddress;
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
          TextButton(
              child: Text('적용'),
              onPressed: () {
                Navigator.pop(
                    context,
                    (_weather, _locationAddress)
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
                    target: NLatLng(_locationAddress.latitude, _locationAddress.longitude),
                    zoom: 15
                  )
                ),
                onMapReady: (controller) async {
                  _mapController = controller;

                  final lng = _locationAddress.longitude;
                  final lat = _locationAddress.latitude;

                  final locationWeatherMarker = await NOverlayImage.fromWidget(
                      widget: LocationWeatherMarker(
                          weather: _weather.current,
                          locationAddress: _locationAddress
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

                    final (weather, locationAddress) = await context.read<MapRepository>()
                        .fetchLocationInfo(lng, lat);

                    final locationWeatherMarker = await NOverlayImage.fromWidget(
                        widget: LocationWeatherMarker(
                            weather: weather.current,
                            locationAddress: locationAddress
                        ),
                        size: const Size(130, 140),
                        context: context);

                    final marker = NMarker(
                        id: "icon_test",
                        position: latLng,
                        icon: locationWeatherMarker
                    );

                    _mapController.addOverlay(marker);

                    _weather = weather;
                    _locationAddress = locationAddress;

                    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
                      target: NLatLng(lat, lng),
                    );

                    _mapController.updateCamera(cameraUpdate);
                  },
                ),

                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 0,
                  child: Container(
                    color: Colors.blue,
                      height: 120,
                      child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          itemCount: _weather.hourly.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return HourlyWeatherListItem(
                              key: ValueKey(_weather.hourly[index].epochTime),
                              hourlyWeather: _weather.hourly[index],
                            );
                          }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: 16)
                      )
                  ),
                )
            ]
          ),
        ),
      ),
    );
  }
}