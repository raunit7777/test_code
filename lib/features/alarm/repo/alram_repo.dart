// import 'package:dio/dio.dart';
// import '../../../core/network/api_clinet.dart';
// import '../../../core/network/api_endpoints.dart'; // Adjust path
// import '../model/alram_model.dart';
//
// class AlarmRepository {
//   final ApiClient _apiClient;
//
//   AlarmRepository(this._apiClient);
//
//   // 1️⃣ GET ALARMS API
//   Future<AlarmModel> getAlarms({int page = 1, int limit = 10}) async {
//     final String fullUrl = '${ApiEndpoints.getAlarm}?page=$page&limit=$limit';
//
//     print('================ 🚀 [GET ALARMS STARTED] ================');
//     print('👉 Target URL: $fullUrl');
//
//     try {
//       final response = await _apiClient.get(fullUrl);
//       print('✅ Alarms Fetched Successfully!');
//       return AlarmModel.fromJson(response.data);
//     } catch (e, stackTrace) {
//       print('❌ [ERROR] Exception in getAlarms(): $e');
//       print('🚨 [TRACE] Stack Trace: $stackTrace');
//       rethrow;
//     }
//   }
//
//   // 2️⃣ SET ALARM API
//   Future<Response> setAlarm(Map<String, dynamic> data) async {
//     final String fullUrl = ApiEndpoints.setAlarm;
//
//     print('================ 🚀 [SET ALARM STARTED] ================');
//     print('👉 Target URL: $fullUrl');
//     print('📦 Request Body: $data');
//
//     try {
//       final response = await _apiClient.post(
//         fullUrl,
//         data: data,
//       );
//       print('✅ Alarm Set Successfully!');
//       return response;
//     } catch (e, stackTrace) {
//       print('❌ [ERROR] Exception in setAlarm(): $e');
//       print('🚨 [TRACE] Stack Trace: $stackTrace');
//       rethrow;
//     }
//   }
// }

import 'package:dio/dio.dart';
import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/alram_model.dart';

class AlarmRepository {
  final ApiClient _apiClient;

  AlarmRepository(this._apiClient);

  // 1️⃣ GET ALARMS
  Future<AlarmModel> getAlarms({int page = 1, int limit = 10}) async {
    final String fullUrl = '${ApiEndpoints.getAlarm}?page=$page&limit=$limit';

    try {
      final response = await _apiClient.get(fullUrl);
      return AlarmModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // 2️⃣ SET ALARM (POST)
  Future<Response> setAlarm(Map<String, dynamic> data) async {
    final String fullUrl = ApiEndpoints.setAlarm;

    try {
      final response = await _apiClient.post(
        fullUrl,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // 3️⃣ TOGGLE ALARM STATUS (PATCH / PUT / POST)
  Future<Response> toggleAlarm(String id) async {
    final String fullUrl = '${ApiEndpoints.toggleAlarm}$id/toggle';

    print('================ 🚀 [TOGGLE ALARM STARTED] ================');
    print('👉 Target URL: $fullUrl');

    try {
      final response = await _apiClient.patch(fullUrl);
      print('✅ Alarm Toggled Successfully!');
      return response;
    } catch (e) {
      print('❌ Error toggling alarm: $e');
      rethrow;
    }
  }

  // 4️⃣ DELETE ALARM
  Future<Response> deleteAlarm(String id) async {
    final String fullUrl = '${ApiEndpoints.deleteAlarm}$id';

    print('================ 🚀 [DELETE ALARM STARTED] ================');
    print('👉 Target URL: $fullUrl');

    try {
      final response = await _apiClient.delete(fullUrl);
      print('✅ Alarm Deleted Successfully!');
      return response;
    } catch (e) {
      print('❌ Error deleting alarm: $e');
      rethrow;
    }
  }
}