import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/di/service_locator.dart';
import '../repo/streak_repo.dart';
import '../state/streak_state.dart';


final streakProvider = StateNotifierProvider<StreakNotifier, StreakState>((ref) {
  return StreakNotifier(sl<StreakRepository>());
});

class StreakNotifier extends StateNotifier<StreakState> {
  final StreakRepository _repository;

  StreakNotifier(this._repository) : super(const StreakState());

  // 🟢 Fetch Streak Data
  Future<void> fetchStreak() async {
    state = state.copyWith(streak: const AsyncValue.loading());
    try {
      final response = await _repository.getStreak();
      state = state.copyWith(streak: AsyncValue.data(response));
    } on DioException catch (e, stack) {
      String errorMessage = e.response?.data['message'] ??
          e.response?.data['msg'] ??
          e.message ??
          'Network error';
      state = state.copyWith(
        streak: AsyncValue.error(Exception(errorMessage), stack),
      );
    } catch (e, stack) {
      state = state.copyWith(
        streak: AsyncValue.error(e, stack),
      );
    }
  }

  Future<bool> claimStreak() async {
    try {
      await _repository.getClaimed();
      await fetchStreak(); // Refetch updated values from backend
      return true;
    } catch (e) {
      debugPrint("Claim failed: $e");
      return false;
    }
  }
  Future<bool> claimReward(dynamic id) async {
    try {
      await _repository.claimedReward(id);
      await fetchStreak(); // Refetch updated values from backend
      return true;
    } catch (e) {
      debugPrint("Claim failed: $e");
      return false;
    }
  }
}