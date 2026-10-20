// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:hugeicons/hugeicons.dart';
// // import 'package:infinity_love/core/constants/app_color.dart';
// // import 'package:infinity_love/features/alarm/provider/alram_provider.dart';
// //
// // import '../../core/constants/app_btn.dart';
// // import '../../core/constants/const_text.dart';
// // import 'model/alram_model.dart';
// //
// // class AlarmsScreen extends ConsumerStatefulWidget {
// //   const AlarmsScreen({super.key});
// //
// //   @override
// //   ConsumerState<AlarmsScreen> createState() => _AlarmsScreenState();
// // }
// //
// // class _AlarmsScreenState extends ConsumerState<AlarmsScreen> {
// //   final List<String> _daysList = [
// //     'monday',
// //     'tuesday',
// //     'wednesday',
// //     'thursday',
// //     'friday',
// //     'saturday',
// //     'sunday'
// //   ];
// //
// //   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
// //   final List<Items> _items = [];
// //   bool _initialLoading = true;
// //   bool _hasError = false;
// //
// //   final Set<String> _poppingIds = {};
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.microtask(() async {
// //       await ref.read(alarmProvider.notifier).fetchAlarms();
// //       _syncFromProvider(initial: true);
// //     });
// //   }
// //
// //   void _syncFromProvider({bool initial = false}) {
// //     final asyncAlarmList = ref.read(alarmProvider).alarmList;
// //     asyncAlarmList.when(
// //       data: (model) {
// //         final items = model?.data?.items ?? [];
// //         setState(() {
// //           _items
// //             ..clear()
// //             ..addAll(items);
// //           _initialLoading = false;
// //           _hasError = false;
// //         });
// //         _listKey.currentState?.setState(() {});
// //       },
// //       loading: () {
// //         if (initial) {
// //           setState(() => _initialLoading = true);
// //         }
// //       },
// //       error: (_, __) {
// //         setState(() {
// //           _initialLoading = false;
// //           _hasError = true;
// //         });
// //       },
// //     );
// //   }
// //
// //   void _showAddAlarmBottomSheet(BuildContext context) {
// //     TimeOfDay selectedTime = TimeOfDay.now();
// //     final Set<String> selectedDays = {
// //       'monday',
// //       'tuesday',
// //       'wednesday',
// //       'thursday',
// //       'friday'
// //     };
// //     final TextEditingController messageController = TextEditingController();
// //
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: AppColors.profileCardBg,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
// //       ),
// //       builder: (context) {
// //         return StatefulBuilder(
// //           builder: (context, setModalState) {
// //             final alarmState = ref.watch(alarmProvider);
// //
// //             String formattedTimeStr =
// //                 '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
// //
// //             return Padding(
// //               padding: EdgeInsets.only(
// //                 left: 20.0,
// //                 right: 20.0,
// //                 top: 20.0,
// //                 bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
// //               ),
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   mainAxisSize: MainAxisSize.min,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         CustomText.bold(
// //                           'Set New Alarm',
// //                           fontSize: 18,
// //                           color: AppColors.textPrimaryLight,
// //                         ),
// //                         IconButton(
// //                           icon: const HugeIcon(
// //                             icon: HugeIcons.strokeRoundedCancel01,
// //                             color: AppColors.textSecondaryLight,
// //                             size: 20,
// //                           ),
// //                           onPressed: () => Navigator.pop(context),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 16),
// //                     InkWell(
// //                       borderRadius: BorderRadius.circular(16),
// //                       onTap: () async {
// //                         final TimeOfDay? picked = await showTimePicker(
// //                           context: context,
// //                           initialTime: selectedTime,
// //                           builder: (context, child) {
// //                             return Theme(
// //                               data: Theme.of(context).copyWith(
// //                                 scaffoldBackgroundColor: AppColors.profileCardBg,
// //                                 colorScheme: ColorScheme.dark(
// //                                   primary: AppColors.primaryPink, // Clock hand, selected hour/minute circle & active button color
// //                                   onPrimary: Colors.white, // Selected numbers text color
// //                                   surface: AppColors.profileCardBg, // Dialog background color
// //                                   onSurface: AppColors.textPrimaryLight, // Unselected numbers & labels text color
// //                                   secondary: AppColors.primaryPink,
// //                                 ),
// //                                 timePickerTheme: TimePickerThemeData(
// //                                   backgroundColor: AppColors.profileCardBg,
// //                                   hourMinuteColor: AppColors.cardDarkBg, // Hour/Minute container bg
// //                                   hourMinuteTextColor: AppColors.primaryPink, // Hour/Minute active text
// //                                   hourMinuteShape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     side: const BorderSide(color: AppColors.cardBorder),
// //                                   ),
// //                                   dayPeriodColor: AppColors.cardDarkBg, // AM/PM box background
// //                                   dayPeriodTextColor: AppColors.textPrimaryLight,
// //                                   dayPeriodBorderSide: const BorderSide(color: AppColors.cardBorder),
// //                                   dayPeriodShape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(10),
// //                                   ),
// //                                   dialBackgroundColor: AppColors.cardDarkBg, // Clock dial wheel background
// //                                   dialHandColor: AppColors.primaryPink, // Clock hand color
// //                                   dialTextColor: AppColors.textPrimaryLight, // Clock numbers text color
// //                                   entryModeIconColor: AppColors.primaryPink, // Mode switch icon
// //                                   cancelButtonStyle: TextButton.styleFrom(
// //                                     foregroundColor: AppColors.textSecondaryLight,
// //                                   ),
// //                                   confirmButtonStyle: TextButton.styleFrom(
// //                                     foregroundColor: AppColors.primaryPink,
// //                                   ),
// //                                 ),
// //                               ),
// //                               child: child!,
// //                             );
// //                           },
// //                         );
// //                         if (picked != null) {
// //                           setModalState(() {
// //                             selectedTime = picked;
// //                           });
// //                         }
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.all(16),
// //                         decoration: BoxDecoration(
// //                           color: AppColors.cardDarkBg,
// //                           borderRadius: BorderRadius.circular(16),
// //                           border: Border.all(color: AppColors.cardBorder),
// //                         ),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             CustomText.medium(
// //                               'Alarm Time',
// //                               fontSize: 14,
// //                               color: AppColors.textSecondaryLight,
// //                             ),
// //                             CustomText.bold(
// //                               selectedTime.format(context),
// //                               fontSize: 22,
// //                               color: AppColors.primaryPink,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     CustomText.medium(
// //                       'Repeat Days',
// //                       fontSize: 14,
// //                       color: AppColors.textSecondaryLight,
// //                     ),
// //                     const SizedBox(height: 10),
// //                     Wrap(
// //                       spacing: 8,
// //                       runSpacing: 8,
// //                       children: _daysList.map((day) {
// //                         final isSelected = selectedDays.contains(day);
// //                         return ChoiceChip(
// //                           label: Text(day.substring(0, 3).toUpperCase()),
// //                           selected: isSelected,
// //                           selectedColor: AppColors.primaryPink,
// //                           backgroundColor: AppColors.cardDarkBg,
// //                           labelStyle: TextStyle(
// //                             color: isSelected
// //                                 ? AppColors.whiteSheetBg
// //                                 : AppColors.textSecondaryLight,
// //                             fontSize: 12,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                             side: BorderSide(
// //                               color: isSelected
// //                                   ? AppColors.primaryPink
// //                                   : AppColors.cardBorder,
// //                             ),
// //                           ),
// //                           showCheckmark: false,
// //                           onSelected: (selected) {
// //                             setModalState(() {
// //                               if (selected) {
// //                                 selectedDays.add(day);
// //                               } else {
// //                                 if (selectedDays.length > 1) {
// //                                   selectedDays.remove(day);
// //                                 }
// //                               }
// //                             });
// //                           },
// //                         );
// //                       }).toList(),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     CustomText.medium(
// //                       'Alarm Message',
// //                       fontSize: 14,
// //                       color: AppColors.textSecondaryLight,
// //                     ),
// //                     const SizedBox(height: 8),
// //                     TextField(
// //                       controller: messageController,
// //                       style: const TextStyle(color: AppColors.textPrimaryLight),
// //                       maxLength: 500,
// //                       decoration: InputDecoration(
// //                         hintText: 'e.g. Wake up for morning routine',
// //                         hintStyle: const TextStyle(
// //                             color: AppColors.textSecondaryLight, fontSize: 13),
// //                         filled: true,
// //                         fillColor: AppColors.cardDarkBg,
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(16),
// //                           borderSide:
// //                           const BorderSide(color: AppColors.cardBorder),
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(16),
// //                           borderSide:
// //                           const BorderSide(color: AppColors.cardBorder),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(16),
// //                           borderSide:
// //                           const BorderSide(color: AppColors.primaryPink),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 20),
// //                     AppBtn(
// //                       height: 52,
// //                       loading: alarmState.isLoading,
// //                       gradient: AppColors.buttonGradient,
// //                       borderRadius: 16,
// //                       onTap: () async {
// //                         final msg = messageController.text.trim();
// //                         if (msg.isEmpty) {
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             const SnackBar(
// //                               content: Text('Please enter an alarm message'),
// //                               backgroundColor: Colors.red,
// //                             ),
// //                           );
// //                           return;
// //                         }
// //
// //                         final success = await ref
// //                             .read(alarmProvider.notifier)
// //                             .createAlarm(
// //                           days: selectedDays.toList(),
// //                           time: formattedTimeStr,
// //                           message: msg,
// //                           timezone: 'Asia/Kolkata',
// //                         );
// //
// //                         if (context.mounted) {
// //                           if (success) {
// //                             Navigator.pop(context);
// //                             _syncFromProvider();
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               const SnackBar(
// //                                 content: Text('Alarm set successfully!'),
// //                                 backgroundColor: Colors.green,
// //                               ),
// //                             );
// //                           } else {
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               SnackBar(
// //                                 content: Text(
// //                                   alarmState.error ??
// //                                       'Failed to set alarm. Try again.',
// //                                 ),
// //                                 backgroundColor: Colors.red,
// //                               ),
// //                             );
// //                           }
// //                         }
// //                       },
// //                       child: CustomText.bold(
// //                         'Save Alarm',
// //                         fontSize: 16,
// //                         color: AppColors.whiteSheetBg,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Future<void> _handleToggle(int index, Items alarm) async {
// //     final alarmId = alarm.sId ?? '';
// //     if (alarmId.isEmpty) return;
// //
// //     final previousValue = alarm.isActive ?? false;
// //
// //     setState(() {
// //       alarm.isActive = !previousValue;
// //       _poppingIds.add(alarmId);
// //     });
// //
// //     Future.delayed(const Duration(milliseconds: 180), () {
// //       if (mounted) setState(() => _poppingIds.remove(alarmId));
// //     });
// //
// //     final ok =
// //     await ref.read(alarmProvider.notifier).toggleAlarmStatus(alarmId);
// //
// //     if (!ok && mounted) {
// //       setState(() {
// //         alarm.isActive = previousValue;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Could not update alarm. Try again.'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// //
// //   // 🔴 Delete Confirmation Dialog Function
// //   Future<bool> _confirmDeleteDialog() async {
// //     return await showDialog<bool>(
// //       context: context,
// //       builder: (BuildContext dialogContext) {
// //         return AlertDialog(
// //           backgroundColor: AppColors.profileCardBg,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(20),
// //             side: const BorderSide(color: AppColors.cardBorder),
// //           ),
// //           title: CustomText.bold(
// //             'Delete Alarm?',
// //             fontSize: 18,
// //             color: AppColors.textPrimaryLight,
// //           ),
// //           content: CustomText.medium(
// //             'Are you sure you want to delete this alarm?',
// //             fontSize: 14,
// //             color: AppColors.textSecondaryLight,
// //           ),
// //           actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(dialogContext).pop(false),
// //               child: CustomText.semiBold(
// //                 'Cancel',
// //                 color: AppColors.textSecondaryLight,
// //                 fontSize: 14,
// //               ),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.redAccent,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //               ),
// //               onPressed: () => Navigator.of(dialogContext).pop(true),
// //               child: CustomText.semiBold(
// //                 'Delete',
// //                 color: Colors.white,
// //                 fontSize: 14,
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     ) ??
// //         false;
// //   }
// //
// //   Future<void> _handleDelete(int index) async {
// //     if (index < 0 || index >= _items.length) return;
// //     final removed = _items[index];
// //     final alarmId = removed.sId ?? '';
// //
// //     setState(() => _items.removeAt(index));
// //     _listKey.currentState?.removeItem(
// //       index,
// //           (context, animation) => _buildAnimatedTile(removed, animation),
// //       duration: const Duration(milliseconds: 250),
// //     );
// //
// //     if (alarmId.isEmpty) return;
// //
// //     final ok = await ref.read(alarmProvider.notifier).removeAlarm(alarmId);
// //
// //     if (!ok && mounted) {
// //       setState(() => _items.insert(index, removed));
// //       _listKey.currentState?.insertItem(
// //         index,
// //         duration: const Duration(milliseconds: 250),
// //       );
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Could not delete alarm. Try again.'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// //
// //   Widget _buildAnimatedTile(Items alarm, Animation<double> animation) {
// //     final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
// //     return ScaleTransition(
// //       scale: curved,
// //       child: FadeTransition(
// //         opacity: animation,
// //         child: Padding(
// //           padding: const EdgeInsets.only(bottom: 12),
// //           child: _buildAlarmTile(alarm),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.bgBlack,
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const HugeIcon(
// //             icon: HugeIcons.strokeRoundedArrowLeft01,
// //             color: AppColors.textPrimaryLight,
// //             size: 24.0,
// //           ),
// //           onPressed: () => Navigator.maybePop(context),
// //         ),
// //         title: CustomText.bold(
// //           'Alarms',
// //           fontSize: 18,
// //           color: AppColors.textPrimaryLight,
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
// //           child: Column(
// //             children: [
// //               Expanded(child: _buildBody()),
// //               const SizedBox(height: 12),
// //               AppBtn(
// //                 onTap: () => _showAddAlarmBottomSheet(context),
// //                 borderRadius: 12,
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const HugeIcon(
// //                       icon: HugeIcons.strokeRoundedAddCircle,
// //                       color: AppColors.textPrimaryLight,
// //                       size: 20.0,
// //                     ),
// //                     const SizedBox(width: 8),
// //                     CustomText.semiBold(
// //                       'Add Alarm',
// //                       fontSize: 16,
// //                       color: AppColors.textPrimaryLight,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBody() {
// //     if (_initialLoading) {
// //       return const Center(
// //         child: CircularProgressIndicator(color: AppColors.primaryPink),
// //       );
// //     }
// //
// //     if (_hasError) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             CustomText.medium(
// //               'Failed to load alarms',
// //               color: AppColors.textSecondaryLight,
// //               fontSize: 14,
// //             ),
// //             const SizedBox(height: 12),
// //             AppBtn(
// //               width: 120,
// //               height: 40,
// //               color: AppColors.primaryPink,
// //               title: 'Retry',
// //               onTap: () async {
// //                 setState(() => _initialLoading = true);
// //                 await ref.read(alarmProvider.notifier).fetchAlarms();
// //                 _syncFromProvider(initial: true);
// //               },
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //
// //     if (_items.isEmpty) {
// //       return Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const HugeIcon(
// //             icon: HugeIcons.strokeRoundedClock01,
// //             color: AppColors.textSecondaryLight,
// //             size: 90.0,
// //           ),
// //           const SizedBox(height: 20),
// //           CustomText.medium(
// //             'No alarms set',
// //             fontSize: 16,
// //             color: AppColors.textSecondaryLight,
// //             textAlign: TextAlign.center,
// //           ),
// //         ],
// //       );
// //     }
// //
// //     return AnimatedList(
// //       key: _listKey,
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       initialItemCount: _items.length,
// //       itemBuilder: (context, index, animation) {
// //         if (index >= _items.length) return const SizedBox.shrink();
// //         return _buildAnimatedTile(_items[index], animation);
// //       },
// //     );
// //   }
// //
// //   Widget _buildAlarmTile(Items alarm) {
// //     final String timeStr = alarm.time ?? '00:00';
// //     final List<String> days = alarm.days ?? [];
// //     final String formattedDays =
// //     days.map((d) => d.substring(0, 3).toUpperCase()).join(', ');
// //
// //     final bool isActive = alarm.isActive ?? false;
// //     final String alarmId = alarm.sId ?? '';
// //     final bool isPopping = _poppingIds.contains(alarmId);
// //     final int index = _items.indexWhere((e) => e.sId == alarmId);
// //
// //     return AnimatedScale(
// //       scale: isPopping ? 1.04 : 1.0,
// //       duration: const Duration(milliseconds: 150),
// //       curve: Curves.easeOut,
// //       child: Dismissible(
// //         key: Key(alarmId.isNotEmpty ? alarmId : UniqueKey().toString()),
// //         direction: DismissDirection.endToStart,
// //         confirmDismiss: (direction) async {
// //           return await _confirmDeleteDialog();
// //         },
// //         background: Container(
// //           alignment: Alignment.centerRight,
// //           padding: const EdgeInsets.only(right: 20),
// //           decoration: BoxDecoration(
// //             color: Colors.red.withOpacity(0.8),
// //             borderRadius: BorderRadius.circular(18),
// //           ),
// //           child: const Icon(Icons.delete, color: Colors.white),
// //         ),
// //         onDismissed: (_) => _handleDelete(index),
// //         child: AnimatedContainer(
// //           duration: const Duration(milliseconds: 200),
// //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
// //           decoration: BoxDecoration(
// //             color: AppColors.profileCardBg,
// //             borderRadius: BorderRadius.circular(18),
// //             border: Border.all(
// //               color: isActive
// //                   ? AppColors.primaryPink.withOpacity(0.3)
// //                   : AppColors.cardBorder,
// //             ),
// //           ),
// //           child: Row(
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     CustomText.bold(
// //                       timeStr,
// //                       fontSize: 28,
// //                       color: isActive
// //                           ? AppColors.textPrimaryLight
// //                           : AppColors.textSecondaryLight,
// //                     ),
// //                     const SizedBox(height: 4),
// //                     CustomText.medium(
// //                       formattedDays.isNotEmpty ? formattedDays : 'Everyday',
// //                       fontSize: 12,
// //                       color: AppColors.primaryPink,
// //                     ),
// //                     if (alarm.message != null && alarm.message!.isNotEmpty) ...[
// //                       const SizedBox(height: 6),
// //                       CustomText.regular(
// //                         alarm.message!,
// //                         fontSize: 13,
// //                         color: AppColors.textSecondaryLight,
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                     ],
// //                   ],
// //                 ),
// //               ),
// //               IconButton(
// //                 icon: const HugeIcon(
// //                   icon: HugeIcons.strokeRoundedDelete02,
// //                   color: Colors.redAccent,
// //                   size: 20.0,
// //                 ),
// //                 onPressed: () async {
// //                   final confirm = await _confirmDeleteDialog();
// //                   if (confirm) {
// //                     _handleDelete(index);
// //                   }
// //                 },
// //               ),
// //               Switch(
// //                 value: isActive,
// //                 activeColor: AppColors.primaryPink,
// //                 inactiveTrackColor: AppColors.cardDarkBg,
// //                 onChanged: (_) => _handleToggle(index, alarm),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
// import 'package:infinity_love/features/alarm/provider/alram_provider.dart';
//
// import '../../core/constants/app_btn.dart';
// import '../../core/constants/const_text.dart';
// import 'model/alram_model.dart';
//
// class AlarmsScreen extends ConsumerStatefulWidget {
//   const AlarmsScreen({super.key});
//
//   @override
//   ConsumerState<AlarmsScreen> createState() => _AlarmsScreenState();
// }
//
// class _AlarmsScreenState extends ConsumerState<AlarmsScreen> {
//   // 🟢 Short labels with corresponding full day keys
//   final List<Map<String, String>> _daysMapList = [
//     {'short': 'S', 'full': 'sunday'},
//     {'short': 'M', 'full': 'monday'},
//     {'short': 'T', 'full': 'tuesday'},
//     {'short': 'W', 'full': 'wednesday'},
//     {'short': 'T', 'full': 'thursday'},
//     {'short': 'F', 'full': 'friday'},
//     {'short': 'S', 'full': 'saturday'},
//   ];
//
//   final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//   final List<Items> _items = [];
//   bool _initialLoading = true;
//   bool _hasError = false;
//
//   final Set<String> _poppingIds = {};
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       await ref.read(alarmProvider.notifier).fetchAlarms();
//       _syncFromProvider(initial: true);
//     });
//   }
//
//   String _formatTimeOfDay(TimeOfDay time) {
//     final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
//     final minute = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '${hour.toString().padLeft(2, '0')}:$minute $period';
//   }
//
//   String _formatStringTimeToAMPM(String? timeStr) {
//     if (timeStr == null || timeStr.isEmpty) return '12:00 AM';
//     if (timeStr.contains('AM') || timeStr.contains('PM')) return timeStr;
//
//     final parts = timeStr.split(':');
//     if (parts.length < 2) return timeStr;
//
//     int hour = int.tryParse(parts[0]) ?? 0;
//     int minute = int.tryParse(parts[1].split(' ')[0]) ?? 0;
//
//     final period = hour >= 12 ? 'PM' : 'AM';
//     hour = hour % 12;
//     if (hour == 0) hour = 12;
//
//     return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
//   }
//
//   void _syncFromProvider({bool initial = false}) {
//     final asyncAlarmList = ref.read(alarmProvider).alarmList;
//     asyncAlarmList.when(
//       data: (model) {
//         final items = model?.data?.items ?? [];
//         setState(() {
//           _items
//             ..clear()
//             ..addAll(items);
//           _initialLoading = false;
//           _hasError = false;
//         });
//         _listKey.currentState?.setState(() {});
//       },
//       loading: () {
//         if (initial) {
//           setState(() => _initialLoading = true);
//         }
//       },
//       error: (_, __) {
//         setState(() {
//           _initialLoading = false;
//           _hasError = true;
//         });
//       },
//     );
//   }
//
//   void _showAddAlarmBottomSheet(BuildContext context) {
//     TimeOfDay selectedTime = TimeOfDay.now();
//     final Set<String> selectedDays = {};
//     final TextEditingController messageController = TextEditingController();
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: AppColors.profileCardBg,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             final alarmState = ref.watch(alarmProvider);
//
//             return Padding(
//               padding: EdgeInsets.only(
//                 left: 20.0,
//                 right: 20.0,
//                 top: 20.0,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CustomText.bold(
//                           'Set New Alarm',
//                           fontSize: 18,
//                           color: AppColors.textPrimaryLight,
//                         ),
//                         IconButton(
//                           icon: const HugeIcon(
//                             icon: HugeIcons.strokeRoundedCancel01,
//                             color: AppColors.textSecondaryLight,
//                             size: 20,
//                           ),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     InkWell(
//                       borderRadius: BorderRadius.circular(20),
//                       onTap: () async {
//                         final TimeOfDay? picked = await showTimePicker(
//                           context: context,
//                           initialTime: selectedTime,
//                           builder: (context, child) {
//                             return MediaQuery(
//                               // 🟢 FORCE 12-Hour Mode (AM/PM Selection Mode)
//                               data: MediaQuery.of(context).copyWith(
//                                 alwaysUse24HourFormat: false,
//                               ),
//                               child: Theme(
//                                 data: Theme.of(context).copyWith(
//                                   scaffoldBackgroundColor: AppColors.profileCardBg,
//                                   colorScheme: const ColorScheme.dark(
//                                     primary: AppColors.primaryPink,
//                                     onPrimary: Colors.white,
//                                     surface: AppColors.profileCardBg,
//                                     onSurface: AppColors.textPrimaryLight,
//                                     secondary: AppColors.primaryPink,
//                                   ),
//                                   timePickerTheme: TimePickerThemeData(
//                                     backgroundColor: AppColors.profileCardBg,
//                                     hourMinuteColor: AppColors.cardDarkBg,
//                                     hourMinuteTextColor: AppColors.primaryPink,
//                                     hourMinuteShape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       side: const BorderSide(color: AppColors.cardBorder),
//                                     ),
//                                     dayPeriodColor: WidgetStateColor.resolveWith((states) {
//                                       if (states.contains(WidgetState.selected)) {
//                                         return AppColors.primaryPink; // Selected AM/PM background
//                                       }
//                                       return AppColors.cardDarkBg; // Unselected AM/PM background
//                                     }),
//                                     dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
//                                       if (states.contains(WidgetState.selected)) {
//                                         return Colors.white; // Selected AM/PM text
//                                       }
//                                       return AppColors.textSecondaryLight; // Unselected AM/PM text
//                                     }),
//                                     dayPeriodBorderSide: const BorderSide(color: AppColors.cardBorder),
//                                     dayPeriodShape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     dialBackgroundColor: AppColors.cardDarkBg,
//                                     dialHandColor: AppColors.primaryPink,
//                                     dialTextColor: AppColors.textPrimaryLight,
//                                     entryModeIconColor: AppColors.primaryPink,
//                                     cancelButtonStyle: TextButton.styleFrom(
//                                       foregroundColor: AppColors.textSecondaryLight,
//                                     ),
//                                     confirmButtonStyle: TextButton.styleFrom(
//                                       foregroundColor: AppColors.primaryPink,
//                                     ),
//                                   ),
//                                 ),
//                                 child: child!,
//                               ),
//                             );
//                           },
//                         );
//                         if (picked != null) {
//                           setModalState(() {
//                             selectedTime = picked;
//                           });
//                         }
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: AppColors.cardDarkBg,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(color: AppColors.cardBorder),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CustomText.medium(
//                               'Alarm Time',
//                               fontSize: 14,
//                               color: AppColors.textSecondaryLight,
//                             ),
//                             CustomText.bold(
//                               _formatTimeOfDay(selectedTime),
//                               fontSize: 22,
//                               color: AppColors.primaryPink,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     CustomText.medium(
//                       'Repeat Days',
//                       fontSize: 14,
//                       color: AppColors.textSecondaryLight,
//                     ),
//                     const SizedBox(height: 10),
//                     FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: SizedBox(
//                         width: MediaQuery.of(context).size.width - 32,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: _daysMapList.map((dayMap) {
//                             final shortName = dayMap['short']!;
//                             final fullKey = dayMap['full']!;
//                             final isSelected = selectedDays.contains(fullKey);
//
//                             return ChoiceChip(
//                               label: Text(shortName),
//                               selected: isSelected,
//                               selectedColor: AppColors.primaryPink,
//                               backgroundColor: AppColors.cardDarkBg,
//                               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                               visualDensity: VisualDensity.compact,
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                               labelPadding: EdgeInsets.zero,
//                               labelStyle: TextStyle(
//                                 color: isSelected
//                                     ? AppColors.whiteSheetBg
//                                     : AppColors.textSecondaryLight,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 side: BorderSide(
//                                   color: isSelected
//                                       ? AppColors.primaryPink
//                                       : AppColors.cardBorder,
//                                 ),
//                               ),
//                               showCheckmark: false,
//                               onSelected: (selected) {
//                                 setModalState(() {
//                                   if (selected) {
//                                     selectedDays.add(fullKey);
//                                   } else {
//                                     selectedDays.remove(fullKey);
//                                   }
//                                 });
//                               },
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     CustomText.medium(
//                       'Alarm Message',
//                       fontSize: 14,
//                       color: AppColors.textSecondaryLight,
//                     ),
//                     const SizedBox(height: 8),
//                     TextField(
//                       controller: messageController,
//                       style: const TextStyle(color: AppColors.textPrimaryLight),
//                       maxLength: 500,
//                       decoration: InputDecoration(
//                         hintText: 'e.g. Wake up for morning routine',
//                         hintStyle: const TextStyle(
//                             color: AppColors.textSecondaryLight, fontSize: 13),
//                         filled: true,
//                         fillColor: AppColors.cardDarkBg,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           borderSide:
//                           const BorderSide(color: AppColors.cardBorder),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           borderSide:
//                           const BorderSide(color: AppColors.cardBorder),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(16),
//                           borderSide:
//                           const BorderSide(color: AppColors.primaryPink),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     AppBtn(
//                       height: 52,
//                       loading: alarmState.isLoading,
//                       gradient: AppColors.buttonGradient,
//                       borderRadius: 16,
//                       onTap: () async {
//                         if (selectedDays.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please select at least one day'),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                           return;
//                         }
//
//                         final msg = messageController.text.trim();
//                         if (msg.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please enter an alarm message'),
//                               backgroundColor: Colors.red,
//                             ),
//                           );
//                           return;
//                         }
//
//                         final formattedTimeStr =
//                             '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
//
//                         final success = await ref
//                             .read(alarmProvider.notifier)
//                             .createAlarm(
//                           days: selectedDays.toList(),
//                           time: formattedTimeStr,
//                           message: msg,
//                           modelId: ,
//                           timezone: 'Asia/Kolkata',
//                         );
//
//                         if (context.mounted) {
//                           if (success) {
//                             Navigator.pop(context);
//                             _syncFromProvider();
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Alarm set successfully!'),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   alarmState.error ??
//                                       'Failed to set alarm. Try again.',
//                                 ),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         }
//                       },
//                       child: CustomText.bold(
//                         'Save Alarm',
//                         fontSize: 16,
//                         color: AppColors.whiteSheetBg,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _handleToggle(int index, Items alarm) async {
//     final alarmId = alarm.sId ?? '';
//     if (alarmId.isEmpty) return;
//
//     final previousValue = alarm.isActive ?? false;
//
//     setState(() {
//       alarm.isActive = !previousValue;
//       _poppingIds.add(alarmId);
//     });
//
//     Future.delayed(const Duration(milliseconds: 180), () {
//       if (mounted) setState(() => _poppingIds.remove(alarmId));
//     });
//
//     final ok =
//     await ref.read(alarmProvider.notifier).toggleAlarmStatus(alarmId);
//
//     if (!ok && mounted) {
//       setState(() {
//         alarm.isActive = previousValue;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Could not update alarm. Try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Future<bool> _confirmDeleteDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           backgroundColor: AppColors.profileCardBg,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: const BorderSide(color: AppColors.cardBorder),
//           ),
//           title: CustomText.bold(
//             'Delete Alarm?',
//             fontSize: 18,
//             color: AppColors.textPrimaryLight,
//           ),
//           content: CustomText.medium(
//             'Are you sure you want to delete this alarm?',
//             fontSize: 14,
//             color: AppColors.textSecondaryLight,
//           ),
//           actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(false),
//               child: CustomText.semiBold(
//                 'Cancel',
//                 color: AppColors.textSecondaryLight,
//                 fontSize: 14,
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () => Navigator.of(dialogContext).pop(true),
//               child: CustomText.semiBold(
//                 'Delete',
//                 color: Colors.white,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         );
//       },
//     ) ??
//         false;
//   }
//
//   Future<void> _handleDelete(int index) async {
//     if (index < 0 || index >= _items.length) return;
//     final removed = _items[index];
//     final alarmId = removed.sId ?? '';
//
//     setState(() => _items.removeAt(index));
//     _listKey.currentState?.removeItem(
//       index,
//           (context, animation) => _buildAnimatedTile(removed, animation),
//       duration: const Duration(milliseconds: 250),
//     );
//
//     if (alarmId.isEmpty) return;
//
//     final ok = await ref.read(alarmProvider.notifier).removeAlarm(alarmId);
//
//     if (!ok && mounted) {
//       setState(() => _items.insert(index, removed));
//       _listKey.currentState?.insertItem(
//         index,
//         duration: const Duration(milliseconds: 250),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Could not delete alarm. Try again.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Widget _buildAnimatedTile(Items alarm, Animation<double> animation) {
//     final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
//     return ScaleTransition(
//       scale: curved,
//       child: FadeTransition(
//         opacity: animation,
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: _buildAlarmTile(alarm),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgBlack,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const HugeIcon(
//             icon: HugeIcons.strokeRoundedArrowLeft01,
//             color: AppColors.textPrimaryLight,
//             size: 24.0,
//           ),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//         title: CustomText.bold(
//           'Alarms',
//           fontSize: 18,
//           color: AppColors.textPrimaryLight,
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
//           child: Column(
//             children: [
//               Expanded(child: _buildBody()),
//               const SizedBox(height: 12),
//               AppBtn(
//                 onTap: () => _showAddAlarmBottomSheet(context),
//                 borderRadius: 12,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const HugeIcon(
//                       icon: HugeIcons.strokeRoundedAddCircle,
//                       color: AppColors.textPrimaryLight,
//                       size: 20.0,
//                     ),
//                     const SizedBox(width: 8),
//                     CustomText.semiBold(
//                       'Add Alarm',
//                       fontSize: 16,
//                       color: AppColors.textPrimaryLight,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     if (_initialLoading) {
//       return const Center(
//         child: CircularProgressIndicator(color: AppColors.primaryPink),
//       );
//     }
//
//     if (_hasError) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CustomText.medium(
//               'Failed to load alarms',
//               color: AppColors.textSecondaryLight,
//               fontSize: 14,
//             ),
//             const SizedBox(height: 12),
//             AppBtn(
//               width: 120,
//               height: 40,
//               color: AppColors.primaryPink,
//               title: 'Retry',
//               onTap: () async {
//                 setState(() => _initialLoading = true);
//                 await ref.read(alarmProvider.notifier).fetchAlarms();
//                 _syncFromProvider(initial: true);
//               },
//             ),
//           ],
//         ),
//       );
//     }
//
//     if (_items.isEmpty) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const HugeIcon(
//             icon: HugeIcons.strokeRoundedClock01,
//             color: AppColors.textSecondaryLight,
//             size: 90.0,
//           ),
//           const SizedBox(height: 20),
//           CustomText.medium(
//             'No alarms set',
//             fontSize: 16,
//             color: AppColors.textSecondaryLight,
//             textAlign: TextAlign.center,
//           ),
//         ],
//       );
//     }
//
//     return AnimatedList(
//       key: _listKey,
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       initialItemCount: _items.length,
//       itemBuilder: (context, index, animation) {
//         if (index >= _items.length) return const SizedBox.shrink();
//         return _buildAnimatedTile(_items[index], animation);
//       },
//     );
//   }
//
//   Widget _buildAlarmTile(Items alarm) {
//     final String timeStr = _formatStringTimeToAMPM(alarm.time);
//     final List<String> days = alarm.days ?? [];
//     final String formattedDays =
//     days.map((d) => d.substring(0, 3).toUpperCase()).join(', ');
//
//     final bool isActive = alarm.isActive ?? false;
//     final String alarmId = alarm.sId ?? '';
//     final bool isPopping = _poppingIds.contains(alarmId);
//     final int index = _items.indexWhere((e) => e.sId == alarmId);
//
//     return AnimatedScale(
//       scale: isPopping ? 1.04 : 1.0,
//       duration: const Duration(milliseconds: 150),
//       curve: Curves.easeOut,
//       child: Dismissible(
//         key: Key(alarmId.isNotEmpty ? alarmId : UniqueKey().toString()),
//         direction: DismissDirection.endToStart,
//         confirmDismiss: (direction) async {
//           return await _confirmDeleteDialog();
//         },
//         background: Container(
//           alignment: Alignment.centerRight,
//           padding: const EdgeInsets.only(right: 20),
//           decoration: BoxDecoration(
//             color: Colors.red.withOpacity(0.8),
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: const Icon(Icons.delete, color: Colors.white),
//         ),
//         onDismissed: (_) => _handleDelete(index),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//           decoration: BoxDecoration(
//             color: AppColors.profileCardBg,
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(
//               color: isActive
//                   ? AppColors.primaryPink.withOpacity(0.3)
//                   : AppColors.cardBorder,
//             ),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText.bold(
//                       timeStr,
//                       fontSize: 26,
//                       color: isActive
//                           ? AppColors.textPrimaryLight
//                           : AppColors.textSecondaryLight,
//                     ),
//                     const SizedBox(height: 4),
//                     CustomText.medium(
//                       formattedDays.isNotEmpty ? formattedDays : 'Everyday',
//                       fontSize: 12,
//                       color: AppColors.primaryPink,
//                     ),
//                     if (alarm.message != null && alarm.message!.isNotEmpty) ...[
//                       const SizedBox(height: 6),
//                       CustomText.regular(
//                         alarm.message!,
//                         fontSize: 13,
//                         color: AppColors.textSecondaryLight,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: const HugeIcon(
//                   icon: HugeIcons.strokeRoundedDelete02,
//                   color: Colors.redAccent,
//                   size: 20.0,
//                 ),
//                 onPressed: () async {
//                   final confirm = await _confirmDeleteDialog();
//                   if (confirm) {
//                     _handleDelete(index);
//                   }
//                 },
//               ),
//               Switch(
//                 value: isActive,
//                 activeColor: AppColors.primaryPink,
//                 inactiveTrackColor: AppColors.cardDarkBg,
//                 onChanged: (_) => _handleToggle(index, alarm),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/core/utils/utils.dart';
import 'package:infinity_love/features/alarm/provider/alram_provider.dart';

import '../../core/constants/app_btn.dart';
import '../../core/constants/const_text.dart';
import '../home/model/conversation_model.dart' hide Items;
import '../home/provider/features_provider.dart';
import 'model/alram_model.dart';

class AlarmsScreen extends ConsumerStatefulWidget {
  const AlarmsScreen({super.key});

  @override
  ConsumerState<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends ConsumerState<AlarmsScreen> {
  // 🟢 Short labels with corresponding full day keys
  final List<Map<String, String>> _daysMapList = [
    {'short': 'S', 'full': 'sunday'},
    {'short': 'M', 'full': 'monday'},
    {'short': 'T', 'full': 'tuesday'},
    {'short': 'W', 'full': 'wednesday'},
    {'short': 'T', 'full': 'thursday'},
    {'short': 'F', 'full': 'friday'},
    {'short': 'S', 'full': 'saturday'},
  ];

  final Set<String> _poppingIds = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(alarmProvider.notifier).fetchAlarms();
      ref.read(featuresProvider.notifier).fetchConversationList();
    });
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  String _formatStringTimeToAMPM(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return '12:00 AM';
    if (timeStr.contains('AM') || timeStr.contains('PM')) return timeStr;

    final parts = timeStr.split(':');
    if (parts.length < 2) return timeStr;

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1].split(' ')[0]) ?? 0;

    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  void _showAddAlarmBottomSheet(BuildContext screenContext) {
    TimeOfDay selectedTime = TimeOfDay.now();
    final Set<String> selectedDays = {};
    final TextEditingController messageController = TextEditingController();
    String? selectedModelId;

    showModalBottomSheet(
      context: screenContext,
      isScrollControlled: true,
      backgroundColor: AppColors.profileCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final alarmState = ref.watch(alarmProvider);

            return Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText.bold(
                          'Set New Alarm',
                          fontSize: 18,
                          color: AppColors.textPrimaryLight,
                        ),
                        IconButton(
                          icon: const HugeIcon(
                            icon: HugeIcons.strokeRoundedCancel01,
                            color: AppColors.textSecondaryLight,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🟢 Time Picker
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                alwaysUse24HourFormat: false,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  scaffoldBackgroundColor:
                                  AppColors.profileCardBg,
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColors.primaryPink,
                                    onPrimary: Colors.white,
                                    surface: AppColors.profileCardBg,
                                    onSurface: AppColors.textPrimaryLight,
                                    secondary: AppColors.primaryPink,
                                  ),
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: AppColors.profileCardBg,
                                    hourMinuteColor: AppColors.cardDarkBg,
                                    hourMinuteTextColor: AppColors.primaryPink,
                                    hourMinuteShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: AppColors.cardBorder),
                                    ),
                                    dayPeriodColor:
                                    WidgetStateColor.resolveWith((states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return AppColors.primaryPink;
                                      }
                                      return AppColors.cardDarkBg;
                                    }),
                                    dayPeriodTextColor:
                                    WidgetStateColor.resolveWith((states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return Colors.white;
                                      }
                                      return AppColors.textSecondaryLight;
                                    }),
                                    dayPeriodBorderSide: const BorderSide(
                                        color: AppColors.cardBorder),
                                    dayPeriodShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    dialBackgroundColor: AppColors.cardDarkBg,
                                    dialHandColor: AppColors.primaryPink,
                                    dialTextColor: AppColors.textPrimaryLight,
                                    entryModeIconColor: AppColors.primaryPink,
                                    cancelButtonStyle: TextButton.styleFrom(
                                      foregroundColor:
                                      AppColors.textSecondaryLight,
                                    ),
                                    confirmButtonStyle: TextButton.styleFrom(
                                      foregroundColor: AppColors.primaryPink,
                                    ),
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                          },
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardDarkBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText.medium(
                              'Alarm Time',
                              fontSize: 14,
                              color: AppColors.textSecondaryLight,
                            ),
                            CustomText.bold(
                              _formatTimeOfDay(selectedTime),
                              fontSize: 22,
                              color: AppColors.primaryPink,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🟢 Repeat Days
                    CustomText.medium(
                      'Repeat Days',
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _daysMapList.map((dayMap) {
                            final shortName = dayMap['short']!;
                            final fullKey = dayMap['full']!;
                            final isSelected = selectedDays.contains(fullKey);

                            return ChoiceChip(
                              label: Text(shortName),
                              selected: isSelected,
                              selectedColor: AppColors.primaryPink,
                              backgroundColor: AppColors.cardDarkBg,
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              labelPadding: EdgeInsets.zero,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.whiteSheetBg
                                    : AppColors.textSecondaryLight,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primaryPink
                                      : AppColors.cardBorder,
                                ),
                              ),
                              showCheckmark: false,
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    selectedDays.add(fullKey);
                                  } else {
                                    selectedDays.remove(fullKey);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🟢 Companion Picker
                    CustomText.medium(
                      'Select Companion',
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 84,
                      child: Consumer(
                        builder: (context, ref, _) {
                          final featuresState = ref.watch(featuresProvider);
                          return featuresState.conversationList.when(
                            loading: () => const Center(
                              child: CupertinoActivityIndicator(
                                  color: AppColors.primaryPink),
                            ),
                            error: (_, __) => CustomText.regular(
                              'Failed to load companions',
                              fontSize: 12,
                              color: AppColors.textSecondaryLight,
                            ),
                            data: (ConversationModel? model) {
                              final conversations = model?.data?.items ?? [];
                              if (conversations.isEmpty) {
                                return CustomText.regular(
                                  'No companions found',
                                  fontSize: 12,
                                  color: AppColors.textSecondaryLight,
                                );
                              }
                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: conversations.length,
                                separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final item = conversations[index];

                                  final targetId = item.chatEntityId ??
                                      item.companionId?.sId ??
                                      item.sId;
                                  final companionName = item.entityName ??
                                      item.companionId?.name ??
                                      'Companion';
                                  final companionImage = item.entityImage ??
                                      item.companionId?.image ??
                                      item.companionId?.avatar ??
                                      '';

                                  final isSelected =
                                      selectedModelId == targetId;
                                  final hasImage = companionImage.isNotEmpty;

                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectedModelId = targetId;
                                      });
                                    },
                                    child: SizedBox(
                                      width: 64,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppColors.primaryPink
                                                    : AppColors.cardBorder,
                                                width: isSelected ? 2 : 1,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                              radius: 26,
                                              backgroundColor:
                                              AppColors.cardDarkBg,
                                              child: ClipOval(
                                                child: hasImage
                                                    ? Image.network(
                                                  companionImage,
                                                  width: 52,
                                                  height: 52,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (_, __, ___) =>
                                                  const Icon(
                                                    Icons.person,
                                                    color: AppColors
                                                        .textSecondaryLight,
                                                  ),
                                                )
                                                    : const Icon(
                                                  Icons.person,
                                                  color: AppColors
                                                      .textSecondaryLight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          CustomText.medium(
                                            companionName,
                                            fontSize: 11,
                                            color: isSelected
                                                ? AppColors.primaryPink
                                                : AppColors.textSecondaryLight,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🟢 Alarm Message Input
                    CustomText.medium(
                      'Alarm Message',
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: messageController,
                      style: const TextStyle(color: AppColors.textPrimaryLight),
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: 'e.g. Wake up for morning routine',
                        hintStyle: const TextStyle(
                            color: AppColors.textSecondaryLight, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.cardDarkBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                          const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                          const BorderSide(color: AppColors.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                          const BorderSide(color: AppColors.primaryPink),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🟢 Save Button with Utils Alert
                    AppBtn(
                      height: 52,
                      loading: alarmState.isLoading,
                      gradient: AppColors.buttonGradient,
                      borderRadius: 16,
                      onTap: () async {
                        if (selectedDays.isEmpty) {
                          Utils.showErrorMessage(context, 'Please select at least one day');
                          return;
                        }

                        if (selectedModelId == null ||
                            selectedModelId!.isEmpty) {
                          Utils.showErrorMessage(context, 'Please select a companion');
                          return;
                        }

                        final msg = messageController.text.trim();
                        if (msg.isEmpty) {
                          Utils.showErrorMessage(context, 'Please enter an alarm message');
                          return;
                        }

                        final formattedTimeStr =
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

                        final success = await ref
                            .read(alarmProvider.notifier)
                            .createAlarm(
                          days: selectedDays.toList(),
                          time: formattedTimeStr,
                          message: msg,
                          modelId: selectedModelId!,
                          timezone: 'Asia/Kolkata',
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }

                        if (screenContext.mounted) {
                          if (success) {
                            await ref.read(alarmProvider.notifier).fetchAlarms();
                            if (screenContext.mounted) {
                              Utils.showSuccessMessage(screenContext, 'Alarm set successfully!');
                            }
                          } else {
                            Utils.showErrorMessage(
                              screenContext,
                              alarmState.error ?? 'Failed to set alarm. Try again.',
                            );
                          }
                        }
                      },
                      child: CustomText.bold(
                        'Save Alarm',
                        fontSize: 16,
                        color: AppColors.whiteSheetBg,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleToggle(Items alarm) async {
    final alarmId = alarm.sId ?? '';
    if (alarmId.isEmpty) return;

    final previousValue = alarm.isActive ?? false;

    setState(() {
      alarm.isActive = !previousValue;
      _poppingIds.add(alarmId);
    });

    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _poppingIds.remove(alarmId));
    });

    final ok =
    await ref.read(alarmProvider.notifier).toggleAlarmStatus(alarmId);

    if (!ok && mounted) {
      setState(() {
        alarm.isActive = previousValue;
      });
      Utils.showErrorMessage(context, 'Could not update alarm. Try again.');
    }
  }

  Future<bool> _confirmDeleteDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.profileCardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          title: CustomText.bold(
            'Delete Alarm?',
            fontSize: 18,
            color: AppColors.textPrimaryLight,
          ),
          content: CustomText.medium(
            'Are you sure you want to delete this alarm?',
            fontSize: 14,
            color: AppColors.textSecondaryLight,
          ),
          actionsPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: CustomText.semiBold(
                'Cancel',
                color: AppColors.textSecondaryLight,
                fontSize: 14,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: CustomText.semiBold(
                'Delete',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  Future<void> _handleDelete(Items alarm) async {
    final alarmId = alarm.sId ?? '';
    if (alarmId.isEmpty) return;

    final ok = await ref.read(alarmProvider.notifier).removeAlarm(alarmId);

    if (ok && mounted) {
      ref.read(alarmProvider.notifier).fetchAlarms();
      Utils.showSuccessMessage(context, 'Alarm deleted successfully');
    } else if (!ok && mounted) {
      Utils.showErrorMessage(context, 'Could not delete alarm. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimaryLight,
            size: 24.0,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: CustomText.bold(
          'Alarms',
          fontSize: 18,
          color: AppColors.textPrimaryLight,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              Expanded(child: _buildBody()),
              const SizedBox(height: 12),
              AppBtn(
                onTap: () => _showAddAlarmBottomSheet(context),
                borderRadius: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedAddCircle,
                      color: AppColors.textPrimaryLight,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8),
                    CustomText.semiBold(
                      'Add Alarm',
                      fontSize: 16,
                      color: AppColors.textPrimaryLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final alarmState = ref.watch(alarmProvider);

    return alarmState.alarmList.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryPink),
      ),
      error: (_, __) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText.medium(
              'Failed to load alarms',
              color: AppColors.textSecondaryLight,
              fontSize: 14,
            ),
            const SizedBox(height: 12),
            AppBtn(
              width: 120,
              height: 40,
              color: AppColors.primaryPink,
              title: 'Retry',
              onTap: () => ref.read(alarmProvider.notifier).fetchAlarms(),
            ),
          ],
        ),
      ),
      data: (model) {
        final items = model?.data?.items ?? [];

        if (items.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedClock01,
                color: AppColors.textSecondaryLight,
                size: 90.0,
              ),
              const SizedBox(height: 20),
              CustomText.medium(
                'No alarms set',
                fontSize: 16,
                color: AppColors.textSecondaryLight,
                textAlign: TextAlign.center,
              ),
            ],
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final alarm = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildAlarmTile(alarm),
            );
          },
        );
      },
    );
  }

  Widget _buildAlarmTile(Items alarm) {
    final String timeStr = _formatStringTimeToAMPM(alarm.time);
    final List<String> days = alarm.days ?? [];
    final String formattedDays =
    days.map((d) => d.substring(0, 3).toUpperCase()).join(', ');

    final bool isActive = alarm.isActive ?? false;
    final String alarmId = alarm.sId ?? '';
    final bool isPopping = _poppingIds.contains(alarmId);

    return AnimatedScale(
      scale: isPopping ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Dismissible(
        key: Key(alarmId.isNotEmpty ? alarmId : UniqueKey().toString()),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await _confirmDeleteDialog();
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) => _handleDelete(alarm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: AppColors.profileCardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isActive
                  ? AppColors.primaryPink.withOpacity(0.3)
                  : AppColors.cardBorder,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.bold(
                      timeStr,
                      fontSize: 26,
                      color: isActive
                          ? AppColors.textPrimaryLight
                          : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(height: 4),
                    CustomText.medium(
                      formattedDays.isNotEmpty ? formattedDays : 'Everyday',
                      fontSize: 12,
                      color: AppColors.primaryPink,
                    ),
                    if (alarm.message != null &&
                        alarm.message!.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.cardDarkBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomText.regular(
                          '💬 ${alarm.message!}',
                          fontSize: 13,
                          color: AppColors.textPrimaryLight,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: Colors.redAccent,
                  size: 20.0,
                ),
                onPressed: () async {
                  final confirm = await _confirmDeleteDialog();
                  if (confirm) {
                    _handleDelete(alarm);
                  }
                },
              ),
              Switch(
                value: isActive,
                activeColor: AppColors.primaryPink,
                inactiveTrackColor: AppColors.cardDarkBg,
                onChanged: (_) => _handleToggle(alarm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}