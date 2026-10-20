
import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../model/streak_model.dart';

class StreakRepository {
  final ApiClient _apiClient;

  StreakRepository(this._apiClient);

  Future<StreakModel> getStreak() async {
    final response = await _apiClient.get(
      ApiEndpoints.getStreak, // Adjust according to your ApiEndpoints class
    );
    return StreakModel.fromJson(response.data);
  }
  Future<dynamic> getClaimed() async {
    final response = await _apiClient.post(
      ApiEndpoints.streakClam, // Adjust according to your ApiEndpoints class
    );
    return response;
  }
  Future<dynamic> claimedReward(dynamic id) async {
    final response = await _apiClient.post(
      "${ApiEndpoints.mildStone}/$id/claim", // Adjust according to your ApiEndpoints class
    );
    return response;
  }
}