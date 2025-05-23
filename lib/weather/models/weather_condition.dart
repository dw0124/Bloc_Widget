enum WeatherCondition {
  clear,
  clouds,
  rain,
  snow,
  thunderstorm,
  drizzle,
  atmosphere,
  unknown,
}

extension WeatherConditionX on WeatherCondition {
  static WeatherCondition fromWeatherCode(int code) {
    if (code >= 200 && code < 300) {
      return WeatherCondition.thunderstorm;
    } else if (code >= 300 && code < 400) {
      return WeatherCondition.drizzle;
    } else if (code >= 500 && code < 600) {
      return WeatherCondition.rain;
    } else if (code >= 600 && code < 700) {
      return WeatherCondition.snow;
    } else if (code >= 700 && code < 800) {
      return WeatherCondition.atmosphere;
    } else if (code == 800) {
      return WeatherCondition.clear;
    } else if (code >= 801 && code < 900) {
      return WeatherCondition.clouds;
    } else {
      return WeatherCondition.unknown;
    }
  }

  int toWeatherCode() {
    switch (this) {
      case WeatherCondition.thunderstorm:
        return 200; // 대표 코드
      case WeatherCondition.drizzle:
        return 300;
      case WeatherCondition.rain:
        return 500;
      case WeatherCondition.snow:
        return 600;
      case WeatherCondition.atmosphere:
        return 701;
      case WeatherCondition.clear:
        return 800;
      case WeatherCondition.clouds:
        return 801;
      case WeatherCondition.unknown:
        return 0;
    }
  }

  /// 날씨 이미지 경로
  String imageAsset({bool isNight = false}) {
    if(this == WeatherCondition.clear && isNight == true) {
      return 'assets/weather_icon/moon.fill.png';
    } else if (this == WeatherCondition.clear && isNight == false) {
      return 'assets/weather_icon/clear.png';
    }

    switch (this) {
      case WeatherCondition.clear:
        return 'assets/weather_icon/clear.png';
      case WeatherCondition.clouds:
        return 'assets/weather_icon/clouds.png';
      case WeatherCondition.rain:
        return 'assets/weather_icon/rain.png';
      case WeatherCondition.snow:
        return 'assets/weather_icon/snow.png';
      case WeatherCondition.thunderstorm:
        return 'assets/weather_icon/thunderstorm.png';
      case WeatherCondition.drizzle:
        return 'assets/weather_icon/rain.png';
      case WeatherCondition.atmosphere:
        return 'assets/weather_icon/atmosphere.png';
      default:
        return 'assets/weather_icon/unknown.png';
    }
  }

  /// 날씨 텍스트
  String get label {
    switch (this) {
      case WeatherCondition.clear:
        return '맑음';
      case WeatherCondition.clouds:
        return '흐림';
      case WeatherCondition.rain:
        return '비';
      case WeatherCondition.snow:
        return '눈';
      case WeatherCondition.thunderstorm:
        return '천둥';
      case WeatherCondition.drizzle:
        return '이슬비';
      case WeatherCondition.atmosphere:
        return '안개';
      default:
        return '알 수 없음';
    }
  }
}