import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/hive_keys.dart';
import 'core/di/service_locator.dart' as di;
import 'core/env/dev_env.dart';
import 'routes/app_routes.dart'; // ✅ Import your app_routes.dart

void main() async {
  // 1. Ensure Flutter bindings initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Setup Dev Environment
  DevEnv.setup();

  // 3. Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(HiveKeys.settingsBox);

  // 4. Service Locator (GetIt) Initialization
  await di.init();

  // 5. Run App with Riverpod Scope
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget { // ✅ Changed to ConsumerWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Watch GoRouter from Riverpod Provider
    final goRouter = ref.watch(routerProvider);

    return MaterialApp.router( // ✅ Converted to MaterialApp.router
      title: 'Infinity Love',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
      ),
      routerConfig: goRouter, // ✅ Passed GoRouter config
    );
  }
}