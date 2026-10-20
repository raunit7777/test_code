// //
// //
// //
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import '../../firebase_options.dart';
// //
// // // 🔔 Top-Level Background Handler
// // @pragma('vm:entry-point')
// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// //   );
// //   debugPrint("Handling background notification: ${message.messageId}");
// // }
// //
// // class NotificationService {
// //   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
// //   static final FlutterLocalNotificationsPlugin _localNotifications =
// //   FlutterLocalNotificationsPlugin();
// //
// //   /// 🔑 Helper to get current FCM device token
// //   static Future<String> getFcmToken() async {
// //     try {
// //       final String? token = await _messaging.getToken();
// //       return token ?? '';
// //     } catch (e) {
// //       debugPrint('Error getting FCM token: $e');
// //       return '';
// //     }
// //   }
// //
// //   /// 🚀 Initialize Firebase & Notification Handlers
// //   static Future<void> initialize() async {
// //     await Firebase.initializeApp(
// //       options: DefaultFirebaseOptions.currentPlatform,
// //     );
// //
// //     await _initLocalNotifications();
// //     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
// //     await _requestPermission();
// //     _setupListeners();
// //   }
// //
// //   static Future<void> _initLocalNotifications() async {
// //     const AndroidInitializationSettings androidSettings =
// //     AndroidInitializationSettings('@mipmap/ic_launcher');
// //
// //     const DarwinInitializationSettings iosSettings =
// //     DarwinInitializationSettings();
// //
// //     const InitializationSettings initSettings = InitializationSettings(
// //       android: androidSettings,
// //       iOS: iosSettings,
// //     );
// //
// //     await _localNotifications.initialize(
// //       initSettings,
// //       onDidReceiveNotificationResponse: (details) {
// //         debugPrint('Local notification clicked: ${details.payload}');
// //       },
// //     );
// //
// //     const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //       'high_importance_channel',
// //       'High Importance Notifications',
// //       description: 'This channel is used for important notifications.',
// //       importance: Importance.max,
// //     );
// //
// //     await _localNotifications
// //         .resolvePlatformSpecificImplementation<
// //         AndroidFlutterLocalNotificationsPlugin>()
// //         ?.createNotificationChannel(channel);
// //   }
// //
// //   static Future<void> _requestPermission() async {
// //     final NotificationSettings settings = await _messaging.requestPermission(
// //       alert: true,
// //       badge: true,
// //       sound: true,
// //       provisional: false,
// //     );
// //
// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       debugPrint('User granted notification permission');
// //       final String? fcmToken = await _messaging.getToken();
// //       debugPrint('🔥 FCM DEVICE TOKEN: $fcmToken');
// //     } else {
// //       debugPrint('User declined notification permission');
// //     }
// //   }
// //
// //   static void _setupListeners() {
// //     _messaging.setForegroundNotificationPresentationOptions(
// //       alert: true,
// //       badge: true,
// //       sound: true,
// //     );
// //
// //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //       debugPrint('Received notification in foreground!');
// //
// //       final RemoteNotification? notification = message.notification;
// //       final AndroidNotification? android = message.notification?.android;
// //
// //       if (notification != null && android != null) {
// //         _localNotifications.show(
// //           notification.hashCode,
// //           notification.title,
// //           notification.body,
// //           const NotificationDetails(
// //             android: AndroidNotificationDetails(
// //               'high_importance_channel',
// //               'High Importance Notifications',
// //               importance: Importance.max,
// //               priority: Priority.high,
// //               icon: '@mipmap/ic_launcher',
// //             ),
// //             iOS: DarwinNotificationDetails(
// //               presentAlert: true,
// //               presentBadge: true,
// //               presentSound: true,
// //             ),
// //           ),
// //         );
// //       }
// //     });
// //
// //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       debugPrint('App opened via notification tap: ${message.data}');
// //     });
// //   }
// // }
//
//
// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../firebase_options.dart';
// import '../chat/provider/chat_provider.dart';
//
// // 🔔 Top-Level Background Handler
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   debugPrint("📦 [BACKGROUND DATA]: ${message.data}");
// }
//
// class NotificationService {
//   static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//
//   static GlobalKey<NavigatorState>? _navigatorKey;
//   static Future<String> getFcmToken() async {
//     try {
//       final String? token = await _messaging.getToken();
//       return token ?? '';
//     } catch (e) {
//       debugPrint('Error getting FCM token: $e');
//       return '';
//     }
//   }
//   /// 🚀 Initialize Firebase & Notification Handlers
//   static Future<void> initialize(GlobalKey<NavigatorState> navKey) async {
//     _navigatorKey = navKey;
//
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//     await _initLocalNotifications();
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     await _requestPermission();
//     _setupListeners();
//     await _checkInitialMessage();
//   }
//
//   static Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings iosSettings =
//     DarwinInitializationSettings();
//
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) {
//         debugPrint('🔔 [LOCAL NOTIFICATION CLICKED PAYLOAD]: ${details.payload}');
//         if (details.payload != null && details.payload!.isNotEmpty) {
//           _handleNotificationTap(details.payload!);
//         }
//       },
//     );
//
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.max,
//     );
//
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }
//
//   static Future<void> _requestPermission() async {
//     final NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       final String? fcmToken = await _messaging.getToken();
//       debugPrint('🔥 FCM DEVICE TOKEN: $fcmToken');
//     }
//   }
//
//   static void _setupListeners() {
//     _messaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // 🟢 Foreground Listener
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('📩 [FOREGROUND MESSAGE RECEIVED]: ${message.data}');
//
//       final RemoteNotification? notification = message.notification;
//       final AndroidNotification? android = message.notification?.android;
//
//       if (notification != null && android != null) {
//         _localNotifications.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'high_importance_channel',
//               'High Importance Notifications',
//               importance: Importance.max,
//               priority: Priority.high,
//               icon: '@mipmap/ic_launcher',
//             ),
//             iOS: DarwinNotificationDetails(
//               presentAlert: true,
//               presentBadge: true,
//               presentSound: true,
//             ),
//           ),
//           // 🟢 Pass Map converted to JSON String payload
//           payload: jsonEncode(message.data),
//         );
//       }
//     });
//
//     // 🟢 App Opened from Background State
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('🖱️ [APP OPENED VIA NOTIFICATION TAP]: ${message.data}');
//       _handleDataMap(message.data);
//     });
//   }
//
//   /// 🟢 App Opened from Killed/Terminated State
//   static Future<void> _checkInitialMessage() async {
//     RemoteMessage? initialMessage = await _messaging.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint('🚀 [APP LAUNCHED FROM KILLED STATE]: ${initialMessage.data}');
//       _handleDataMap(initialMessage.data);
//     }
//   }
//
//   /// 🟢 Payload Tap Handler Logic
//   static void _handleNotificationTap(String payloadStr) {
//     try {
//       Map<String, dynamic> dataMap = {};
//
//       // Checking payload string structure (Map vs Stringified JSON)
//       if (payloadStr.startsWith('{') && payloadStr.endsWith('}')) {
//         try {
//           dataMap = Map<String, dynamic>.from(jsonDecode(payloadStr));
//         } catch (_) {
//           // If string is dart print layout format (e.g. {key: value})
//           final cleanStr = payloadStr.substring(1, payloadStr.length - 1);
//           final entries = cleanStr.split(', ');
//           for (var entry in entries) {
//             final split = entry.split(': ');
//             if (split.length >= 2) {
//               dataMap[split[0].trim()] = split.sublist(1).join(': ').trim();
//             }
//           }
//         }
//       }
//
//       _handleDataMap(dataMap);
//     } catch (e) {
//       debugPrint('Error parsing payload tap: $e');
//     }
//   }
//
//   /// 🟢 Dispatch Action & Trigger Chat Provider Fetch
//   static void _handleDataMap(Map<String, dynamic> data) {
//     final String action = data['action'] ?? '';
//     final String conversationId = data['conversationId'] ?? data['modalId'] ?? '';
//     final String modalName = data['modalName'] ?? 'Model';
//     final String modalImage = data['modalImage'] ?? '';
//
//     if (action == 'open_chat' && conversationId.isNotEmpty) {
//       final context = _navigatorKey?.currentContext;
//       if (context != null) {
//         // 🟢 Riverpod provider read karke fetch execute kiya
//         ProviderScope.containerOf(context).read(chatNotifierProvider.notifier).fetchChatList(
//           conversationId,
//           modalName,
//           imageUrl: modalImage,
//         );
//
//         // 🟢 ChatScreen Page Route Push (Apne screen widget ke according replace karein)
//         // Navigator.of(context).push(
//         //   MaterialPageRoute(
//         //     builder: (_) => ChatScreen(sId: conversationId, name: modalName),
//         //   ),
//         // );
//       }
//     }
//   }
// }

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../firebase_options.dart';
import '../chat/provider/chat_provider.dart';

