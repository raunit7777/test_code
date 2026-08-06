import '../../../core/network/api_clinet.dart'; // File path check kar lein (api_client.dart)
import '../../../core/network/api_endpoints.dart';
import '../profile_model/profile_model.dart'; // Local ProfileModel2 import

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  // ✅ ProfileModel2 return type & ProfileRepository name
  Future<ProfileModel2> getProfile() async {
    final response = await _apiClient.get(
      ApiEndpoints.profile,
    );
    return ProfileModel2.fromJson(response.data);
  }
}