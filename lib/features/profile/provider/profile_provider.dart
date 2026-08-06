import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/di/service_locator.dart';
import '../profile_model/profile_model.dart';
import '../profile_repo/profile_repo.dart';

final profileProvider =
StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel2?>>((ref) {
  return ProfileNotifier(sl<ProfileRepository>());
});

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel2?>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final response = await _repository.getProfile();
      state = AsyncValue.data(response);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}