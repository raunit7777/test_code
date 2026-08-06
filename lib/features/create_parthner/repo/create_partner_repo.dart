// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../core/network/api_clinet.dart';
// import '../../../core/network/api_endpoints.dart';
// import '../../../core/network/dio_provider.dart';
// import '../../../core/utils/utils.dart';
// import '../model/create_model_model.dart';
//
// class CreatePartnerRepository {
//   final ApiClient _apiClient;
//
//   CreatePartnerRepository(this._apiClient);
//
//   Future<dynamic> createPartnerApi(CreatePartnerModel model) async {
//     // 🟢 1. Agar imagePath local file string hai (file upload case)
//     if (model.imagePath != null &&
//         model.imagePath!.isNotEmpty &&
//         !model.imagePath!.startsWith('http')) {
//       final formData = FormData.fromMap({
//         'name': model.name,
//         'gender': model.gender,
//         'age': model.age,
//         'relationshipType': model.relationship,
//         'personality[shyNaughty]': (model.shyNaughty * 100).round(),
//         'personality[caringPlayful]': (model.caringPlayful * 100).round(),
//         'personality[matureChildish]': (model.matureChildish * 100).round(),
//         'personality[traits]': model.traits,
//         'personality[interests]': model.interests,
//         'personality[speakingStyle]': model.speakingStyle,
//         'entityImage': await MultipartFile.fromFile(model.imagePath!), // 🟢 Key: entityImage
//       });
//
//       final response = await _apiClient.post(ApiEndpoints.createModel, data: formData);
//       return response.data;
//     }
//     // 🟢 2. Agar Cloudinary URL (https://) pass hua hai to directly JSON body bhejega
//     else {
//       final payload = model.toJson();
//       if (model.imagePath != null && model.imagePath!.isNotEmpty) {
//         payload['entityImage'] = model.imagePath; // 🟢 Key: entityImage
//       }
//
//       final response = await _apiClient.post(ApiEndpoints.createModel, data: payload);
//       return response.data;
//     }
//   }
// }
//
// final createPartnerRepoProvider = Provider<CreatePartnerRepository>((ref) {
//   final apiClient = ref.watch(apiClientProvider);
//   return CreatePartnerRepository(apiClient);
// });
//
// class CreatePartnerState {
//   final bool isLoading;
//   final CreatePartnerModel partnerData;
//   final String? error;
//
//   CreatePartnerState({
//     this.isLoading = false,
//     CreatePartnerModel? partnerData,
//     this.error,
//   }) : partnerData = partnerData ?? CreatePartnerModel();
//
//   CreatePartnerState copyWith({
//     bool? isLoading,
//     CreatePartnerModel? partnerData,
//     String? error,
//   }) {
//     return CreatePartnerState(
//       isLoading: isLoading ?? this.isLoading,
//       partnerData: partnerData ?? this.partnerData,
//       error: error ?? this.error,
//     );
//   }
// }
//
// class CreatePartnerNotifier extends StateNotifier<CreatePartnerState> {
//   final CreatePartnerRepository _repo;
//
//   CreatePartnerNotifier(this._repo) : super(CreatePartnerState());
//
//   void updateBasicDetails({
//     String? name,
//     String? relationship,
//     int? age,
//     String? gender,
//     String? imagePath,
//     String? image,
//   }) {
//     state = state.copyWith(
//       partnerData: state.partnerData.copyWith(
//         name: name,
//         relationship: relationship,
//         age: age,
//         gender: gender,
//         imagePath: imagePath ?? image,
//       ),
//     );
//   }
//
//   void updateSliders({
//     double? shyNaughty,
//     double? caringPlayful,
//     double? matureChildish,
//   }) {
//     state = state.copyWith(
//       partnerData: state.partnerData.copyWith(
//         shyNaughty: shyNaughty,
//         caringPlayful: caringPlayful,
//         matureChildish: matureChildish,
//       ),
//     );
//   }
//
//   void updateTraits(List<String> traits) {
//     state = state.copyWith(
//       partnerData: state.partnerData.copyWith(traits: traits),
//     );
//   }
//
//   Future<bool> submitCreatePartner(BuildContext context) async {
//     state = state.copyWith(isLoading: true, error: null);
//     try {
//       final res = await _repo.createPartnerApi(state.partnerData);
//       state = state.copyWith(isLoading: false);
//
//       final bool isSuccess = res['success'] == true ||
//           res['status'].toString() == "1" ||
//           res['statusCode'] == 200;
//
//       if (isSuccess) {
//         if (context.mounted) {
//           Utils.showSuccessMessage(
//             context,
//             res['message'] ?? 'AI Partner Created Successfully!',
//           );
//           context.pushNamed('mainNav');
//         }
//         return true;
//       } else {
//         if (context.mounted) {
//           Utils.showErrorMessage(
//             context,
//             res['message']?.toString() ?? 'Failed to create partner',
//           );
//         }
//         return false;
//       }
//     } catch (e) {
//       state = state.copyWith(isLoading: false, error: e.toString());
//       if (context.mounted) {
//         Utils.showErrorMessage(context, e.toString());
//       }
//       return false;
//     }
//   }
// }
//
// final createPartnerProvider =
// StateNotifierProvider<CreatePartnerNotifier, CreatePartnerState>((ref) {
//   return CreatePartnerNotifier(ref.watch(createPartnerRepoProvider));
// });


