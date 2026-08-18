import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/customize_model.dart';

class CustomizationState {
  final AsyncValue<CustomizeModel?> custmizeList;

  const CustomizationState({
    this.custmizeList = const AsyncValue.data(null),
  });

  CustomizationState copyWith({
    AsyncValue<CustomizeModel?>? custmizeList,
  }) {
    return CustomizationState(
      custmizeList: custmizeList ?? this.custmizeList,
    );
  }
}