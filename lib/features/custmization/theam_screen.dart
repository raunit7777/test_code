// import 'package:flutter/material.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:infinity_love/core/constants/app_color.dart';
// import '../../core/constants/const_text.dart';
//
// // Theme Model
// class ThemeColorModel {
//   final String name;
//   final Color color;
//
//   const ThemeColorModel({required this.name, required this.color});
// }
//
// class CustomizeThemeScreen extends StatefulWidget {
//   final Color initialColor;
//
//   const CustomizeThemeScreen({
//     super.key,
//     this.initialColor = AppColors.primaryPink,
//   });
//
//   @override
//   State<CustomizeThemeScreen> createState() => _CustomizeThemeScreenState();
// }
//
// class _CustomizeThemeScreenState extends State<CustomizeThemeScreen> {
//   late Color _selectedColor;
//
//   // Available Theme Colors matching your screenshot
//   final List<ThemeColorModel> _themeColors = const [
//     ThemeColorModel(name: 'Pink', color: Color(0xFFFF2B6D)),
//     ThemeColorModel(name: 'Teal', color: Color(0xFF26A69A)),
//     ThemeColorModel(name: 'Coral', color: Color(0xFFFF8A65)),
//     ThemeColorModel(name: 'Indigo', color: Color(0xFF5C6BC0)),
//     ThemeColorModel(name: 'Blue', color: Color(0xFF29B6F6)),
//     ThemeColorModel(name: 'Cyan', color: Color(0xFF00BCD4)),
//     ThemeColorModel(name: 'Green', color: Color(0xFF66BB6A)),
//     ThemeColorModel(name: 'Amber', color: Color(0xFFFFCA28)),
//     ThemeColorModel(name: 'Orange', color: Color(0xFFFF7043)),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedColor = widget.initialColor;
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
//           icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: CustomText.bold(
//           'Customize Theam',
//           fontSize: 20,
//           color: AppColors.textPrimaryLight,
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // --- MOCKUP PREVIEW CARD ---
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1B1B1E),
//                         borderRadius: BorderRadius.circular(24),
//                         border: Border.all(
//                           color: _selectedColor.withOpacity(0.3),
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           // Header inside Mockup
//                           Row(
//                             children: [
//                               Stack(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 18,
//                                     backgroundColor: _selectedColor,
//                                     backgroundImage:
//                                     const AssetImage("assets/21.png"),
//                                   ),
//                                   Positioned(
//                                     bottom: 0,
//                                     right: 0,
//                                     child: Container(
//                                       width: 10,
//                                       height: 10,
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFF00FF66),
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                             color: Colors.black, width: 1.5),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     CustomText.bold(
//                                       'Ayushi',
//                                       fontSize: 15,
//                                       color: AppColors.textPrimaryLight,
//                                     ),
//                                     CustomText.regular(
//                                       'Online',
//                                       fontSize: 11,
//                                       color: const Color(0xFF00FF66),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const HugeIcon(
//                                 icon: HugeIcons.strokeRoundedCall,
//                                 color: Colors.white70,
//                                 size: 18,
//                               ),
//                               const SizedBox(width: 14),
//                               const HugeIcon(
//                                 icon: HugeIcons.strokeRoundedSettings01,
//                                 color: Colors.white70,
//                                 size: 18,
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           // Incoming Message 1
//                           _buildMockBubble(
//                             text: "Hello! How can I help you today?",
//                             time: "10:30 AM",
//                             isMe: false,
//                           ),
//
//                           const SizedBox(height: 12),
//
//                           // Outgoing Message 1 (Live Color Preview)
//                           _buildMockBubble(
//                             text:
//                             "Hi there! I have a question about my account.",
//                             time: "10:31 AM",
//                             isMe: true,
//                           ),
//
//                           const SizedBox(height: 12),
//
//                           // Incoming Message 2
//                           _buildMockBubble(
//                             text:
//                             "I'll be happy to help! What would you like to know?",
//                             time: "10:31 AM",
//                             isMe: false,
//                           ),
//
//                           const SizedBox(height: 12),
//
//                           // Outgoing Message 2
//                           _buildMockBubble(
//                             text: "Can you check my current",
//                             time: "",
//                             isMe: true,
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 28),
//
//                     // --- COLOR SELECTION HEADING ---
//                     CustomText.bold(
//                       'SELECT A COLOR',
//                       fontSize: 13,
//                       color: AppColors.textSecondaryLight,
//                     ),
//
//                     const SizedBox(height: 16),
//
//                     // --- COLOR PALETTE GRID ---
//                     Wrap(
//                       spacing: 16,
//                       runSpacing: 18,
//                       children: _themeColors.map((theme) {
//                         final isSelected =
//                             _selectedColor.value == theme.color.value;
//
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _selectedColor = theme.color;
//                             });
//                           },
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 width: 54,
//                                 height: 54,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: theme.color,
//                                   border: isSelected
//                                       ? Border.all(
//                                     color: Colors.white,
//                                     width: 3,
//                                   )
//                                       : null,
//                                   boxShadow: isSelected
//                                       ? [
//                                     BoxShadow(
//                                       color: theme.color.withOpacity(0.5),
//                                       blurRadius: 10,
//                                       spreadRadius: 2,
//                                     )
//                                   ]
//                                       : [],
//                                 ),
//                                 child: isSelected
//                                     ? const Center(
//                                   child: Icon(
//                                     Icons.check,
//                                     color: Colors.white,
//                                     size: 24,
//                                   ),
//                                 )
//                                     : null,
//                               ),
//                               const SizedBox(height: 6),
//                               CustomText.regular(
//                                 theme.name,
//                                 fontSize: 12,
//                                 color: isSelected
//                                     ? AppColors.textPrimaryLight
//                                     : AppColors.textSecondaryLight,
//                               ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // --- APPLY THEME BUTTON ---
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Send selected theme color back to Chat Screen
//                     Navigator.pop(context, _selectedColor);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _selectedColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(26),
//                     ),
//                     elevation: 4,
//                     shadowColor: _selectedColor.withOpacity(0.5),
//                   ),
//                   child: CustomText.bold(
//                     'Apply Theme',
//                     fontSize: 16,
//                     color: Colors.white,
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
//   // Mock Bubble Helper
//   Widget _buildMockBubble({
//     required String text,
//     required String time,
//     required bool isMe,
//   }) {
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment:
//         isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: isMe ? _selectedColor : const Color(0xFF2C2C2E),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: CustomText.regular(
//               text,
//               fontSize: 13,
//               color: AppColors.textPrimaryLight,
//             ),
//           ),
//           if (time.isNotEmpty) ...[
//             const SizedBox(height: 3),
//             CustomText.regular(
//               time,
//               fontSize: 10,
//               color: AppColors.textSecondaryLight,
//             ),
//           ]
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import '../../core/constants/const_text.dart';
import '../../core/storage/loacal_storage.dart';


