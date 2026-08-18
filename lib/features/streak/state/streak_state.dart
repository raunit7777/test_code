import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/streak_model.dart';

class StreakState {
  final AsyncValue<StreakModel?> streak;
  final bool isSending;

  const StreakState({
    this.streak = const AsyncValue.data(null),
    this.isSending = false,
  });

  StreakState copyWith({
    AsyncValue<StreakModel?>? streak,
    bool? isSending,
  }) {
    return StreakState(
      streak: streak ?? this.streak,
      isSending: isSending ?? this.isSending,
    );
  }
}