import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Utils {
  static void showErrorMessage(BuildContext context, String message) {
    Flushbar(
      message: message,
      icon: const Icon(
        Icons.error_outline,
        size: 28.0,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: Colors.redAccent,
      backgroundColor: Colors.red.shade800,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(12),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
    ).show(context);
  }

  static void showSuccessMessage(BuildContext context, String message) {
    Flushbar(
      message: message,
      icon: const Icon(
        Icons.check_circle_outline,
        size: 28.0,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: Colors.greenAccent,
      backgroundColor: Colors.green.shade800,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(12),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
    ).show(context);
  }
}