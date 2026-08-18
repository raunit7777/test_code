import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/core/constants/const_text.dart';
import 'package:infinity_love/extensions/context_extension.dart';

enum PaymentResultType { success, pending, cancelled }

class PaymentStatusDialog extends StatelessWidget {
  final PaymentResultType resultType;
  final String orderId;
  final String amount;
  final VoidCallback onContinue;

  const PaymentStatusDialog({
    super.key,
    required this.resultType,
    required this.orderId,
    required this.amount,
    required this.onContinue,
  });

  static const Color pinkAccent = Color(0xFFE91E63);

  @override
  Widget build(BuildContext context) {
    final config = _getDialogConfig(resultType);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.06),
      child: Container(
        padding: EdgeInsets.all(context.screenWidth * 0.05),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(context.screenWidth * 0.06),
          border: Border.all(
            color: config.accentColor.withValues(alpha: 0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: config.accentColor.withValues(alpha: 0.35),
              blurRadius: context.screenWidth * 0.08,
              spreadRadius: context.screenWidth * 0.005,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status Icon Circle with Glow
            Container(
              padding: EdgeInsets.all(context.screenWidth * 0.04),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: config.accentColor.withValues(alpha: 0.15),
                border: Border.all(color: config.accentColor.withValues(alpha: 0.4)),
              ),
              child: Icon(
                config.icon,
                color: config.accentColor,
                size: context.screenWidth * 0.12,
              ),
            ),

            SizedBox(height: context.screenHeight * 0.02),

            // Title
            CustomText.bold(
              config.title,
              fontSize: context.screenWidth * 0.055,
              color: Colors.white,
            ),

            SizedBox(height: context.screenHeight * 0.008),

            // Subtitle Description
            CustomText.regular(
              config.subtitle,
              fontSize: context.screenWidth * 0.035,
              color: Colors.white70,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.screenHeight * 0.02),

            // Transaction Details Box
            Container(
              padding: EdgeInsets.all(context.screenWidth * 0.035),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(context.screenWidth * 0.035),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.regular('Amount:', fontSize: context.screenWidth * 0.032, color: Colors.white54),
                      CustomText.bold('₹$amount', fontSize: context.screenWidth * 0.038, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: context.screenHeight * 0.006),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText.regular('Order ID:', fontSize: context.screenWidth * 0.032, color: Colors.white54),
                      Expanded(
                        child: CustomText.regular(
                          orderId,
                          fontSize: context.screenWidth * 0.03,
                          color: Colors.white,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: context.screenHeight * 0.025),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: context.screenHeight * 0.055,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.screenWidth * 0.04),
                  ),
                  elevation: 5,
                ),
                onPressed: onContinue,
                child: CustomText.bold(
                  config.buttonText,
                  fontSize: context.screenWidth * 0.04,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StatusConfig _getDialogConfig(PaymentResultType type) {
    switch (type) {
      case PaymentResultType.success:
        return _StatusConfig(
          title: 'Payment Successful!',
          subtitle: 'Your premium subscription has been activated successfully.',
          buttonText: 'Continue to Home',
          icon: Icons.check_circle_outline_rounded,
          accentColor: pinkAccent,
        );
      case PaymentResultType.pending:
        return _StatusConfig(
          title: 'Payment Pending',
          subtitle: 'We are waiting for bank confirmation. We will notify you once completed.',
          buttonText: 'Check Status',
          icon: Icons.hourglass_top_rounded,
          accentColor: Colors.amber,
        );
      case PaymentResultType.cancelled:
        return _StatusConfig(
          title: 'Payment Cancelled',
          subtitle: 'The transaction was cancelled or failed. Please try again.',
          buttonText: 'Try Again',
          icon: Icons.cancel_outlined,
          accentColor: Colors.redAccent,
        );
    }
  }
}

class _StatusConfig {
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;
  final Color accentColor;

  _StatusConfig({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
    required this.accentColor,
  });
}