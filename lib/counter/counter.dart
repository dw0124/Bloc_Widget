import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_widget/counter/counter_bloc.dart';

class CounterApp extends MaterialApp {
  const CounterApp({super.key}) : super(home: const CounterPage());
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider를 사용해 CounterBloc을 생성하고, 이를 CounterView에 전달
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // 상위 위젯트리에서 전달받은 CounterBloc을 BlocBuilder를 통해 UI에 연결
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$state', // 현재 CounterBloc의 상태(state)를 표시
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.add),
            onPressed:
                // context를 통해 상위 위젯트리에서 CounterBloc을 찾아
                // CounterIncrementPressed 이벤트를 추가하여 상태(state)를 증가시킴
                () => context.read<CounterBloc>().add(CounterIncrementPressed()),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            key: const Key('counterView_decrement_floatingActionButton'),
            child: const Icon(Icons.remove),
            onPressed:
                () => context.read<CounterBloc>().add(CounterDecrementPressed()),
          ),
        ],
      ),
    );
  }
}
