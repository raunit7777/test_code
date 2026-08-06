import '../../../core/network/api_clinet.dart'; // File path check kar lein (api_client.dart)
import '../../../core/network/api_endpoints.dart';
import '../../payment/model/paytm_init_request_model.dart';
import '../model/subcription_model.dart';



class SubcriptionRepository {
  final ApiClient _apiClient;

  SubcriptionRepository(this._apiClient);

  // ✅ ProfileModel2 return type & ProfileRepository name
  Future<SubcriptionModel> getSubcription() async {
    final response = await _apiClient.get(
      ApiEndpoints.subscriptionPlan,
    );
    return SubcriptionModel.fromJson(response.data);
  }
  Future<PaytmInitResponseModel> initiatePaytmPayment(
      PaytmInitRequestModel request) async {
    final response = await _apiClient.post(
      ApiEndpoints.subscriptionPlan,
      data: request.toJson(),
    );
    return PaytmInitResponseModel.fromJson(response.data);
  }


}