class LocationAddress {
  final String area1;     // 시
  final String area2;     // 구
  final String area3;     // 동
  final double latitude;
  final double longitude;

  LocationAddress({
    required this.area1,
    required this.area2,
    required this.area3,
    required this.latitude,
    required this.longitude,
  });

  factory LocationAddress.fromJson(Map<String, dynamic> json) {
    try {
      final result = json['results'][0];
      final region = result['region'];
      final area3Coords = region['area3']['coords']['center'];

      final area1 = region['area1']['name'];
      final area2 = region['area2']['name'];
      final area3 = region['area3']['name'];

      final latitude = area3Coords['y'].toDouble();
      final longitude = area3Coords['x'].toDouble();

      return LocationAddress(
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

  LocationAddress copyWith({
    String? area1,
    String? area2,
    String? area3,
    double? latitude,
    double? longitude,
  }) {
    return LocationAddress(
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
    area1: '서울특별시',
    area2: '',
    area3: '',
    latitude: 126.978388,
    longitude: 37.56661,
  );
}
