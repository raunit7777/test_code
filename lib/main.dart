import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:infinity_love/shared/weget/no_internet.dart';

import 'core/constants/hive_keys.dart';
import 'core/di/service_locator.dart' as di;
import 'core/env/dev_env.dart';
import 'core/storage/loacal_storage.dart';
import 'features/home/provider/network_provider.dart';
import 'features/notification/notification_service.dart';
import 'routes/app_routes.dart';

void main() async {
  // 1. Ensure Flutter bindings initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Setup Dev Environment
  DevEnv.setup();

  // 3. Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(HiveKeys.settingsBox);

  // 4. Initialize Secure Storage & migrate legacy Hive tokens to Keystore/Keychain
  await LocalStorage.init();

  // 5. Service Locator (GetIt) Initialization
  await di.init();

  // 6. Create explicit Riverpod Container instance
  final container = ProviderContainer();

  // 7. Obtain unified GoRouter instance bound to rootNavigatorKey
  final router = container.read(routerProvider);

  // 8. Initialize Firebase & Push Notifications with actual GoRouter instance & container
  await NotificationService.initialize(router: router, container: container);

  // 9. Run App with UncontrolledProviderScope using the initialized container
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);
    final isConnected = ref.watch(networkStatusProvider).value ?? true;

    return SafeArea(
      top: false,
      child: MaterialApp.router(
        title: 'Infinity Love',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F0F12),
        ),
        routerConfig: goRouter,
        builder: (context, child) {
          return Stack(
            children: [
              child ?? const SizedBox.shrink(),
              if (!isConnected)
                const Positioned.fill(
                  child: NoInternetWidget(),
                ),
            ],
          );
        },
      ),
    );
  }
}
