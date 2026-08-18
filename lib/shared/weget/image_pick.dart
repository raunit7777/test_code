import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:infinity_love/core/constants/app_color.dart';

import '../../core/constants/const_text.dart';

class ProfileAvatarPicker extends StatefulWidget {
  final String imageUrl; // 🔗 Server se aaya current avatar URL
  final void Function(String imageUrl)? onImageSelected; // 🔼 Uploaded Cloudinary URL parent ko bhejo

  const ProfileAvatarPicker({
    super.key,
    this.imageUrl = '',
    this.onImageSelected,
  });

  @override
  State<ProfileAvatarPicker> createState() => _ProfileAvatarPickerState();
}

class _ProfileAvatarPickerState extends State<ProfileAvatarPicker> {
  File? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  // ☁️ Cloudinary Details (Aapke project ke credentials)
  static const String _cloudName = "bky3dbdc";
  static const String _uploadPreset = "userCompanionImage";

  Future<String?> _uploadToCloudinary(File file) async {
    setState(() => _isUploading = true);

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseData);
        return jsonResponse['secure_url'];
      } else {
        debugPrint("Cloudinary Error ${response.statusCode}: $responseData");
        return null;
      }
    } catch (e) {
      debugPrint("Error uploading to Cloudinary: $e");
      return null;
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Close BottomSheet
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _selectedImage = file; // Local preview update
      });

      // ☁️ Cloudinary par upload karo
      final cloudinaryUrl = await _uploadToCloudinary(file);
      if (cloudinaryUrl != null && mounted) {
        widget.onImageSelected?.call(cloudinaryUrl); // Parent ko final URL bhejo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image. Please try again.')),
        );
      }
    }
  }

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
                    _buildOptionTile(
                      icon: HugeIcons.strokeRoundedCamera01,
                      label: 'Camera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
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

  ImageProvider _resolveImage() {
    if (_selectedImage != null) return FileImage(_selectedImage!);
    if (widget.imageUrl.isNotEmpty) return NetworkImage(widget.imageUrl);
    return const AssetImage("assets/22.png");
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = _selectedImage != null || widget.imageUrl.isNotEmpty;

    return Center(
      child: GestureDetector(
        onTap: _isUploading ? null : _showImagePickerBottomSheet,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    hasImage
                        ? Image(
                      image: _resolveImage(),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedUser,
                          size: 60,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    )
                        : const Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedUser,
                        size: 60,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    if (_isUploading)
                      Container(
                        color: Colors.black54,
                        child:  Center(
                          child: CupertinoActivityIndicator(
                            color: AppColors.primaryPink,

                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
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