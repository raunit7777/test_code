import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/di/service_locator.dart';
import '../home_repo/featuers_repo.dart';
import '../state/features_state.dart';

// ✅ Main Provider Declaration
final featuresProvider =
StateNotifierProvider<ProfileNotifier, FeaturesState>((ref) {
  return ProfileNotifier(sl<FeatuerRepository>());
});

class ProfileNotifier extends StateNotifier<FeaturesState> {
  final FeatuerRepository _repository;

  ProfileNotifier(this._repository) : super(const FeaturesState());

  // 1️⃣ Fetch Models List
  Future<void> fetchProfile() async {
    state = state.copyWith(profileList: const AsyncValue.loading());
    try {
      final response = await _repository.getProfile();
      state = state.copyWith(profileList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(profileList: AsyncValue.error(e, stack));
    }
  }


  Future<void> fetchConversationList() async {
    state = state.copyWith(conversationList: const AsyncValue.loading());
    try {
      final response = await _repository.getConversationList();
      state = state.copyWith(conversationList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(conversationList: AsyncValue.error(e, stack));
    }
  }

  // 2️⃣ Fetch Model Details
  Future<void> fetchProfileDetails(dynamic sId) async {
    state = state.copyWith(profileDetails: const AsyncValue.loading());
    try {
      final response = await _repository.getProfileDetails(sId.toString());
      state = state.copyWith(profileDetails: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(profileDetails: AsyncValue.error(e, stack));
    }
  }

  // 3️⃣ Fetch Role Play List (🟢 FIX: Now mapped to rolePlayList state)
  Future<void> rolePlayList() async {
    state = state.copyWith(rolePlayList: const AsyncValue.loading());
    try {
      final response = await _repository.getRolePlay();
      state = state.copyWith(rolePlayList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(rolePlayList: AsyncValue.error(e, stack));
    }
  }
  Future<void> fetchProfileDetailsRoleModel(dynamic sId) async {
    state = state.copyWith(role: const AsyncValue.loading());
    try {
      final response = await _repository.getProfileRoleModel(sId.toString());
      // 🟢 Fix: Copy to 'role' instead of 'profileDetails'
      state = state.copyWith(role: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(role: AsyncValue.error(e, stack));
    }
  }
}