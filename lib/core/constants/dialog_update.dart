import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

class ForcedUpdateDialog extends StatelessWidget {
  final String playStoreUrl;
  final String appStoreUrl;

  const ForcedUpdateDialog({
    super.key,
    required this.playStoreUrl,
    required this.appStoreUrl,
  });

  Future<void> _triggerImmediateUpdate() async {
    if (Platform.isAndroid) {
      try {
        // Play Store official Immediate Update flow (Google Play overlay)
        final updateInfo = await InAppUpdate.checkForUpdate();
        if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
          await InAppUpdate.performImmediateUpdate();
          return;
        }
      } catch (e) {
        debugPrint("InAppUpdate failed, falling back to Store URL: $e");
      }
    }

    // Direct Store Fallback (iOS ya Direct Link)
    final String targetUrl = Platform.isAndroid ? playStoreUrl : appStoreUrl;
    final Uri uri = Uri.parse(targetUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 PopScope with canPop: false prevents Back-button dismiss
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: const Color(0xFF1E1E20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.system_update, color: Color(0xFFFF4D79)),
            SizedBox(width: 10),
            Text(
              'Update Required',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'A new version of the app is available. Please update to continue using the app.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D79),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _triggerImmediateUpdate,
              child: const Text(
                'Update Now',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}