// 🔔 Top-Level Background Handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("📦 [BACKGROUND DATA]: ${message.data}");
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static GlobalKey<NavigatorState>? _navigatorKey;
  static ProviderContainer? _providerContainer;

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

  static Future<void> initialize(GlobalKey<NavigatorState> navKey, {ProviderContainer? container}) async {
    _navigatorKey = navKey;
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
        debugPrint('🔔 [LOCAL NOTIFICATION CLICKED PAYLOAD]: ${details.payload}');
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
      final String? fcmToken = await _messaging.getToken();
      debugPrint('🔥 FCM DEVICE TOKEN: $fcmToken');
    }
  }

  static void _setupListeners() {
    _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 [FOREGROUND MESSAGE RECEIVED]: ${message.data}');

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
      debugPrint('🖱️ [APP OPENED VIA NOTIFICATION TAP]: ${message.data}');
      _handleDataMap(message.data);
    });
  }

  static Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('🚀 [APP LAUNCHED FROM KILLED STATE]: ${initialMessage.data}');
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

  // static void _handleDataMap(Map<String, dynamic> data, {int retryCount = 0}) async {
  //   final String action = data['action']?.toString() ?? '';
  //
  //   final String conversationId = data['conversationId']?.toString() ?? '';
  //   final String modalId = data['modalId']?.toString() ?? '';
  //   final String modalName = data['modalName']?.toString() ?? 'Model';
  //   final String modalImage = data['modalImage']?.toString() ?? '';
  //
  //   final String targetChatId = modalId.isNotEmpty ? modalId : conversationId;
  //
  //   debugPrint("🎯 Processing Notification Action: $action");
  //   debugPrint("🆔 Target Conversation ID: $targetChatId");
  //
  //   if (action == 'open_chat' && targetChatId.isNotEmpty) {
  //     final BuildContext? context = _navigatorKey?.currentContext;
  //     bool apiHitSuccess = false;
  //
  //     if (_providerContainer != null) {
  //       debugPrint('🚀 [API HIT] Calling fetchChatList via ProviderContainer with ID: $targetChatId');
  //       _providerContainer!
  //           .read(chatNotifierProvider.notifier)
  //           .fetchChatList(
  //         targetChatId,
  //         modalName,
  //         imageUrl: modalImage,
  //       );
  //       apiHitSuccess = true;
  //     } else if (context != null && context.mounted) {
  //       debugPrint('🚀 [API HIT] Calling fetchChatList via BuildContext with ID: $targetChatId');
  //       try {
  //         ProviderScope.containerOf(context)
  //             .read(chatNotifierProvider.notifier)
  //             .fetchChatList(
  //           targetChatId,
  //           modalName,
  //           imageUrl: modalImage,
  //         );
  //         apiHitSuccess = true;
  //       } catch (e) {
  //         debugPrint('⚠️ Error reading ProviderScope: $e');
  //       }
  //     }
  //
  //     if (!apiHitSuccess) {
  //       if (retryCount < 5) {
  //         debugPrint('⌛ Context/Container not ready. Retrying in 500ms...');
  //         await Future.delayed(const Duration(milliseconds: 500));
  //         _handleDataMap(data, retryCount: retryCount + 1);
  //         return;
  //       } else {
  //         debugPrint('❌ [ERROR] Could not hit API after 5 retries.');
  //         return;
  //       }
  //     }
  //
  //     // 🟢 Navigation Trigger to Chat Screen
  //     if (context != null && context.mounted) {
  //       debugPrint('🚗 Navigating to Chat Screen...');
  //       context.pushNamed(
  //         'chat',
  //         extra: {
  //           'sId': targetChatId,
  //           'name': modalName,
  //           'image': modalImage,
  //           'autoScrollToBottom': true, // Auto scroll trigger parameter
  //         },
  //       );
  //     }
  //   }
  // }


  static void _handleDataMap(Map<String, dynamic> data, {int retryCount = 0}) async {
    final String action = (data['action'] ?? '').toString().toLowerCase().trim();

    // 🟢 Chat Type detection (companion / roleplay / default)
    final String modalType = (data['modalType'] ?? '').toString().toLowerCase().trim();
    final String mainType = (data['type'] ?? '').toString().toLowerCase().trim();

    final String conversationId = (data['conversationId'] ?? '').toString().trim();
    final String modalId = (data['modalId'] ?? '').toString().trim();

    // 🟢 Dynamic IDs extraction matching _buildChatItem
    // entityId = modalId ?? conversationId
    final String entityId = modalId.isNotEmpty ? modalId : conversationId;
    // entityId2 = conversationId ?? modalId (for COMPANION)
    final String entityId2 = conversationId.isNotEmpty ? conversationId : modalId;

    final String rawName = (data['modalName'] ?? 'Model').toString().trim();
    final String cleanName = rawName.replaceFirst(RegExp(r'^Chat with\s+', caseSensitive: false), '');
    final String modalImage = (data['modalImage'] ?? '').toString().trim();

    debugPrint("🎯 Action: $action | ModalType: $modalType | Type: $mainType");
    debugPrint("🆔 EntityId: $entityId | EntityId2: $entityId2");

    if (action == 'open_chat' && (entityId.isNotEmpty || entityId2.isNotEmpty)) {
      final BuildContext? context = _navigatorKey?.currentContext;
      bool apiHitSuccess = false;

      // Riverpod Notifier Access
      final notifier = _providerContainer?.read(chatNotifierProvider.notifier) ??
          (context != null && context.mounted ? ProviderScope.containerOf(context).read(chatNotifierProvider.notifier) : null);

      if (notifier != null) {
        try {
          // 🟢 Exactly matching _buildChatItem conditions
          if (modalType == 'roleplay' || mainType == 'roleplay') {
            debugPrint('🚀 [API HIT] Calling fetchChatListRole for ID: $entityId');
            await notifier.fetchChatListRole(
              entityId,
              imageUrl: modalImage,
              context: context,
            );
          } else if (modalType == 'companion' || mainType == 'companion') {
            debugPrint('🚀 [API HIT] Calling fetchChatListCompanion for ID: $entityId2');
            await notifier.fetchChatListCompanion(
              entityId2,
              context: context,
            );
          } else {
            debugPrint('🚀 [API HIT] Calling fetchChatList for ID: $entityId');
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
          debugPrint('⌛ Context/Container not ready. Retrying in 500ms...');
          await Future.delayed(const Duration(milliseconds: 500));
          _handleDataMap(data, retryCount: retryCount + 1);
          return;
        } else {
          debugPrint('❌ [ERROR] Could not hit API after 5 retries.');
          return;
        }
      }

      // 🟢 Navigation Logic matching _buildChatItem
      if (context != null && context.mounted) {
        if (modalType == 'companion' || mainType == 'companion') {
          debugPrint('🚗 Navigating to Companion Screen (chatScreen3)...');
          context.pushNamed(
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
          debugPrint('🚗 Navigating to Roleplay Screen...');
          context.pushNamed(
            'roleplayChat',
            extra: {
              'sId': entityId,
              'name': cleanName,
              'image': modalImage,
              'autoScrollToBottom': true,
            },
          );
        } else {
          debugPrint('🚗 Navigating to Default Chat Screen...');
          context.pushNamed(
            'chat',
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