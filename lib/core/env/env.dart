enum Environment { dev, staging, prod }

abstract class AppEnv {
  static late Environment environment;
  static late String baseUrl;
  static late String apiKey;

  static void setup({
    required Environment env,
    required String baseUrl,
    required String apiKey,
  }) {
    AppEnv.environment = env;
    AppEnv.baseUrl = baseUrl;
    AppEnv.apiKey = apiKey;
  }

  static bool get isDev => environment == Environment.dev;
  static bool get isStaging => environment == Environment.staging;
  static bool get isProd => environment == Environment.prod;
}