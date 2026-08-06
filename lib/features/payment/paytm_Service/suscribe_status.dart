import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../describe_image/model/subcription_model.dart';

enum SubscribeStatus {
  idle,
  initiating,
  launchingPaytm,
  success,
  failure,
}

class SubscribeState {
  final AsyncValue<SubcriptionModel?> subcriptionList;
  final SubscribeStatus status;
  final String? errorMessage;

  const SubscribeState({
    this.subcriptionList = const AsyncValue.data(null),
    this.status = SubscribeStatus.idle,
    this.errorMessage,
  });

  bool get isBusy =>
      status == SubscribeStatus.initiating || status == SubscribeStatus.launchingPaytm;

  SubscribeState copyWith({
    AsyncValue<SubcriptionModel?>? subcriptionList,
    SubscribeStatus? status,
    String? errorMessage,
  }) {
    return SubscribeState(
      subcriptionList: subcriptionList ?? this.subcriptionList,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}