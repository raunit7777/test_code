import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import '../network/api_endpoints.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Global Navigator Key for Notification redirection
  final navigatorKey = GlobalKey<NavigatorState>();
  sl.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);

  // Services
  // sl.registerLazySingleton<HiveService>(() => HiveService());
  // sl.registerLazySingleton<SecureStorageServices>(() => SecureStorageServices());
  // sl.registerLazySingleton<NotificationService>(() => NotificationService(navigatorKey: sl()));

  // sl.registerLazySingleton<Dio>(() => Dio(
  //   BaseOptions(
  //     baseUrl: ApiEndpoints,
  //     connectTimeout: const Duration(seconds: 30),
  //     receiveTimeout: const Duration(seconds: 30),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //     },
  //   ),
  // )..interceptors.addAll([
  //   ApiInterceptor(),
  //   LogInterceptor(
  //     requestBody: true,
  //     responseBody: true,
  //   ),
  // ]));

  // // Api Client
  // sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));
  //
  // // Repositories
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));
  // sl.registerLazySingleton<HomeRepository>(() => HomeRepository(sl()));
}