import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_clinet.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/utils/utils.dart';
import '../model/create_model_model.dart';

class CreatePartnerRepository {
  final ApiClient _apiClient;

  CreatePartnerRepository(this._apiClient);

  Future<dynamic> createPartnerApi(CreatePartnerModel model) async {
    // 🟢 1. Local File Multipart Case (File Upload)
    if (model.imagePath != null &&
        model.imagePath!.isNotEmpty &&
        !model.imagePath!.startsWith('http')) {
      final formData = FormData.fromMap({
        'name': model.name,
        'gender': model.gender ?? 'female',
        'age': model.age,
        'relationshipType': model.relationship,
        'entityImage': await MultipartFile.fromFile(model.imagePath!), // 🟢 Key: entityImage
        'personality[shyNaughty]': (model.shyNaughty * 100).round(),
        'personality[caringPlayful]': (model.caringPlayful * 100).round(),
        'personality[matureChildish]': (model.matureChildish * 100).round(),
        'personality[traits]': model.traits,
        'personality[interests]': model.interests,
        'personality[speakingStyle]': model.speakingStyle,
      });

      debugPrint("🚀 [MULTIPART UPLOAD] Sending File: ${model.imagePath}");
      final response = await _apiClient.post(ApiEndpoints.createModel, data: formData);
      return response.data;
    }
    // 🟢 2. Cloudinary Hosted URL Case (JSON Body)
    else {
      final Map<String, dynamic> payload = {
        'name': model.name,
        'gender': model.gender ?? 'female',
        'age': model.age,
        'relationshipType': model.relationship,
        'entityImage': model.imagePath ?? '', // 🟢 Explicit entityImage Key
        'personality': {
          'shyNaughty': (model.shyNaughty * 100).round(),
          'caringPlayful': (model.caringPlayful * 100).round(),
          'matureChildish': (model.matureChildish * 100).round(),
          'traits': model.traits,
          'interests': model.interests,
          'speakingStyle': model.speakingStyle,
        }
      };

      debugPrint("🚀 [JSON PAYLOAD] Payload sending to API: ${jsonEncode(payload)}");

      final response = await _apiClient.post(ApiEndpoints.createModel, data: payload);
      return response.data;
    }
  }
}

final createPartnerRepoProvider = Provider<CreatePartnerRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CreatePartnerRepository(apiClient);
});

class CreatePartnerState {
  final bool isLoading;
  final CreatePartnerModel partnerData;
  final String? error;

  CreatePartnerState({
    this.isLoading = false,
    CreatePartnerModel? partnerData,
    this.error,
  }) : partnerData = partnerData ?? CreatePartnerModel();

  CreatePartnerState copyWith({
    bool? isLoading,
    CreatePartnerModel? partnerData,
    String? error,
  }) {
    return CreatePartnerState(
      isLoading: isLoading ?? this.isLoading,
      partnerData: partnerData ?? this.partnerData,
      error: error ?? this.error,
    );
  }
}

class CreatePartnerNotifier extends StateNotifier<CreatePartnerState> {
  final CreatePartnerRepository _repo;

  CreatePartnerNotifier(this._repo) : super(CreatePartnerState());

  void updateBasicDetails({
    String? name,
    String? relationship,
    int? age,
    String? gender,
    String? imagePath,
    String? image,
  }) {
    final String finalImagePath = (imagePath != null && imagePath.isNotEmpty)
        ? imagePath
        : (image ?? state.partnerData.imagePath ?? '');

    state = state.copyWith(
      partnerData: state.partnerData.copyWith(
        name: name ?? state.partnerData.name,
        relationship: relationship ?? state.partnerData.relationship,
        age: age ?? state.partnerData.age,
        gender: gender ?? state.partnerData.gender ?? 'female',
        imagePath: finalImagePath,
      ),
    );
  }

  void updateSliders({
    double? shyNaughty,
    double? caringPlayful,
    double? matureChildish,
  }) {
    state = state.copyWith(
      partnerData: state.partnerData.copyWith(
        shyNaughty: shyNaughty,
        caringPlayful: caringPlayful,
        matureChildish: matureChildish,
      ),
    );
  }

  void updateTraits(List<String> traits) {
    state = state.copyWith(
      partnerData: state.partnerData.copyWith(traits: traits),
    );
  }

  Future<bool> submitCreatePartner(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _repo.createPartnerApi(state.partnerData);
      state = state.copyWith(isLoading: false);

      final bool isSuccess = res['success'] == true ||
          res['status'].toString() == "1" ||
          res['statusCode'] == 200;

      if (isSuccess) {
        if (context.mounted) {
          Utils.showSuccessMessage(
            context,
            res['message'] ?? 'AI Partner Created Successfully!',
          );
          context.pushNamed('mainNav');
        }
        return true;
      } else {
        if (context.mounted) {
          Utils.showErrorMessage(
            context,
            res['message']?.toString() ?? 'Failed to create partner',
          );
        }
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      if (context.mounted) {
        Utils.showErrorMessage(context, e.toString());
      }
      return false;
    }
  }
}

final createPartnerProvider =
StateNotifierProvider<CreatePartnerNotifier, CreatePartnerState>((ref) {
  return CreatePartnerNotifier(ref.watch(createPartnerRepoProvider));
});