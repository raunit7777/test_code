// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../model/subcription_model.dart';
//
// class SubcriptionState {
//   final AsyncValue<SubcriptionModel?> subcriptionList;
//   final bool isSending;
//
//   const SubcriptionState({
//     this.subcriptionList = const AsyncValue.data(null),
//     this.isSending = false,
//   });
//
//   SubcriptionState copyWith({
//     AsyncValue<SubcriptionModel?>? subcriptionList,
//     bool? isSending,
//   }) {
//     return SubcriptionState(
//       subcriptionList: subcriptionList ?? this.subcriptionList,
//       isSending: isSending ?? this.isSending,
//     );
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../describe_image/model/subcription_model.dart';
import '../../payment/model/avilable_model.dart';

enum SubscribeStatus {
  idle,
  initiating,
  launchingPaytm,
  success,
  failure,
}

class SubscribeState {
  final AsyncValue<SubcriptionModel?> subcriptionList;
  final AsyncValue<AvailablePaymentModel?> paymentAvailableList;
  final SubscribeStatus status;
  final String? errorMessage;

  const SubscribeState({
    this.subcriptionList = const AsyncValue.data(null),
    this.paymentAvailableList = const AsyncValue.data(null),
    this.status = SubscribeStatus.idle,
    this.errorMessage,
  });

  bool get isBusy =>
      status == SubscribeStatus.initiating ||
          status == SubscribeStatus.launchingPaytm;

  SubscribeState copyWith({
    AsyncValue<SubcriptionModel?>? subcriptionList,
    AsyncValue<AvailablePaymentModel?>? paymentAvailableList,
    SubscribeStatus? status,
    String? errorMessage,
  }) {
    return SubscribeState(
      subcriptionList: subcriptionList ?? this.subcriptionList,
      paymentAvailableList:
      paymentAvailableList ?? this.paymentAvailableList,
      status: status ?? this.status,
      errorMessage: errorMessage, // 🟢 Allows clearing errorMessage when null is passed explicitly
    );
  }
}