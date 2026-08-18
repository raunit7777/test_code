// import 'package:flutter/material.dart';
//
// class CustomizePersonalityScreen extends StatefulWidget {
//   const CustomizePersonalityScreen({super.key});
//
//   @override
//   State<CustomizePersonalityScreen> createState() =>
//       _CustomizePersonalityScreenState();
// }
//
// class _CustomizePersonalityScreenState
//     extends State<CustomizePersonalityScreen> {
//   // --- Slider States (0.0 to 1.0) ---
//   double _shyNaughtyValue = 0.5;
//   double _caringPlayfulValue = 0.5;
//   double _matureChildishValue = 0.5;
//
//   // --- Additional Traits Multi-Select State ---
//   final List<String> _availableTraits = [
//     'Loyal',
//     'Sarcastic',
//     'Talkative',
//     'Teasing',
//     'Flirty',
//     'Jealous',
//     'Witty',
//     'Serious',
//     'Adventurous',
//   ];
//
//   final Set<String> _selectedTraits = {'Loyal', 'Sarcastic'};
//
//   void _toggleTrait(String trait) {
//     setState(() {
//       if (_selectedTraits.contains(trait)) {
//         _selectedTraits.remove(trait);
//       } else {
//         if (_selectedTraits.length < 3) {
//           _selectedTraits.add(trait);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('You can select up to 3 traits only!'),
//               duration: Duration(seconds: 2),
//             ),
//           );
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const primaryPink = Color(0xFFFF4D79);
//     const darkBg = Color(0xFF121212);
//     const cardBg = Color(0xFF1C1C1E);
//
//     return Scaffold(
//       backgroundColor: darkBg,
//       appBar: AppBar(
//         backgroundColor: darkBg,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Customize Personality',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // --- 1. PROFILE AVATAR & NAME ---
//                     Center(
//                       child: Column(
//                         children: [
//                           Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Container(
//                                 width: 140,
//                                 height: 140,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: primaryPink,
//                                     width: 3,
//                                   ),
//                                 ),
//                                 child: const Padding(
//                                   padding: EdgeInsets.all(4.0),
//                                   child: CircleAvatar(
//                                     backgroundImage: AssetImage('assets/21.png'),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: primaryPink,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Text(
//                               'Ayushi',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 28),
//
//                     // --- 2. PERSONALITY TRAITS SLIDERS ---
//                     const Text(
//                       'Personality Traits',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     // Slider 1: Shy vs Naughty
//                     _buildSliderCard(
//                       leftText: '😳 Shy',
//                       rightText: 'Naughty 😏',
//                       value: _shyNaughtyValue,
//                       activeColor: primaryPink,
//                       onChanged: (val) => setState(() => _shyNaughtyValue = val),
//                     ),
//                     const SizedBox(height: 14),
//
//                     // Slider 2: Caring vs Playful
//                     _buildSliderCard(
//                       leftText: '💝 Caring',
//                       rightText: 'Playful 😜',
//                       value: _caringPlayfulValue,
//                       activeColor: primaryPink,
//                       onChanged: (val) =>
//                           setState(() => _caringPlayfulValue = val),
//                     ),
//                     const SizedBox(height: 14),
//
//                     // Slider 3: Mature vs Childish
//                     _buildSliderCard(
//                       leftText: '👔 Mature',
//                       rightText: 'Childish 🧸',
//                       value: _matureChildishValue,
//                       activeColor: primaryPink,
//                       onChanged: (val) =>
//                           setState(() => _matureChildishValue = val),
//                     ),
//
//                     const SizedBox(height: 28),
//
//                     // --- 3. ADDITIONAL TRAITS ---
//                     const Text(
//                       'Additional Traits',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Select up to 3 traits for your AI model',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.6),
//                         fontSize: 13,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 12,
//                       children: _availableTraits.map((trait) {
//                         final isSelected = _selectedTraits.contains(trait);
//                         return ChoiceChip(
//                           label: Text(trait),
//                           selected: isSelected,
//                           onSelected: (_) => _toggleTrait(trait),
//                           backgroundColor: cardBg,
//                           selectedColor: primaryPink,
//                           labelStyle: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: isSelected
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(24),
//                             side: BorderSide(
//                               color: isSelected
//                                   ? primaryPink
//                                   : Colors.white.withOpacity(0.15),
//                               width: 1,
//                             ),
//                           ),
//                           showCheckmark: false,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 10),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//
//             // --- 4. SAVE BUTTON ---
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 54,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final selectedData = {
//                       'shyNaughty': _shyNaughtyValue,
//                       'caringPlayful': _caringPlayfulValue,
//                       'matureChildish': _matureChildishValue,
//                       'additionalTraits': _selectedTraits.toList(),
//                     };
//                     Navigator.pop(context, selectedData);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryPink,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'Save Changes',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // --- Helper Widget for Slider Cards ---
//   Widget _buildSliderCard({
//     required String leftText,
//     required String rightText,
//     required double value,
//     required ValueChanged<double> onChanged,
//     Color activeColor = const Color(0xFFFF4D79),
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1C1E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.08),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 leftText,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 rightText,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           SliderTheme(
//             data: SliderThemeData(
//               trackHeight: 6,
//               activeTrackColor: activeColor, // 🟢 FIX: Active progress bar Pink ho jayegi
//               inactiveTrackColor: Colors.white12,
//               thumbColor: Colors.white,
//               overlayColor: activeColor.withOpacity(0.2),
//               thumbShape: const RoundSliderThumbShape(
//                 enabledThumbRadius: 10,
//                 elevation: 3,
//               ),
//             ),
//             child: Slider(
//               value: value,
//               onChanged: onChanged,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinity_love/features/custmization/provider/customization_provider.dart';
//
// import 'model/customize_model.dart';
//
// class CustomizePersonalityScreen extends ConsumerStatefulWidget {
//   final String? userId;
//
//   const CustomizePersonalityScreen({super.key, this.userId});
//
//   @override
//   ConsumerState<CustomizePersonalityScreen> createState() =>
//       _CustomizePersonalityScreenState();
// }
//
// class _CustomizePersonalityScreenState
//     extends ConsumerState<CustomizePersonalityScreen> {
//   // Store dynamic slider values
//   final Map<String, double> _sliderValues = {
//     'shyNaughty': 0.5,
//     'caringPlayful': 0.5,
//     'matureChildish': 0.5,
//   };
//
//   // Default available traits list
//   final List<AdditionalTraits> _allAvailableTraits = [
//     AdditionalTraits(traitId: '1', name: 'Loyal'),
//     AdditionalTraits(traitId: '2', name: 'Sarcastic'),
//     AdditionalTraits(traitId: '3', name: 'Talkative'),
//     AdditionalTraits(traitId: '4', name: 'Teasing'),
//     AdditionalTraits(traitId: '5', name: 'Flirty'),
//     AdditionalTraits(traitId: '6', name: 'Jealous'),
//     AdditionalTraits(traitId: '7', name: 'Witty'),
//     AdditionalTraits(traitId: '8', name: 'Serious'),
//     AdditionalTraits(traitId: '9', name: 'Adventurous'),
//   ];
//
//   final Set<String> _selectedTraitIds = {};
//
//   late String _effectiveUserId;
//   bool _isInitialDataLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       String routeUserId = '';
//
//       final settingsArgs = ModalRoute.of(context)?.settings.arguments;
//       if (settingsArgs is Map) {
//         routeUserId = settingsArgs['sId']?.toString() ??
//             settingsArgs['userId']?.toString() ??
//             '';
//       } else if (settingsArgs is String) {
//         routeUserId = settingsArgs;
//       }
//
//       _effectiveUserId =
//           widget.userId ?? (routeUserId.isNotEmpty ? routeUserId : '');
//
//       if (_effectiveUserId.isNotEmpty) {
//         ref.read(CustomizProvider.notifier).fetchProfileDetails(_effectiveUserId);
//       }
//     });
//   }
//
//   void _initializeDataFromModel(Data data) {
//     if (_isInitialDataLoaded) return;
//
//     if (data.sliders != null && data.sliders!.isNotEmpty) {
//       for (var slider in data.sliders!) {
//         if (slider.traitId != null) {
//           final rawVal = (slider.value ?? 50).toDouble();
//           _sliderValues[slider.traitId!] = (rawVal / 100.0).clamp(0.0, 1.0);
//         }
//       }
//     }
//
//     if (data.additionalTraits != null && data.additionalTraits!.isNotEmpty) {
//       _allAvailableTraits.clear();
//       for (var trait in data.additionalTraits!) {
//         _allAvailableTraits.add(trait);
//         if (trait.selected == true && trait.traitId != null) {
//           _selectedTraitIds.add(trait.traitId!);
//         }
//       }
//     }
//
//     _isInitialDataLoaded = true;
//   }
//
//   void _toggleTrait(String traitId, int maxAllowed) {
//     setState(() {
//       if (_selectedTraitIds.contains(traitId)) {
//         _selectedTraitIds.remove(traitId);
//       } else {
//         if (_selectedTraitIds.length < maxAllowed) {
//           _selectedTraitIds.add(traitId);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('You can select up to $maxAllowed traits only!'),
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         }
//       }
//     });
//   }
//
//   // 🟢 Naya Custom Trait add karne ke liye Dialog
//   void _showAddTraitDialog(int maxAllowed) {
//     final TextEditingController traitController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: const Color(0xFF1C1C1E),
//           title: const Text(
//             'Add Custom Trait',
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//           content: TextField(
//             controller: traitController,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: 'Enter trait name (e.g. Caring)',
//               hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
//               enabledBorder: const UnderlineInputBorder(
//                 borderSide: BorderSide(color: Color(0xFFFF4D79)),
//               ),
//               focusedBorder: const UnderlineInputBorder(
//                 borderSide: BorderSide(color: Color(0xFFFF4D79), width: 2),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFFF4D79),
//               ),
//               onPressed: () {
//                 final newTraitName = traitController.text.trim();
//                 if (newTraitName.isNotEmpty) {
//                   final newId = DateTime.now().millisecondsSinceEpoch.toString();
//                   final newTrait = AdditionalTraits(traitId: newId, name: newTraitName);
//
//                   setState(() {
//                     _allAvailableTraits.add(newTrait);
//                     if (_selectedTraitIds.length < maxAllowed) {
//                       _selectedTraitIds.add(newId); // Auto select new trait
//                     }
//                   });
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text('Add', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const primaryPink = Color(0xFFFF4D79);
//     const darkBg = Color(0xFF121212);
//     const cardBg = Color(0xFF1C1C1E);
//
//     final state = ref.watch(CustomizProvider);
//     final asyncData = state.custmizeList;
//
//     return Scaffold(
//       backgroundColor: darkBg,
//       appBar: AppBar(
//         backgroundColor: darkBg,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Customize Personality',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: asyncData.when(
//           loading: () => const Center(
//             child: CircularProgressIndicator(color: primaryPink),
//           ),
//           error: (err, stack) => _buildMainUI(
//             context,
//             character: null,
//             sliders: [],
//             maxTraitsAllowed: 3,
//             primaryPink: primaryPink,
//             cardBg: cardBg,
//           ),
//           data: (CustomizeModel? response) {
//             final apiData = response?.data;
//
//             if (apiData != null) {
//               _initializeDataFromModel(apiData);
//             }
//
//             return _buildMainUI(
//               context,
//               character: apiData?.character,
//               sliders: apiData?.sliders ?? [],
//               maxTraitsAllowed: apiData?.maxAdditionalTraits ?? 3,
//               primaryPink: primaryPink,
//               cardBg: cardBg,
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMainUI(
//       BuildContext context, {
//         required Character? character,
//         required List<Sliders> sliders,
//         required int maxTraitsAllowed,
//         required Color primaryPink,
//         required Color cardBg,
//       }) {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- 1. PROFILE AVATAR & NAME ---
//                 Center(
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 140,
//                         height: 140,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: primaryPink,
//                             width: 3,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: CircleAvatar(
//                             backgroundImage: (character?.image != null &&
//                                 character!.image!.isNotEmpty)
//                                 ? NetworkImage(character.image!)
//                             as ImageProvider
//                                 : const AssetImage('assets/21.png'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: primaryPink,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           character?.name ?? 'AI Model',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 28),
//
//                 // --- 2. PERSONALITY TRAITS SLIDERS ---
//                 const Text(
//                   'Personality Traits',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 if (sliders.isNotEmpty)
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: sliders.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 14),
//                     itemBuilder: (context, index) {
//                       final item = sliders[index];
//                       final traitId = item.traitId ?? '$index';
//                       final currentValue = _sliderValues[traitId] ?? 0.5;
//
//                       final leftLabel =
//                       '${item.left?.emoji ?? ''} ${item.left?.label ?? ''}'
//                           .trim();
//                       final rightLabel =
//                       '${item.right?.label ?? ''} ${item.right?.emoji ?? ''}'
//                           .trim();
//
//                       return _buildSliderCard(
//                         leftText: leftLabel,
//                         rightText: rightLabel,
//                         value: currentValue,
//                         activeColor: primaryPink,
//                         onChanged: (val) {
//                           setState(() {
//                             _sliderValues[traitId] = val;
//                           });
//                         },
//                       );
//                     },
//                   )
//                 else ...[
//                   _buildSliderCard(
//                     leftText: '😳 Shy',
//                     rightText: 'Naughty 😏',
//                     value: _sliderValues['shyNaughty'] ?? 0.5,
//                     activeColor: primaryPink,
//                     onChanged: (val) =>
//                         setState(() => _sliderValues['shyNaughty'] = val),
//                   ),
//                   const SizedBox(height: 14),
//                   _buildSliderCard(
//                     leftText: '💝 Caring',
//                     rightText: 'Playful 😜',
//                     value: _sliderValues['caringPlayful'] ?? 0.5,
//                     activeColor: primaryPink,
//                     onChanged: (val) =>
//                         setState(() => _sliderValues['caringPlayful'] = val),
//                   ),
//                   const SizedBox(height: 14),
//                   _buildSliderCard(
//                     leftText: '👔 Mature',
//                     rightText: 'Childish 🧸',
//                     value: _sliderValues['matureChildish'] ?? 0.5,
//                     activeColor: primaryPink,
//                     onChanged: (val) =>
//                         setState(() => _sliderValues['matureChildish'] = val),
//                   ),
//                 ],
//
//                 const SizedBox(height: 28),
//
//                 // --- 3. ADDITIONAL TRAITS ---
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Additional Traits',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     // 🟢 Naya trait add karne ka button
//                     GestureDetector(
//                       onTap: () => _showAddTraitDialog(maxTraitsAllowed),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: primaryPink.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: primaryPink),
//                         ),
//                         child:  Row(
//                           children: [
//                             Icon(Icons.add, color: primaryPink, size: 16),
//                             SizedBox(width: 4),
//                             Text(
//                               'Add Custom',
//                               style: TextStyle(
//                                 color: primaryPink,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Select up to $maxTraitsAllowed traits for your AI model',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.6),
//                     fontSize: 13,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 Wrap(
//                   spacing: 10,
//                   runSpacing: 12,
//                   children: _allAvailableTraits.map((trait) {
//                     final traitId = trait.traitId ?? trait.name ?? '';
//                     final isSelected = _selectedTraitIds.contains(traitId);
//
//                     return ChoiceChip(
//                       label: Text(trait.name ?? ''),
//                       selected: isSelected,
//                       onSelected: (_) =>
//                           _toggleTrait(traitId, maxTraitsAllowed),
//                       backgroundColor: cardBg,
//                       selectedColor: primaryPink,
//                       labelStyle: TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight:
//                         isSelected ? FontWeight.bold : FontWeight.normal,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                         side: BorderSide(
//                           color: isSelected
//                               ? primaryPink
//                               : Colors.white.withOpacity(0.15),
//                           width: 1,
//                         ),
//                       ),
//                       showCheckmark: false,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 10),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//
//         // --- 4. SAVE BUTTON ---
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           child: SizedBox(
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed: () {
//                 final formattedSliders = _sliderValues.map(
//                       (key, value) => MapEntry(key, (value * 100).round()),
//                 );
//
//                 final resultPayload = {
//                   'characterId': character?.sId ?? _effectiveUserId,
//                   'sliders': formattedSliders,
//                   'additionalTraitIds': _selectedTraitIds.toList(),
//                 };
//
//                 Navigator.pop(context, resultPayload);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryPink,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(28),
//                 ),
//                 elevation: 0,
//               ),
//               child: const Text(
//                 'Save Changes',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSliderCard({
//     required String leftText,
//     required String rightText,
//     required double value,
//     required ValueChanged<double> onChanged,
//     Color activeColor = const Color(0xFFFF4D79),
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1C1E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.08),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 leftText,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 rightText,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           SliderTheme(
//             data: SliderThemeData(
//               trackHeight: 6,
//               activeTrackColor: activeColor,
//               inactiveTrackColor: Colors.white12,
//               thumbColor: Colors.white,
//               overlayColor: activeColor.withOpacity(0.2),
//               thumbShape: const RoundSliderThumbShape(
//                 enabledThumbRadius: 10,
//                 elevation: 3,
//               ),
//             ),
//             child: Slider(
//               value: value,
//               onChanged: onChanged,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinity_love/features/custmization/provider/customization_provider.dart';
//
// import 'model/customize_model.dart';
//
// class CustomizePersonalityScreen extends ConsumerStatefulWidget {
//   final String? userId;
//
//   const CustomizePersonalityScreen({super.key, this.userId});
//
//   @override
//   ConsumerState<CustomizePersonalityScreen> createState() =>
//       _CustomizePersonalityScreenState();
// }
//
// class _CustomizePersonalityScreenState
//     extends ConsumerState<CustomizePersonalityScreen> {
//   // 🟢 Stores slider values by traitId -> double (0.0 to 1.0)
//   final Map<String, double> _sliderValues = {};
//
//   // 🟢 List of Sliders and AdditionalTraits received directly from API
//   final List<Sliders> _activeSliders = [];
//   final List<AdditionalTraits> _allAvailableTraits = [];
//
//   // 🟢 Selected trait IDs ONLY
//   final Set<String> _selectedTraitIds = {};
//
//   // 🟢 FIX: Default empty string initialization to avoid LateInitializationError
//   String _effectiveUserId = '';
//   bool _isInitialDataLoaded = false;
//   bool _isSaving = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Direct widget prop assignment if available immediately
//     if (widget.userId != null && widget.userId!.isNotEmpty) {
//       _effectiveUserId = widget.userId!;
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       String routeUserId = '';
//
//       final settingsArgs = ModalRoute.of(context)?.settings.arguments;
//       if (settingsArgs is Map) {
//         routeUserId = settingsArgs['sId']?.toString() ??
//             settingsArgs['userId']?.toString() ??
//             '';
//       } else if (settingsArgs is String) {
//         routeUserId = settingsArgs;
//       }
//
//       final resolvedId =
//           widget.userId ?? (routeUserId.isNotEmpty ? routeUserId : '');
//
//       if (mounted) {
//         setState(() {
//           _effectiveUserId = resolvedId;
//         });
//       }
//
//       if (resolvedId.isNotEmpty) {
//         ref.read(CustomizProvider.notifier).fetchProfileDetails(resolvedId);
//       }
//     });
//   }
//
//   // 🟢 Parsing exact API response and mapping IDs
//   void _initializeDataFromModel(Data data) {
//     if (_isInitialDataLoaded) return;
//
//     _activeSliders.clear();
//     _allAvailableTraits.clear();
//     _selectedTraitIds.clear();
//
//     // 1. Sliders mapping with exact traitId from API
//     if (data.sliders != null && data.sliders!.isNotEmpty) {
//       for (var slider in data.sliders!) {
//         final tId = slider.traitId ?? '';
//         if (tId.isNotEmpty) {
//           _activeSliders.add(slider);
//           final rawVal = (slider.value ?? 50).toDouble();
//           _sliderValues[tId] = (rawVal / 100.0).clamp(0.0, 1.0);
//         }
//       }
//     }
//
//     // 2. Additional Traits mapping with exact traitId from API
//     if (data.additionalTraits != null && data.additionalTraits!.isNotEmpty) {
//       for (var trait in data.additionalTraits!) {
//         final tId = trait.traitId ?? '';
//         if (tId.isNotEmpty) {
//           _allAvailableTraits.add(trait);
//           if (trait.selected == true) {
//             _selectedTraitIds.add(tId);
//           }
//         }
//       }
//     }
//
//     _isInitialDataLoaded = true;
//   }
//
//   void _toggleTrait(String traitId, int maxAllowed) {
//     setState(() {
//       if (_selectedTraitIds.contains(traitId)) {
//         _selectedTraitIds.remove(traitId);
//       } else {
//         if (_selectedTraitIds.length < maxAllowed) {
//           _selectedTraitIds.add(traitId);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('You can select up to $maxAllowed traits only!'),
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         }
//       }
//     });
//   }
//
//   // 🟢 Save changes method - ONLY sends traitId and value/array of traitId
//   Future<void> _handleSaveChanges(String characterId) async {
//     if (_isSaving) return;
//
//     setState(() {
//       _isSaving = true;
//     });
//
//     final List<Map<String, dynamic>> slidersPayload = [];
//     for (var slider in _activeSliders) {
//       final tId = slider.traitId;
//       if (tId != null && tId.isNotEmpty) {
//         final valDouble = _sliderValues[tId] ?? 0.5;
//         slidersPayload.add({
//           'traitId': tId,
//           'value': (valDouble * 100).round(),
//         });
//       }
//     }
//
//     final List<String> additionalTraitsPayload = _selectedTraitIds.toList();
//
//     try {
//       final targetId = characterId.isNotEmpty ? characterId : _effectiveUserId;
//
//       final success = await ref
//           .read(CustomizProvider.notifier)
//           .updateProfileVibe(
//         characterId: targetId,
//         sliders: slidersPayload,
//         additionalTraits: additionalTraitsPayload,
//       );
//
//       if (mounted) {
//         if (success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Personality updated successfully!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Failed to update personality. Try again.'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isSaving = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const primaryPink = Color(0xFFFF4D79);
//     const darkBg = Color(0xFF121212);
//     const cardBg = Color(0xFF1C1C1E);
//
//     final state = ref.watch(CustomizProvider);
//     final asyncData = state.custmizeList;
//
//     return Scaffold(
//       backgroundColor: darkBg,
//       appBar: AppBar(
//         backgroundColor: darkBg,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Customize Personality',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: asyncData.when(
//           loading: () => const Center(
//             child: CircularProgressIndicator(color: primaryPink),
//           ),
//           error: (err, stack) => Center(
//             child: Text(
//               'Error loading details: $err',
//               style: const TextStyle(color: Colors.white70),
//             ),
//           ),
//           data: (CustomizeModel? response) {
//             final apiData = response?.data;
//
//             if (apiData != null) {
//               _initializeDataFromModel(apiData);
//             }
//
//             return _buildMainUI(
//               context,
//               character: apiData?.character,
//               maxTraitsAllowed: apiData?.maxAdditionalTraits ?? 3,
//               primaryPink: primaryPink,
//               cardBg: cardBg,
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMainUI(
//       BuildContext context, {
//         required Character? character,
//         required int maxTraitsAllowed,
//         required Color primaryPink,
//         required Color cardBg,
//       }) {
//     final String characterId = (character?.sId != null && character!.sId!.isNotEmpty)
//         ? character.sId!
//         : _effectiveUserId;
//
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- 1. PROFILE AVATAR & NAME ---
//                 Center(
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 140,
//                         height: 140,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: primaryPink,
//                             width: 3,
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: CircleAvatar(
//                             backgroundImage: (character?.image != null &&
//                                 character!.image!.isNotEmpty)
//                                 ? NetworkImage(character.image!)
//                             as ImageProvider
//                                 : const AssetImage('assets/21.png'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: primaryPink,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           character?.name ?? 'AI Model',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 28),
//
//                 // --- 2. PERSONALITY TRAITS SLIDERS ---
//                 if (_activeSliders.isNotEmpty) ...[
//                   const Text(
//                     'Personality Traits',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: _activeSliders.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 14),
//                     itemBuilder: (context, index) {
//                       final sliderItem = _activeSliders[index];
//                       final tId = sliderItem.traitId ?? '';
//
//                       final leftText =
//                       '${sliderItem.left?.emoji ?? ''} ${sliderItem.left?.label ?? ''}'
//                           .trim();
//                       final rightText =
//                       '${sliderItem.right?.label ?? ''} ${sliderItem.right?.emoji ?? ''}'
//                           .trim();
//
//                       final currentValue = _sliderValues[tId] ?? 0.5;
//
//                       return _buildSliderCard(
//                         leftText: leftText,
//                         rightText: rightText,
//                         value: currentValue,
//                         activeColor: primaryPink,
//                         onChanged: (val) {
//                           setState(() {
//                             _sliderValues[tId] = val;
//                           });
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 28),
//                 ],
//
//                 // --- 3. ADDITIONAL TRAITS ---
//                 if (_allAvailableTraits.isNotEmpty) ...[
//                   const Text(
//                     'Additional Traits',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Select up to $maxTraitsAllowed traits for your AI model',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.6),
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 12,
//                     children: _allAvailableTraits.map((trait) {
//                       final tId = trait.traitId ?? '';
//                       final isSelected = _selectedTraitIds.contains(tId);
//
//                       return ChoiceChip(
//                         label: Text(trait.name ?? ''),
//                         selected: isSelected,
//                         onSelected: (_) => _toggleTrait(tId, maxTraitsAllowed),
//                         backgroundColor: cardBg,
//                         selectedColor: primaryPink,
//                         labelStyle: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                           side: BorderSide(
//                             color: isSelected
//                                 ? primaryPink
//                                 : Colors.white.withOpacity(0.15),
//                             width: 1,
//                           ),
//                         ),
//                         showCheckmark: false,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 10),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ],
//             ),
//           ),
//         ),
//
//         // --- 4. SAVE BUTTON ---
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//           child: SizedBox(
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed:
//               _isSaving ? null : () => _handleSaveChanges(characterId),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: primaryPink,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(28),
//                 ),
//                 elevation: 0,
//               ),
//               child: _isSaving
//                   ? const SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2.5,
//                 ),
//               )
//                   : const Text(
//                 'Save Changes',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSliderCard({
//     required String leftText,
//     required String rightText,
//     required double value,
//     required ValueChanged<double> onChanged,
//     Color activeColor = const Color(0xFFFF4D79),
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1C1E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.08),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 leftText,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 rightText,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           SliderTheme(
//             data: SliderThemeData(
//               trackHeight: 6,
//               activeTrackColor: activeColor,
//               inactiveTrackColor: Colors.white12,
//               thumbColor: Colors.white,
//               overlayColor: activeColor.withOpacity(0.2),
//               thumbShape: const RoundSliderThumbShape(
//                 enabledThumbRadius: 10,
//                 elevation: 3,
//               ),
//             ),
//             child: Slider(
//               value: value,
//               onChanged: onChanged,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinity_love/core/utils/utils.dart';
import 'package:infinity_love/features/custmization/provider/customization_provider.dart';

import 'model/customize_model.dart';

class CustomizePersonalityScreen extends ConsumerStatefulWidget {
  final String? userId;

  const CustomizePersonalityScreen({super.key, this.userId});

  @override
  ConsumerState<CustomizePersonalityScreen> createState() =>
      _CustomizePersonalityScreenState();
}

class _CustomizePersonalityScreenState
    extends ConsumerState<CustomizePersonalityScreen> {
  // 🟢 Stores slider values by traitId -> double (0.0 to 1.0)
  final Map<String, double> _sliderValues = {};

  // 🟢 List of Sliders and AdditionalTraits received directly from API
  final List<Sliders> _activeSliders = [];
  final List<AdditionalTraits> _allAvailableTraits = [];

  // 🟢 Selected trait IDs ONLY
  final Set<String> _selectedTraitIds = {};

  String _effectiveUserId = '';
  bool _isInitialDataLoaded = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.userId != null && widget.userId!.isNotEmpty) {
      _effectiveUserId = widget.userId!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String routeUserId = '';

      final settingsArgs = ModalRoute.of(context)?.settings.arguments;
      if (settingsArgs is Map) {
        routeUserId = settingsArgs['sId']?.toString() ??
            settingsArgs['userId']?.toString() ??
            '';
      } else if (settingsArgs is String) {
        routeUserId = settingsArgs;
      }

      final resolvedId =
          widget.userId ?? (routeUserId.isNotEmpty ? routeUserId : '');

      if (mounted) {
        setState(() {
          _effectiveUserId = resolvedId;
        });
      }

      if (resolvedId.isNotEmpty) {
        ref.read(CustomizProvider.notifier).fetchProfileDetails(resolvedId);
      }
    });
  }

  // 🟢 Parsing exact API response and mapping IDs
  void _initializeDataFromModel(Data data) {
    if (_isInitialDataLoaded) return;

    _activeSliders.clear();
    _allAvailableTraits.clear();
    _selectedTraitIds.clear();

    // 1. Sliders mapping with exact traitId from API
    if (data.sliders != null && data.sliders!.isNotEmpty) {
      for (var slider in data.sliders!) {
        final tId = slider.traitId ?? '';
        if (tId.isNotEmpty) {
          _activeSliders.add(slider);
          final rawVal = (slider.value ?? 50).toDouble();
          _sliderValues[tId] = (rawVal / 100.0).clamp(0.0, 1.0);
        }
      }
    }

    // 2. Additional Traits mapping with exact traitId from API
    if (data.additionalTraits != null && data.additionalTraits!.isNotEmpty) {
      for (var trait in data.additionalTraits!) {
        final tId = trait.traitId ?? '';
        if (tId.isNotEmpty) {
          _allAvailableTraits.add(trait);
          if (trait.selected == true) {
            _selectedTraitIds.add(tId);
          }
        }
      }
    }

    _isInitialDataLoaded = true;
  }

  void _toggleTrait(String traitId, int maxAllowed) {
    setState(() {
      if (_selectedTraitIds.contains(traitId)) {
        _selectedTraitIds.remove(traitId);
      } else {
        if (_selectedTraitIds.length < maxAllowed) {
          _selectedTraitIds.add(traitId);
        } else {
          Utils.showErrorMessage(
            context,
            'You can select up to $maxAllowed traits only!',
          );
        }
      }
    });
  }

  // 🟢 Save changes method - Updates Vibe and pops back to Chat Screen
  Future<void> _handleSaveChanges(String characterId) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final List<Map<String, dynamic>> slidersPayload = [];
    for (var slider in _activeSliders) {
      final tId = slider.traitId;
      if (tId != null && tId.isNotEmpty) {
        final valDouble = _sliderValues[tId] ?? 0.5;
        slidersPayload.add({
          'traitId': tId,
          'value': (valDouble * 100).round(),
        });
      }
    }

    final List<String> additionalTraitsPayload = _selectedTraitIds.toList();

    try {
      final targetId = characterId.isNotEmpty ? characterId : _effectiveUserId;

      final success = await ref
          .read(CustomizProvider.notifier)
          .updateProfileVibe(
        characterId: targetId,
        sliders: slidersPayload,
        additionalTraits: additionalTraitsPayload,
      );

      if (mounted) {
        if (success) {
          // 🟢 1. Pop back to Chat Screen immediately
          Navigator.pop(context);

          // 🟢 2. Display success notification on Chat screen
          if (mounted) {
            Utils.showSuccessMessage(
              context,
              'Personality updated successfully!',
            );
          }
        } else {
          Utils.showErrorMessage(
            context,
            'Failed to update personality. Try again.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Utils.showErrorMessage(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFFF4D79);
    const darkBg = Color(0xFF121212);
    const cardBg = Color(0xFF1C1C1E);

    final state = ref.watch(CustomizProvider);
    final asyncData = state.custmizeList;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (!_isSaving) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Customize Personality',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: asyncData.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: primaryPink),
          ),
          error: (err, stack) => Center(
            child: Text(
              'Error loading details: $err',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          data: (CustomizeModel? response) {
            final apiData = response?.data;

            if (apiData != null) {
              _initializeDataFromModel(apiData);
            }

            return _buildMainUI(
              context,
              character: apiData?.character,
              maxTraitsAllowed: apiData?.maxAdditionalTraits ?? 3,
              primaryPink: primaryPink,
              cardBg: cardBg,
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainUI(
      BuildContext context, {
        required Character? character,
        required int maxTraitsAllowed,
        required Color primaryPink,
        required Color cardBg,
      }) {
    final String characterId = (character?.sId != null && character!.sId!.isNotEmpty)
        ? character.sId!
        : _effectiveUserId;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 1. PROFILE AVATAR & NAME ---
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryPink,
                            width: 3,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CircleAvatar(
                            backgroundImage: (character?.image != null &&
                                character!.image!.isNotEmpty)
                                ? NetworkImage(character.image!)
                            as ImageProvider
                                : const AssetImage('assets/21.png'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          character?.name ?? 'AI Model',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // --- 2. PERSONALITY TRAITS SLIDERS ---
                if (_activeSliders.isNotEmpty) ...[
                  const Text(
                    'Personality Traits',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _activeSliders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final sliderItem = _activeSliders[index];
                      final tId = sliderItem.traitId ?? '';

                      final leftText =
                      '${sliderItem.left?.emoji ?? ''} ${sliderItem.left?.label ?? ''}'
                          .trim();
                      final rightText =
                      '${sliderItem.right?.label ?? ''} ${sliderItem.right?.emoji ?? ''}'
                          .trim();

                      final currentValue = _sliderValues[tId] ?? 0.5;

                      return _buildSliderCard(
                        leftText: leftText,
                        rightText: rightText,
                        value: currentValue,
                        activeColor: primaryPink,
                        onChanged: (val) {
                          setState(() {
                            _sliderValues[tId] = val;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                ],

                // --- 3. ADDITIONAL TRAITS ---
                if (_allAvailableTraits.isNotEmpty) ...[
                  const Text(
                    'Additional Traits',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select up to $maxTraitsAllowed traits for your AI model',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 12,
                    children: _allAvailableTraits.map((trait) {
                      final tId = trait.traitId ?? '';
                      final isSelected = _selectedTraitIds.contains(tId);

                      return ChoiceChip(
                        label: Text(trait.name ?? ''),
                        selected: isSelected,
                        onSelected: (_) => _toggleTrait(tId, maxTraitsAllowed),
                        backgroundColor: cardBg,
                        selectedColor: primaryPink,
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(
                            color: isSelected
                                ? primaryPink
                                : Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),

        // --- 4. SAVE BUTTON ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed:
              _isSaving ? null : () => _handleSaveChanges(characterId),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPink,
                disabledBackgroundColor: primaryPink.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: _isSaving
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderCard({
    required String leftText,
    required String rightText,
    required double value,
    required ValueChanged<double> onChanged,
    Color activeColor = const Color(0xFFFF4D79),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leftText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                rightText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: activeColor,
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.white,
              overlayColor: activeColor.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
                elevation: 3,
              ),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}