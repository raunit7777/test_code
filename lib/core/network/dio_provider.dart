import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../di/service_locator.dart';
import 'api_clinet.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  return sl<Dio>();
}

@riverpod
ApiClient apiClient(Ref ref) {
  return sl<ApiClient>();
}