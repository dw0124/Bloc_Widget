import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_widget/timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {

  final Ticker _ticker;
  static const int _duration = 60;

  // _ticker를 구독하여 값을 얻기 위한 프로퍼티
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required ticker}) : _ticker = ticker, super(TimerInitial(_duration)) {

    on<TimerStarted>((event, emit) => _onStarted(event, emit));

    on<_TimerTicked>((event, emit) => _onTicked(event, emit));

    on<TimerResumed>((event, emit) => _onResume(event, emit));

    on<TimerPaused>(_onPaused);

    on<TimerReset>(_onReset);
  }

  // 타이머 시작 시 호출되는 메소드
  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();

    // ticker의 스트림을 구독하여 _TimerTicked 이벤트 호출
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) {
          // _TimerTicked 이벤트 호출
          add(_TimerTicked(duration: duration));
        }
    );
  }

  // _TimerTicked 이벤트가 호출되면 연결되는 메소드
  // duration이 0보다 크면 진행 상태, 아니면 완료 상태로 emit
  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0 ? TimerRunInProgress(event.duration) : TimerRunComplete()
    );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onResume(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();

    emit(TimerInitial(_duration));
  }
}