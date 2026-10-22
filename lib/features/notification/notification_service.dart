import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../firebase_options.dart';
import '../../routes/app_routes.dart';
import '../chat/provider/chat_provider.dart';

// 🔔 Top-Level Background Handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    debugPrint("📦 [BACKGROUND DATA]: ${message.data}");
  }
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static GoRouter? _router;
  static ProviderContainer? _providerContainer;

  static void setRouter(GoRouter router) {
    _router = router;
  }

  static void setProviderContainer(ProviderContainer container) {
    _providerContainer = container;
  }

  static Future<String> getFcmToken() async {
    try {
      final String? token = await _messaging.getToken();
      return token ?? '';
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return '';
    }
  }

  /// 🚀 Initialize Firebase & Notification Handlers with GoRouter & ProviderContainer
  static Future<void> initialize({
    GoRouter? router,
    ProviderContainer? container,
    GlobalKey<NavigatorState>? navKey, // Kept for backwards compatibility
  }) async {
    if (router != null) _router = router;
    if (container != null) _providerContainer = container;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initLocalNotifications();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _requestPermission();
    _setupListeners();
    await _checkInitialMessage();
  }

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (kDebugMode) {
          debugPrint('🔔 [LOCAL NOTIFICATION CLICKED PAYLOAD]: ${details.payload}');
        }
        if (details.payload != null && details.payload!.isNotEmpty) {
          _handleNotificationTap(details.payload!);
        }
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        final String? fcmToken = await _messaging.getToken();
        debugPrint('🔥 FCM Notifications Authorized: ${fcmToken != null}');
      }
    }
  }

  static void _setupListeners() {
    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('📩 [FOREGROUND MESSAGE RECEIVED]: ${message.data}');
      }

      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('🖱️ [APP OPENED VIA NOTIFICATION TAP]: ${message.data}');
      }
      _handleDataMap(message.data);
    });
  }

  static Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      if (kDebugMode) {
        debugPrint('🚀 [APP LAUNCHED FROM KILLED STATE]: ${initialMessage.data}');
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleDataMap(initialMessage.data);
      });
    }
  }

  static void _handleNotificationTap(String payloadStr) {
    try {
      Map<String, dynamic> dataMap = {};

      if (payloadStr.startsWith('{') && payloadStr.endsWith('}')) {
        try {
          dataMap = Map<String, dynamic>.from(jsonDecode(payloadStr));
        } catch (_) {
          final cleanStr = payloadStr.substring(1, payloadStr.length - 1);
          final entries = cleanStr.split(', ');
          for (var entry in entries) {
            final split = entry.split(': ');
            if (split.length >= 2) {
              dataMap[split[0].trim()] = split.sublist(1).join(': ').trim();
            }
          }
        }
      }

      _handleDataMap(dataMap);
    } catch (e) {
      debugPrint('Error parsing payload tap: $e');
    }
  }

  static void _handleDataMap(Map<String, dynamic> data, {int retryCount = 0}) async {
    final String action = (data['action'] ?? '').toString().toLowerCase().trim();

    final String modalType = (data['modalType'] ?? '').toString().toLowerCase().trim();
    final String mainType = (data['type'] ?? '').toString().toLowerCase().trim();

    final String conversationId = (data['conversationId'] ?? '').toString().trim();
    final String modalId = (data['modalId'] ?? '').toString().trim();

    final String entityId = modalId.isNotEmpty ? modalId : conversationId;
    final String entityId2 = conversationId.isNotEmpty ? conversationId : modalId;

    final String rawName = (data['modalName'] ?? 'Model').toString().trim();
    final String cleanName = rawName.replaceFirst(RegExp(r'^Chat with\s+', caseSensitive: false), '');
    final String modalImage = (data['modalImage'] ?? '').toString().trim();

    if (kDebugMode) {
      debugPrint("🎯 Notification Action: $action | ModalType: $modalType | EntityId: $entityId");
    }

    if (action == 'open_chat' && (entityId.isNotEmpty || entityId2.isNotEmpty)) {
      final BuildContext? context = rootNavigatorKey.currentContext;
      bool apiHitSuccess = false;

      // Access ChatNotifier from Riverpod container or context
      final notifier = _providerContainer?.read(chatNotifierProvider.notifier) ??
          (context != null && context.mounted
              ? ProviderScope.containerOf(context).read(chatNotifierProvider.notifier)
              : null);

      if (notifier != null) {
        try {
          if (modalType == 'roleplay' || mainType == 'roleplay') {
            await notifier.fetchChatListRole(
              entityId,
              imageUrl: modalImage,
              context: context,
            );
          } else if (modalType == 'companion' || mainType == 'companion') {
            await notifier.fetchChatListCompanion(
              entityId2,
              context: context,
            );
          } else {
            await notifier.fetchChatList(
              entityId,
              cleanName,
              imageUrl: modalImage,
            );
          }
          apiHitSuccess = true;
        } catch (e) {
          debugPrint('⚠️ API Call Error on Notification Tap: $e');
        }
      }

      if (!apiHitSuccess) {
        if (retryCount < 5) {
          await Future.delayed(const Duration(milliseconds: 500));
          _handleDataMap(data, retryCount: retryCount + 1);
          return;
        }
      }

      // 🟢 Deep-link Navigation via GoRouter Instance
      final GoRouter? router = _router ??
          (context != null && context.mounted ? GoRouter.of(context) : null);

      if (router != null) {
        if (modalType == 'companion' || mainType == 'companion') {
          router.pushNamed(
            'chatScreen3',
            extra: {
              'sId': entityId2,
              'id': entityId,
              'image': modalImage,
              'name': cleanName,
              'autoScrollToBottom': true,
            },
          );
        } else if (modalType == 'roleplay' || mainType == 'roleplay') {
          router.pushNamed(
            'roleplayChat',
            extra: {
              'sId': entityId,
              'name': cleanName,
              'image': modalImage,
              'autoScrollToBottom': true,
            },
          );
        } else {
          router.pushNamed(
            'chatScreen',
            extra: {
              'sId': entityId,
              'name': cleanName,
              'image': modalImage,
              'autoScrollToBottom': true,
            },
          );
        }
      }
    }
  }
}
