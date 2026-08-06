import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/subcription_model.dart';

class SubcriptionState {
  final AsyncValue<SubcriptionModel?> subcriptionList;
  final bool isSending;

  const SubcriptionState({
    this.subcriptionList = const AsyncValue.data(null),
    this.isSending = false,
  });

  SubcriptionState copyWith({
    AsyncValue<SubcriptionModel?>? subcriptionList,
    bool? isSending,
  }) {
    return SubcriptionState(
      subcriptionList: subcriptionList ?? this.subcriptionList,
      isSending: isSending ?? this.isSending,
    );
  }
}