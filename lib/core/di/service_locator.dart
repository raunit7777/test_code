import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:infinity_love/features/streak/repo/streak_repo.dart';

import '../../features/alarm/repo/alram_repo.dart';
import '../../features/auth/reposiotory/auth_repo.dart';
import '../../features/chat/repo/chat_repo.dart';
import '../../features/custmization/repo/customize_repo.dart';
import '../../features/describe_image/repo/subcription_model.dart';
import '../../features/home/home_repo/featuers_repo.dart';
import '../../features/profile/profile_repo/profile_repo.dart';
import '../network/api_clinet.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Global Navigator Key for Notification redirection
  final navigatorKey = GlobalKey<NavigatorState>();
  if (!sl.isRegistered<GlobalKey<NavigatorState>>()) {
    sl.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);
  }

  // 1. Dio Registration
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://your-api-base-url.com/', // Put your actual API Base URL string here
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
      return dio;
    });
  }

  // 2. Api Client Registration
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
  }

  // 3. Auth Repository Registration
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<ApiClient>()));

    if (!sl.isRegistered<ProfileRepository>()) {
      sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository(sl<ApiClient>()));
    }

    if (!sl.isRegistered<FeatuerRepository>()) {
      sl.registerLazySingleton<FeatuerRepository>(() => FeatuerRepository(sl<ApiClient>()));
    }
    if (!sl.isRegistered<ChatRepository>()) {
      sl.registerLazySingleton<ChatRepository>(() => ChatRepository(sl<ApiClient>()));
    }
    if (!sl.isRegistered<StreakRepository>()) {
      sl.registerLazySingleton<StreakRepository>(() => StreakRepository(sl<ApiClient>()));
    }


    if (!sl.isRegistered<CustomizeRepository>()) {
      sl.registerLazySingleton<CustomizeRepository>(() => CustomizeRepository(sl<ApiClient>()));
    }
    if (!sl.isRegistered<AlarmRepository>()) {
      sl.registerLazySingleton<AlarmRepository>(() => AlarmRepository(sl<ApiClient>()));
    }
    sl.registerLazySingleton<SubcriptionRepository>(
          () => SubcriptionRepository(sl<ApiClient>()),
    );

  }
}