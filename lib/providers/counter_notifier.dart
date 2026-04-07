import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_notifier.g.dart';

/// カウントの増減（0 未満にはしない）。
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() => 0;

  void increment() => state = state + 1;

  void decrement() {
    if (state > 0) state = state - 1;
  }
}
