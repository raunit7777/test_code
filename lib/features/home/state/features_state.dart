import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../chat/model/chat_init_model.dart';
import '../../chat/model/chat_init_role_model.dart';
import '../../chat/model/massage_model.dart';
import '../model/conversation_model.dart';
import '../model/featurs_model.dart';
import '../model/onboadring_model.dart';
import '../model/profile_detail_model.dart';
import '../model/role_play_deatails.dart';
import '../model/role_play_model.dart';
import '../model/vibe_model.dart';

class FeaturesState {
  final AsyncValue<FeatureModel?> profileList;
  final AsyncValue<ProfileDeatilModel?> profileDetails;
  final AsyncValue<RolePlayModel?> rolePlayList;
  final AsyncValue<ChatInitModel?> chatInit;
  final AsyncValue<ChatInitRoleModel?> roleChatInit;
  final AsyncValue<RolePlayDetailsModel?> role;
  final AsyncValue<ConversationModel?> conversationList;
  final AsyncValue<OnboardingModals?> onboardingList; // 🟢 Added onboardingList
  final AsyncValue<VibeModel?> vibeList;
  final List<Messages> messages;
  final bool isSending;

  const FeaturesState({
    this.profileList = const AsyncValue.data(null),
    this.profileDetails = const AsyncValue.data(null),
    this.rolePlayList = const AsyncValue.data(null),
    this.chatInit = const AsyncValue.data(null),
    this.roleChatInit = const AsyncValue.data(null),
    this.role = const AsyncValue.data(null),
    this.conversationList = const AsyncValue.data(null),
    this.onboardingList = const AsyncValue.data(null), // 🟢 Added in constructor
    this.vibeList = const AsyncValue.data(null),
    this.messages = const [],
    this.isSending = false,
  });

  FeaturesState copyWith({
    AsyncValue<FeatureModel?>? profileList,
    AsyncValue<ProfileDeatilModel?>? profileDetails,
    AsyncValue<RolePlayModel?>? rolePlayList,
    AsyncValue<ChatInitModel?>? chatInit,
    AsyncValue<ChatInitRoleModel?>? roleChatInit,
    AsyncValue<RolePlayDetailsModel?>? role,
    AsyncValue<ConversationModel?>? conversationList,
    AsyncValue<OnboardingModals?>? onboardingList, // 🟢 Added in copyWith
    AsyncValue<VibeModel?>? vibeList,
    List<Messages>? messages,
    bool? isSending,
  }) {
    return FeaturesState(
      profileList: profileList ?? this.profileList,
      profileDetails: profileDetails ?? this.profileDetails,
      rolePlayList: rolePlayList ?? this.rolePlayList,
      chatInit: chatInit ?? this.chatInit,
      roleChatInit: roleChatInit ?? this.roleChatInit,
      role: role ?? this.role,
      conversationList: conversationList ?? this.conversationList,
      onboardingList: onboardingList ?? this.onboardingList, // 🟢 Added in return
      vibeList: vibeList ?? this.vibeList,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }
}