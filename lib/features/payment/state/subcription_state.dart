import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../describe_image/model/subcription_model.dart';

import '../model/paytm_init_request_model.dart';


class SubcriptionState {
  final AsyncValue<SubcriptionModel?> subcriptionList;
  final AsyncValue<PaytmInitResponseModel?> paymentInitState;
  final bool isSending;

  const SubcriptionState({
    this.subcriptionList = const AsyncValue.data(null),
    this.paymentInitState = const AsyncValue.data(null),
    this.isSending = false,
  });

  SubcriptionState copyWith({
    AsyncValue<SubcriptionModel?>? subcriptionList,
    AsyncValue<PaytmInitResponseModel?>? paymentInitState,
    bool? isSending,
  }) {
    return SubcriptionState(
      subcriptionList: subcriptionList ?? this.subcriptionList,
      paymentInitState: paymentInitState ?? this.paymentInitState,
      isSending: isSending ?? this.isSending,
    );
  }
}