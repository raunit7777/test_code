// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import '../../../../core/di/service_locator.dart';
// import '../repo/alram_repo.dart';
// import '../state/alram_state.dart'; // Adjust path
//
//
// // ✅ Main Alarm Provider
// final alarmProvider =
// StateNotifierProvider<AlarmNotifier, AlarmState>((ref) {
//   return AlarmNotifier(sl<AlarmRepository>());
// });
//
// class AlarmNotifier extends StateNotifier<AlarmState> {
//   final AlarmRepository _repository;
//
//   AlarmNotifier(this._repository) : super(const AlarmState());
//
//   // 1️⃣ Fetch Alarms List Method
//   Future<void> fetchAlarms({int page = 1, int limit = 10}) async {
//     state = state.copyWith(alarmList: const AsyncValue.loading());
//     try {
//       final response = await _repository.getAlarms(page: page, limit: limit);
//       state = state.copyWith(alarmList: AsyncValue.data(response));
//     } catch (e, stack) {
//       state = state.copyWith(alarmList: AsyncValue.error(e, stack));
//     }
//   }
//
//   // 2️⃣ Create New Alarm Method
//   Future<bool> createAlarm({
//     required List<String> days,
//     required String time,
//     required String message,
//     String timezone = 'Asia/Kolkata',
//   }) async {
//     state = state.copyWith(isLoading: true, error: null);
//
//     final Map<String, dynamic> body = {
//       'days': days,
//       'time': time,
//       'message': message,
//       'timezone': timezone,
//     };
//
//     try {
//       final response = await _repository.setAlarm(body);
//
//       state = state.copyWith(isLoading: false);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Refresh alarms list after creating a new alarm
//         await fetchAlarms();
//         return true;
//       }
//       return false;
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//       return false;
//     }
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/di/service_locator.dart';
import '../repo/alram_repo.dart';
import '../state/alram_state.dart';


final alarmProvider =
StateNotifierProvider<AlarmNotifier, AlarmState>((ref) {
  return AlarmNotifier(sl<AlarmRepository>());
});

class AlarmNotifier extends StateNotifier<AlarmState> {
  final AlarmRepository _repository;

  AlarmNotifier(this._repository) : super(const AlarmState());

  // 1️⃣ Fetch Alarms
  Future<void> fetchAlarms({int page = 1, int limit = 10}) async {
    state = state.copyWith(alarmList: const AsyncValue.loading());
    try {
      final response = await _repository.getAlarms(page: page, limit: limit);
      state = state.copyWith(alarmList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(alarmList: AsyncValue.error(e, stack));
    }
  }

  // 2️⃣ Create Alarm
  Future<bool> createAlarm({
    required List<String> days,
    required String time,
    required String message,
    required String modelId,
    String timezone = 'Asia/Kolkata',
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final Map<String, dynamic> body = {
      'days': days,
      'time': time,
      'message': message,
      'timezone': timezone,
      'modalId': modelId,
    };

    try {
      final response = await _repository.setAlarm(body);
      state = state.copyWith(isLoading: false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAlarms();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 3️⃣ Toggle Alarm Status
  Future<bool> toggleAlarmStatus(String alarmId) async {
    try {
      final response = await _repository.toggleAlarm(alarmId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAlarms(); // List refresh after toggle
        return true;
      }
      return false;
    } catch (e) {
      print('Error in toggleAlarmStatus: $e');
      return false;
    }
  }

  // 4️⃣ Delete Alarm
  Future<bool> removeAlarm(String alarmId) async {
    try {
      final response = await _repository.deleteAlarm(alarmId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAlarms(); // List refresh after delete
        return true;
      }
      return false;
    } catch (e) {
      print('Error in removeAlarm: $e');
      return false;
    }
  }
}