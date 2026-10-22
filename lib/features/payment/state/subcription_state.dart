import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../describe_image/model/subcription_model.dart';
import '../model/avilable_model.dart';
import '../paytm_Service/suscribe_status.dart';

export '../paytm_Service/suscribe_status.dart';

class SubscribeState {
  final AsyncValue<SubcriptionModel?> subcriptionList;
  final AsyncValue<AvailablePaymentModel?> paymentAvailableList;
  final PaymentState paymentState;
  final String? activeOrderId;
  final String? errorMessage;

  const SubscribeState({
    this.subcriptionList = const AsyncValue.data(null),
    this.paymentAvailableList = const AsyncValue.data(null),
    this.paymentState = PaymentState.initial,
    this.activeOrderId,
    this.errorMessage,
  });

  bool get isBusy => paymentState.isBusy;

  SubscribeStatus get status {
    switch (paymentState) {
      case PaymentState.initial:
        return SubscribeStatus.initial;
      case PaymentState.initiated:
        return SubscribeStatus.initiating;
      case PaymentState.verifying:
        return SubscribeStatus.verifying;
      case PaymentState.paid:
        return SubscribeStatus.paid;
      case PaymentState.pending:
        return SubscribeStatus.pending;
      case PaymentState.failed:
        return SubscribeStatus.failed;
      case PaymentState.expired:
        return SubscribeStatus.expired;
    }
  }

  SubscribeState copyWith({
    AsyncValue<SubcriptionModel?>? subcriptionList,
    AsyncValue<AvailablePaymentModel?>? paymentAvailableList,
    PaymentState? paymentState,
    SubscribeStatus? status,
    String? activeOrderId,
    String? errorMessage,
  }) {
    PaymentState resolvedState = paymentState ?? this.paymentState;
    if (paymentState == null && status != null) {
      switch (status) {
        case SubscribeStatus.initial:
        case SubscribeStatus.idle:
          resolvedState = PaymentState.initial;
          break;
        case SubscribeStatus.initiating:
        case SubscribeStatus.launchingPaytm:
          resolvedState = PaymentState.initiated;
          break;
        case SubscribeStatus.verifying:
        case SubscribeStatus.loading:
          resolvedState = PaymentState.verifying;
          break;
        case SubscribeStatus.paid:
        case SubscribeStatus.success:
          resolvedState = PaymentState.paid;
          break;
        case SubscribeStatus.pending:
          resolvedState = PaymentState.pending;
          break;
        case SubscribeStatus.failed:
        case SubscribeStatus.failure:
          resolvedState = PaymentState.failed;
          break;
        case SubscribeStatus.expired:
          resolvedState = PaymentState.expired;
          break;
      }
    }

    return SubscribeState(
      subcriptionList: subcriptionList ?? this.subcriptionList,
      paymentAvailableList: paymentAvailableList ?? this.paymentAvailableList,
      paymentState: resolvedState,
      activeOrderId: activeOrderId ?? this.activeOrderId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
