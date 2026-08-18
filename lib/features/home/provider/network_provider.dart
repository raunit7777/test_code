import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Internet status check karne ke liye StreamProvider
final networkStatusProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  // Initial status check
  final initialResult = await connectivity.checkConnectivity();
  yield !initialResult.contains(ConnectivityResult.none);

  // Real-time changes ko listen karein
  await for (final results in connectivity.onConnectivityChanged) {
    // Agar result me ConnectivityResult.none nahi hai, to internet connected hai
    yield !results.contains(ConnectivityResult.none);
  }
});