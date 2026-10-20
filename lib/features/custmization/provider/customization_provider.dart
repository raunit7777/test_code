import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/di/service_locator.dart';
import '../repo/customize_repo.dart';
import '../state/customization_state.dart';

// ✅ Main Provider Declaration
final CustomizProvider =
StateNotifierProvider<ProfileNotifier, CustomizationState>((ref) {
  return ProfileNotifier(sl<CustomizeRepository>());
});

class ProfileNotifier extends StateNotifier<CustomizationState> {
  final CustomizeRepository _repository;

  ProfileNotifier(this._repository) : super(const CustomizationState());

  // 1️⃣ Fetch Model Details
  Future<void> fetchProfileDetails(dynamic sId) async {
    state = state.copyWith(custmizeList: const AsyncValue.loading());
    try {
      final response = await _repository.getProfileVibeDetails(sId.toString());
      state = state.copyWith(custmizeList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(custmizeList: AsyncValue.error(e, stack));
    }
  }
  Future<void> fetchRealationType() async {
    state = state.copyWith(relationshipTypeList: const AsyncValue.loading());
    try {
      final response = await _repository.getRelationShipType();

      // 🟢 Ab relationshipTypeList me RelationshipTypeModel assing hoga
      state = state.copyWith(relationshipTypeList: AsyncValue.data(response));
    } catch (e, stack) {
      state = state.copyWith(relationshipTypeList: AsyncValue.error(e, stack));
    }
  }


  // 2️⃣ Update Vibe Method
  Future<bool> updateProfileVibe({
    required String characterId,
    required List<Map<String, dynamic>> sliders,
    required List<String> additionalTraits,
  }) async {
    try {
      final response = await _repository.updateVibe(
        characterId: characterId,
        sliders: sliders,
        additionalTraits: additionalTraits,
      );

      final bool isSuccess = response.statusCode == 200 || response.statusCode == 201;

      // API success hone par hi profile update refresh karein
      if (isSuccess) {
        await fetchProfileDetails(characterId);

      }

      return isSuccess;
    } catch (e) {
      debugPrint('Error updating vibe in notifier: $e');
      return false;
    }
  }
}