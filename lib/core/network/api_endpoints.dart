class ApiEndpoints {
  static var baseUrl = "https://infinitelove.honeywithmoon.com/";
  static var verifyUrl = "${baseUrl}api/";
  static var login = "${verifyUrl}dileverylogin";
  static var sendOtp = "${verifyUrl}v1/auth/send-otp";
  static var verifyOtp = "${verifyUrl}verify-otp";
  static var vehicleList = "${verifyUrl}vehicle-list";
  static var cityZoneList = "${verifyUrl}cityzone_lists";
}