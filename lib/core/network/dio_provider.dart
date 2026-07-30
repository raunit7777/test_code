import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/service_locator.dart';
import 'api_clinet.dart';


@riverpod
Dio dio(Ref ref) {
  return sl<Dio>();
}

@riverpod
ApiClient apiClient(Ref ref) {
  return sl<ApiClient>();
}