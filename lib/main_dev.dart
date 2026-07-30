import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/hive_keys.dart';
import 'core/di/service_locator.dart' as di;
import 'core/env/dev_env.dart';
import 'main.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Dev Environment
  DevEnv.setup();

  // Initialize Firebase
  // await FirebaseServices.init();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(HiveKeys.settingsBox);

  // Initialize Dependency Injection
  await di.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}