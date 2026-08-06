import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/di/service_locator.dart';
import '../repo/subcription_model.dart';
import '../state/subcription_state.dart';

// ✅ Main Provider Declaration
final subscriptionProvider =
StateNotifierProvider<SubscriptionNotifier, SubcriptionState>((ref) {
  return SubscriptionNotifier(sl<SubcriptionRepository>());
});

class SubscriptionNotifier extends StateNotifier<SubcriptionState> {
  final SubcriptionRepository _repository;

  SubscriptionNotifier(this._repository) : super(const SubcriptionState());

  // ✅ Fetch Subscription List
  Future<void> fetchSubcriptionList() async {
    state = state.copyWith(subcriptionList: const AsyncValue.loading());
    try {
      final response = await _repository.getSubcription(); // Ya _repository.getSubcription()
      state = state.copyWith(subcriptionList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(subcriptionList: AsyncValue.error(e, stack));
    }
  }
}