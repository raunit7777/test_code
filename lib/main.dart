// import 'package:flutter/material.dart';
//
// import 'features/splash/screens/splash_screen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(top: false,
//       child: MaterialApp(
//         title: 'Flutter Demo',debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // TRY THIS: Try running your application with "flutter run". You'll see
//           // the application has a purple toolbar. Then, without quitting the app,
//           // try changing the seedColor in the colorScheme below to Colors.green
//           // and then invoke "hot reload" (save your changes or press the "hot
//           // reload" button in a Flutter-supported IDE, or press "r" if you used
//           // the command line to start the app).
//           //
//           // Notice that the counter didn't reset back to zero; the application
//           // state is not lost during the reload. To reset the state, use hot
//           // restart instead.
//           //
//           // This works for code too, not just values: Most code changes can be
//           // tested with just a hot reload.
//
//         ),
//         home: SplashScreen(),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/splash/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ProviderScope wrap kar diya hai Riverpod state management ke liye
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinity Love',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F12), // AppColors.bgBlack
      ),
      home: const SplashScreen(),
    );
  }
}