class ApiEndpoints {
  static var baseUrl = "https://root.infiniteloved.com/";
  static var verifyUrl = "${baseUrl}api/";
  static var login = "${verifyUrl}dileverylogin";
  static var sendOtp = "${verifyUrl}v1/auth/send-otp";
  static var verifyOtp = "${verifyUrl}v1/auth/verify-otp";
  static var profile = "${verifyUrl}v1/users/profile";
  static var modelList = "${verifyUrl}v1/characters?page=1&limit=20";
  static var modelDetails = "${verifyUrl}v1/characters/";
  static var chatInti = "${verifyUrl}v1/chat/init/character";
  static var sendMsg = "${verifyUrl}v1/chat/character";
  static var refreshToken = "${verifyUrl}v1/auth/refresh";
  static var roleModelList = "${verifyUrl}v1/roleplays?page=1&limit=20";
  static var roleModelDetails = "${verifyUrl}v1/roleplays";
  static var startRolePlayChatInit = "${verifyUrl}v1/chat/init/roleplay";
  static var chatRolePlaySendMsg = "${verifyUrl}v1/chat/roleplay";
  static var createModel = "${verifyUrl}v1/companions";
  static var conversationList = "${verifyUrl}v1/conversations";
  static var subscriptionPlan = "${verifyUrl}v1/subscription/plans";
  static var paymentInit = "${verifyUrl}v1/payment/initiate";
  static var companionChatInit = "${verifyUrl}v1/chat/init/companion";
  static var companionSendMsg = "${verifyUrl}v1/chat/message/";
  static var paymentVerify = "${verifyUrl}v1/payment/verify";
  static var purchaseSubcription = "${verifyUrl}v1/subscription/purchase";
  static var allPolicy = "${verifyUrl}/v1/pages/admin/all";
  static var vibeList = "${verifyUrl}v1/vibes?";
  static var getStreak = "${verifyUrl}v1/streaks";
  static var streakClam = "${verifyUrl}v1/streaks/claim";
  static var getVideDetails = "${verifyUrl}v1/character-traits/";
  static var vibeUpdate = "${verifyUrl}v1/character-traits";
  static var setAlarm = "${verifyUrl}v1/alarm-notifications";
  static var getAlarm = "${verifyUrl}v1/alarm-notifications?";
  static var deleteAlarm = "${verifyUrl}v1/alarm-notifications/";

  static var toggleAlarm = "${verifyUrl}v1/alarm-notifications/";
  static var availablePayment = "${verifyUrl}v1/payment/gateways";
  static var deleteChat = "${verifyUrl}v1/conversations/delete-all";
  static var deleteChatParticular = "${verifyUrl}v1/conversations";
  static var mildStone = "${verifyUrl}v1/streaks/milestones";
  static var relationshipType = "${verifyUrl}v1/relationship-types";
  static var onBoardingModels = "${verifyUrl}v1/onboarding-modals";


  // static var vehicleList = "${verifyUrl}vehicle-list";
  // static var cityZoneList = "${verifyUrl}cityzone_lists";
}