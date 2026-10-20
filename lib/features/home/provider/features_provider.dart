import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/di/service_locator.dart';
import '../home_repo/featuers_repo.dart';
import '../model/vibe_model.dart' show VibeModel, Data, Vibes;
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


  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool _hasMoreData = true;

// 🟢 Initial Fetching Logic
  Future<void> fetchVibeList() async {
    _currentPage = 1;
    _hasMoreData = true;
    state = state.copyWith(vibeList: const AsyncValue.loading());

    try {
      final response = await _repository.getVibe(page: _currentPage);
      state = state.copyWith(vibeList: AsyncValue.data(response));
    } on DioException catch (e, stack) {
      String errorMessage = e.response?.data['message'] ?? e.message ?? 'Network error';
      state = state.copyWith(vibeList: AsyncValue.error(Exception(errorMessage), stack));
    } catch (e, stack) {
      state = state.copyWith(vibeList: AsyncValue.error(e, stack));
    }
  }

// 🟢 Load More Pagination Logic (Fixed List<Vibes> Type Issue)
  Future<void> fetchMoreVibeList() async {
    if (_isFetchingMore || !_hasMoreData) return;

    final currentVibeModel = state.vibeList.asData?.value;
    if (currentVibeModel == null) return;

    _isFetchingMore = true;

    try {
      final nextPage = _currentPage + 1;
      final response = await _repository.getVibe(page: nextPage);

      final newVibes = response.data?.vibes ?? [];
      if (newVibes.isEmpty) {
        _hasMoreData = false;
      } else {
        _currentPage = nextPage;

        // 🎯 Type Casting Fix: Explicitly declare <Vibes>
        final List<Vibes> updatedVibesList = <Vibes>[
          ...?currentVibeModel.data?.vibes,
          ...newVibes,
        ];

        final updatedData = Data(
          vibes: updatedVibesList,
          total: response.data?.total ?? currentVibeModel.data?.total,
        );

        final updatedModel = VibeModel(
          success: response.success,
          message: response.message,
          data: updatedData,
        );

        state = state.copyWith(vibeList: AsyncValue.data(updatedModel));
      }
    } catch (e) {
      // Handle or ignore pagination errors silently
    } finally {
      _isFetchingMore = false;
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


  Future<void> fetchOnboardingList() async {
    // Corrected spelling in function name (Onboarding)
    state = state.copyWith(onboardingList: const AsyncValue.loading());
    try {
      final response = await _repository.getOnboardingList();
      state = state.copyWith(onboardingList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(onboardingList: AsyncValue.error(e, stack));
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