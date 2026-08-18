class AppStrings {
  // Common / General
  static const String appName = "Infinity Love";
  static const String resendCodeIn = "Resend code in 00:";
  static const String countryCodeIndia = "🇮🇳 +91";
  static const String countryPrefix = "+91";

  // Login Screen
  static const String enterPhoneNumberTitle = "Enter Phone Number";
  static const String loginSubtitle = "We will send you a 6-digit verification code to login.";
  static const String phoneNumberLabel = "Phone Number";
  static const String phoneHint = "Enter 10 digit number";
  static const String sendOtpBtn = "Send OTP";
  static const String termsDisclaimer = "By continuing, you agree to our Terms of Service and Privacy Policy.";

  // OTP Screen
  static const String verifyOtpTitle = "Verify OTP";
  static const String codeSentTo = "Code has been sent to ";
  static const String verifyCodeBtn = "Verify Code";
  static const String didntReceiveCode = "Didn't receive code? ";
  static const String resendCode = "Resend Code";
  static const String defaultPhoneNumber = "+91 98765 43210";

  // Error Messages
  static const String enterValidPhone = "Please enter a valid 10-digit phone number";
  static const String enterCompleteOtp = "Please enter complete 6-digit OTP";
  static const int phoneLength = 10;
  static const int otpLength = 6;

  // Profiles Grid Screen Strings
  static const String headerInfinite = "Infinite ";
  static const String headerLove = "Loved";
  static const String defaultStreakCount = "0";
  static const String flameEmoji = "🔥";
  static const String failedToLoadProfiles = "Failed to load profiles";
  static const String retry = "Retry";
  static const String noProfilesAvailable = "No profiles available";
  static const String defaultUnknown = "Unknown";
  static const String defaultNotAvailable = "N/A";

  // 🟢 Daily Streak Screen Strings (Added)
  static const String dailyStreakTitle = "Daily Streak";
  static const String dayStreakLabel = "DAY STREAK";
  static const String claimRewardBtn = "CLAIM REWARD";
  static const String nextClaimInLabel = "Next claim in";
  static const String milestoneRewardsHeader = "Milestone Rewards";
  static const String statusClaimed = "Claimed";
  static const String statusClaim = "CLAIM";
  static const String statusLocked = "Locked";

  // Dynamic Helpers / Rewards
  static const String rewardUnlockCharacter = "Unlock Special Character";
  static const String rewardUnlockRoleplay = "Unlock Roleplay Feature";
  static const String msgDailyStreakClaimed = "Daily Streak Reward Claimed! 🎉";
  static const String msgFailedToClaimStreak = "Failed to claim streak: ";
  static const String msgFailedToClaimMilestone = "Failed to claim milestone: ";

  static String bestStreakText(int days) => "Best Streak: $days days";
  static String dayRewardText(int day) => "Day $day Reward";
  static String dayLabel(int day) => "Day $day";
  static String milestoneUnlockedMsg(int day) => "Day $day Milestone Reward Unlocked! 🎉";
}