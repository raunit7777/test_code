// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../describe_image/model/subcription_model.dart';
//
// import '../model/paytm_init_request_model.dart';
//
//
// class SubcriptionState {
//   final AsyncValue<SubcriptionModel?> subcriptionList;
//   final AsyncValue<PaytmInitResponseModel?> paymentInitState;
//   final bool isSending;
//
//   const SubcriptionState({
//     this.subcriptionList = const AsyncValue.data(null),
//     this.paymentInitState = const AsyncValue.data(null),
//     this.isSending = false,
//   });
//
//   SubcriptionState copyWith({
//     AsyncValue<SubcriptionModel?>? subcriptionList,
//     AsyncValue<PaytmInitResponseModel?>? paymentInitState,
//     bool? isSending,
//   }) {
//     return SubcriptionState(
//       subcriptionList: subcriptionList ?? this.subcriptionList,
//       paymentInitState: paymentInitState ?? this.paymentInitState,
//       isSending: isSending ?? this.isSending,
//     );
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../describe_image/model/subcription_model.dart';
import '../model/avilable_model.dart';
import '../paytm_Service/suscribe_status.dart';

class SubscribeState {
  final AsyncValue<SubcriptionModel?> subcriptionList;
  final AsyncValue<AvailablePaymentModel?> paymentAvailableList; // 🟢 Added
  final SubscribeStatus status;
  final String? errorMessage;

  const SubscribeState({
    this.subcriptionList = const AsyncValue.data(null),
    this.paymentAvailableList = const AsyncValue.data(null), // 🟢 Added
    this.status = SubscribeStatus.idle,
    this.errorMessage,
  });

  bool get isBusy =>
      status == SubscribeStatus.initiating || status == SubscribeStatus.launchingPaytm;

  SubscribeState copyWith({
    AsyncValue<SubcriptionModel?>? subcriptionList,
    AsyncValue<AvailablePaymentModel?>? paymentAvailableList,
    SubscribeStatus? status,
    String? errorMessage,
  }) {
    return SubscribeState(
      subcriptionList: subcriptionList ?? this.subcriptionList,
      paymentAvailableList: paymentAvailableList ?? this.paymentAvailableList,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}