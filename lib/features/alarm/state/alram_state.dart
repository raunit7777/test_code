import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/alram_model.dart'; // Adjust path

class AlarmState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final AsyncValue<AlarmModel?> alarmList;

  const AlarmState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.alarmList = const AsyncValue.loading(),
  });

  AlarmState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    AsyncValue<AlarmModel?>? alarmList,
  }) {
    return AlarmState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      alarmList: alarmList ?? this.alarmList,
    );
  }
}