class Ticker {
  const Ticker();

  Stream<int> tick({required int ticks}) {
    // 1초 간격으로 값을 방출하는 Stream
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}