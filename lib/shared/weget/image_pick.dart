import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart'; // Apne path ke according adjust kar lena

class ProfileAvatarPicker extends StatefulWidget {
  const ProfileAvatarPicker({super.key});

  @override
  State<ProfileAvatarPicker> createState() => _ProfileAvatarPickerState();
}

class _ProfileAvatarPickerState extends State<ProfileAvatarPicker> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // --- Image Pick Handler ---
  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Close BottomSheet
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80, // Compression for smooth memory performance
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // --- Bottom Sheet Options (Camera / Gallery) ---
  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDarkBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.bold(
                  'Choose Profile Picture',
                  fontSize: 18,
                  color: AppColors.textPrimaryLight,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Camera Option
                    _buildOptionTile(
                      icon: HugeIcons.strokeRoundedCamera01,
                      label: 'Camera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    // Gallery Option
                    _buildOptionTile(
                      icon: HugeIcons.strokeRoundedImage01,
                      label: 'Gallery',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.bgBlack,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Center(
              child: HugeIcon(
                icon: icon,
                color: AppColors.primaryPink,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 8),
          CustomText.medium(
            label,
            fontSize: 14,
            color: AppColors.textSecondaryLight,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _showImagePickerBottomSheet,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Outer Pink Circle Border
            Container(
              width: 130,
              height: 130,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryPink,
                  width: 2.5,
                ),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: AppColors.cardDarkBg,
                  shape: BoxShape.circle,
                ),
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
                    : const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    size: 60,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ),

            // Camera Icon Badge
            Positioned(
              right: 4,
              bottom: 4,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.primaryPink,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCamera01,
                    color: AppColors.textPrimaryLight,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}