class ThemeColorModel {
  final String name;
  final Color color;

  const ThemeColorModel({required this.name, required this.color});
}

class CustomizeThemeScreen extends StatefulWidget {
  final Color initialColor;

  const CustomizeThemeScreen({
    super.key,
    this.initialColor = AppColors.primaryPink,
  });

  @override
  State<CustomizeThemeScreen> createState() => _CustomizeThemeScreenState();
}

class _CustomizeThemeScreenState extends State<CustomizeThemeScreen> {
  late Color _selectedColor;

  final List<ThemeColorModel> _themeColors = const [
    ThemeColorModel(name: 'Pink', color: Color(0xFFFF2B6D)),
    ThemeColorModel(name: 'Teal', color: Color(0xFF26A69A)),
    ThemeColorModel(name: 'Coral', color: Color(0xFFFF8A65)),
    ThemeColorModel(name: 'Indigo', color: Color(0xFF5C6BC0)),
    ThemeColorModel(name: 'Blue', color: Color(0xFF29B6F6)),
    ThemeColorModel(name: 'Cyan', color: Color(0xFF00BCD4)),
    ThemeColorModel(name: 'Green', color: Color(0xFF66BB6A)),
    ThemeColorModel(name: 'Amber', color: Color(0xFFFFCA28)),
    ThemeColorModel(name: 'Orange', color: Color(0xFFFF7043)),
  ];

