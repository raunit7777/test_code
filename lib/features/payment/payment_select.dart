import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_btn.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import '../../core/constants/const_text.dart';
import 'model/avilable_model.dart';


class PaymentMethodSelectionSheet extends StatefulWidget {
  final AvailablePaymentModel availablePayments;
  final Function(String selectedGateway) onGatewaySelected;

  const PaymentMethodSelectionSheet({
    super.key,
    required this.availablePayments,
    required this.onGatewaySelected, // 🟢 Fixed syntax error (removed dot)
  });

  @override
  State<PaymentMethodSelectionSheet> createState() =>
      _PaymentMethodSelectionSheetState();
}

class _PaymentMethodSelectionSheetState
    extends State<PaymentMethodSelectionSheet> {
  String? _selectedGateway;

  @override
  void initState() {
    super.initState();
    final data = widget.availablePayments.data;
    // Pre-select first available active payment gateway
    if (data?.paytm == true) {
      _selectedGateway = 'paytm';
    } else if (data?.cashfree == true) {
      _selectedGateway = 'cashfree';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.availablePayments.data;
    final bool isPaytmAvailable = data?.paytm == true;
    final bool isCashfreeAvailable = data?.cashfree == true;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.cardDarkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText.bold('Select Payment Method',
                  fontSize: 18, color: AppColors.textPrimaryLight),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 🟢 Paytm Option (If true)
          if (isPaytmAvailable)
            _buildGatewayTile(
              id: 'paytm',
              title: 'Paytm / UPI',
              icon: Icons.account_balance_wallet,
            ),

          // 🟢 Cashfree Option (If true)
          if (isCashfreeAvailable)
            _buildGatewayTile(
              id: 'cashfree',
              title: 'Cashfree Payments',
              icon: Icons.credit_card,
            ),

          if (!isPaytmAvailable && !isCashfreeAvailable)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomText.medium('No payment methods currently active.',
                  color: Colors.redAccent),
            ),

          const SizedBox(height: 24),

          // Proceed Button
          AppBtn(
            title: 'Proceed to Pay',
            color: AppColors.primaryPink,
            height: 50,
            borderRadius: 25,
            onTap: _selectedGateway == null
                ? null
                : () {
              Navigator.pop(context);
              widget.onGatewaySelected(_selectedGateway!);
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildGatewayTile(
      {required String id, required String title, required IconData icon}) {
    final isSelected = _selectedGateway == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGateway = id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgBlack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : Colors.white12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryPink, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: CustomText.bold(title, fontSize: 15, color: Colors.white),
            ),
            Radio<String>(
              value: id,
              groupValue: _selectedGateway,
              activeColor: AppColors.primaryPink,
              onChanged: (val) {
                if (val != null) setState(() => _selectedGateway = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}