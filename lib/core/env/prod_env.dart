
import 'env.dart';

class ProdEnv {
  static void setup() {
    AppEnv.setup(
      env: Environment.prod,
      baseUrl: 'https://admin.riderpe.com/api/',
      apiKey: 'prod_api_key_here',
    );
  }
}