  @override
  void initState() {
    super.initState();
    // 🟢 Saved Local Storage color agar exist kare to prefer karein, varna widget.initialColor fallback
    _selectedColor = LocalStorage.getThemeColor() ?? widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText.bold(
          'Customize Theme',
          fontSize: 20,
          color: AppColors.textPrimaryLight,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- MOCKUP PREVIEW CARD ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B1B1E),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _selectedColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: _selectedColor,
                                    backgroundImage:
                                    const AssetImage("assets/21.png"),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00FF66),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black, width: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText.bold(
                                      'Ayushi',
                                      fontSize: 15,
                                      color: AppColors.textPrimaryLight,
                                    ),
                                    CustomText.regular(
                                      'Online',
                                      fontSize: 11,
                                      color: const Color(0xFF00FF66),
                                    ),
                                  ],
                                ),
                              ),
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedCall,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 14),
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedSettings01,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          _buildMockBubble(
                            text: "Hello! How can I help you today?",
                            time: "10:30 AM",
                            isMe: false,
                          ),

                          const SizedBox(height: 12),

                          _buildMockBubble(
                            text:
                            "Hi there! I have a question about my account.",
                            time: "10:31 AM",
                            isMe: true,
                          ),

                          const SizedBox(height: 12),

                          _buildMockBubble(
                            text:
                            "I'll be happy to help! What would you like to know?",
                            time: "10:31 AM",
                            isMe: false,
                          ),

                          const SizedBox(height: 12),

                          _buildMockBubble(
                            text: "Can you check my current",
                            time: "",
                            isMe: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    CustomText.bold(
                      'SELECT A COLOR',
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                    ),

                    const SizedBox(height: 16),

                    // --- COLOR PALETTE GRID ---
                    Wrap(
                      spacing: 16,
                      runSpacing: 18,
                      children: _themeColors.map((theme) {
                        final isSelected =
                            _selectedColor.value == theme.color.value;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = theme.color;
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.color,
                                  border: isSelected
                                      ? Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  )
                                      : null,
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: theme.color.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    )
                                  ]
                                      : [],
                                ),
                                child: isSelected
                                    ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                )
                                    : null,
                              ),
                              const SizedBox(height: 6),
                              CustomText.regular(
                                theme.name,
                                fontSize: 12,
                                color: isSelected
                                    ? AppColors.textPrimaryLight
                                    : AppColors.textSecondaryLight,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // --- APPLY THEME BUTTON ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    // 🟢 Save selected color to Hive local storage permanent persistence
                    await LocalStorage.saveThemeColor(_selectedColor.value);

                    if (context.mounted) {
                      Navigator.pop(context, _selectedColor);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 4,
                    shadowColor: _selectedColor.withOpacity(0.5),
                  ),
                  child: CustomText.bold(
                    'Apply Theme',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockBubble({
    required String text,
    required String time,
    required bool isMe,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? _selectedColor : const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: CustomText.regular(
              text,
              fontSize: 13,
              color: AppColors.textPrimaryLight,
            ),
          ),
          if (time.isNotEmpty) ...[
            const SizedBox(height: 3),
            CustomText.regular(
              time,
              fontSize: 10,
              color: AppColors.textSecondaryLight,
            ),
          ]
        ],
      ),
    );
  }
}