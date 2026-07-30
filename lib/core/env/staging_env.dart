

import 'env.dart';

class StagingEnv {
  static void setup() {
    AppEnv.setup(
      env: Environment.staging,
      baseUrl: 'https://staging.riderpe.com/api/',
      apiKey: 'staging_api_key_here',
    );
  }
}