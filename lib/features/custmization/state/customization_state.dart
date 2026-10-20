import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/customize_model.dart';
import '../model/relationship_type_model.dart'; // 👈 RelationshipTypeModel import karein

class CustomizationState {
  final AsyncValue<CustomizeModel?> custmizeList;
  final AsyncValue<RelationshipTypeModel?> relationshipTypeList; // 🟢 Clean Separation

  const CustomizationState({
    this.custmizeList = const AsyncValue.data(null),
    this.relationshipTypeList = const AsyncValue.data(null),
  });

  // 🟢 Single Unified copyWith Method
  CustomizationState copyWith({
    AsyncValue<CustomizeModel?>? custmizeList,
    AsyncValue<RelationshipTypeModel?>? relationshipTypeList,
  }) {
    return CustomizationState(
      custmizeList: custmizeList ?? this.custmizeList,
      relationshipTypeList: relationshipTypeList ?? this.relationshipTypeList,
    );
  }
}