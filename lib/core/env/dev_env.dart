
import 'env.dart';

class DevEnv {
  static void setup() {
    AppEnv.setup(
      env: Environment.dev,
      baseUrl: 'https://admin.riderpe.com/api/',
      apiKey: 'dev_api_key_here',
    );
  }
}