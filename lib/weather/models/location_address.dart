import 'dart:convert';

class LocationAddress {
  final String? jsonString;

  final String area1;     // 시
  final String area2;     // 구
  final String area3;     // 동
  final double latitude;
  final double longitude;

  LocationAddress({
    required this.jsonString,
    required this.area1,
    required this.area2,
    required this.area3,
    required this.latitude,
    required this.longitude,
  });

  factory LocationAddress.fromJson(Map<String, dynamic> json, {required double? lat, required double? lng}) {
    try {
      final result = json['results'][0];
      final region = result['region'];

      final area1 = region['area1']['name'];
      final area2 = region['area2']['name'];
      final area3 = region['area3']['name'];

      if ((lat != null && lng == null) || (lat == null && lng != null)) {
        throw ArgumentError('lat과 lng는 함께 전달되어야 합니다.');
      }

      final latitude = lat ?? json['lat'];
      final longitude = lng ?? json['lng'];

      final jsonString = jsonEncode(json);

      return LocationAddress(
        jsonString: jsonString,
        area1: area1,
        area2: area2,
        area3: area3,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e, stacktrace) {
      // 에러 로그 출력
      print('LocationAddress.fromJson 에러: $e');
      print(stacktrace);

      return LocationAddress.empty;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
      'results': [
        {
          'region': {
            'area1': { 'name': area1 },
            'area2': { 'name': area2 },
            'area3': { 'name': area3 },
          }
        }
      ]
    };
  }

  LocationAddress copyWith({
    String? jsonString,
    String? area1,
    String? area2,
    String? area3,
    double? latitude,
    double? longitude,
  }) {
    return LocationAddress(
      jsonString: jsonString ?? this.jsonString,
      area1: area1 ?? this.area1,
      area2: area2 ?? this.area2,
      area3: area3 ?? this.area3,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  String toString() => '$area1 $area2 $area3 ($latitude, $longitude)';

  /// ✅ empty 생성자
  static LocationAddress get empty => LocationAddress(
    jsonString: null,
    area1: '서울특별시',
    area2: '',
    area3: '',
    latitude: 126.978388,
    longitude: 37.56661,
  );
}
