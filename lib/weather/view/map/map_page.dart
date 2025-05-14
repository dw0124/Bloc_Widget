import 'package:bloc_widget/weather/models/weather.dart';
import 'package:bloc_widget/weather/repository/map_repository.dart';
import 'package:bloc_widget/weather/view/map/widgets/location_weather_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapPage extends StatefulWidget {

  final Weather weather;
  final double lng;
  final double lat;

  const MapPage({super.key, required this.weather, required this.lng, required this.lat});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Weather _weather;
  late double _lng;
  late double _lat;


  late NaverMapController _mapController;

  @override
  void initState() {
    super.initState();

    _weather = widget.weather;
    _lng = widget.lng;
    _lat = widget.lat;
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
                    (_weather, _lng, _lat)
                );
              },
          )
        ],
      ),
      body: NaverMap(
        options: const NaverMapViewOptions(),
        onMapReady: (controller) async {
          print("네이버 맵 로딩됨!");
          _mapController = controller;

          final (weather, locationAddress) = await context.read<MapRepository>()
              .fetchLocationInfo(widget.lng, widget.lat);

          final locationWeatherMarker = await NOverlayImage.fromWidget(
              widget: LocationWeatherMarker(
                  weather: weather.current,
                  locationAddress: locationAddress
              ),
              size: const Size(130, 140),
              context: context);

          final marker = NMarker(
              id: "icon_test",
              position: NLatLng(widget.lat, widget.lng),
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
          _lng = lng;
          _lat = lat;
        },
      ),
    );
  }
}