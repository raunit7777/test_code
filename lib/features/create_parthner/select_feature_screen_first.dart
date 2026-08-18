import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:infinity_love/core/constants/app_color.dart';
import 'package:infinity_love/features/create_parthner/repo/create_partner_repo.dart';
import 'package:infinity_love/features/create_parthner/select_feature_screen_second.dart';
import '../../core/constants/const_text.dart';

class CreatePartnerFormScreen extends ConsumerStatefulWidget {
  const CreatePartnerFormScreen({super.key});

  @override
  ConsumerState<CreatePartnerFormScreen> createState() =>
      _CreatePartnerFormScreenState();
}

class _CreatePartnerFormScreenState
    extends ConsumerState<CreatePartnerFormScreen> {
  late TextEditingController _nameController;

  static const String _cloudName = "bky3dbdc";
  static const String _uploadPreset = "userCompanionImage";

  File? _imageFile;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  String _selectedRelationship = 'girlfriend';
  double _selectedAge = 22;

  final List<String> _relationshipOptions = [
    'girlfriend',
    'boyfriend',
  ];

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void initState() {
    super.initState();
    final existingData = ref.read(createPartnerProvider).partnerData;
    _nameController = TextEditingController(text: existingData.name);

    _selectedRelationship = existingData.relationship.isNotEmpty
        ? existingData.relationship.toLowerCase()
        : 'girlfriend';

    _selectedAge = existingData.age.toDouble() > 0
        ? existingData.age.toDouble()
        : 22.0;

    _uploadedImageUrl = existingData.imagePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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

  Future<void> _pickImage() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (photo != null) {
      final selectedFile = File(photo.path);
      setState(() {
        _imageFile = selectedFile;
        _uploadedImageUrl = null;
      });

      final url = await _uploadToCloudinary(selectedFile);
      if (url != null && mounted) {
        setState(() {
          _uploadedImageUrl = url;
        });

        ref.read(createPartnerProvider.notifier).updateBasicDetails(
          imagePath: url,
          image: url,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image. Please try again.')),
        );
      }
    }
  }

  void _onNext() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter her name')),
      );
      return;
    }

    if (_isUploading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait, image is still uploading...')),
      );
      return;
    }

    final String finalImageUrl = _uploadedImageUrl ?? '';

    ref.read(createPartnerProvider.notifier).updateBasicDetails(
      name: _nameController.text.trim(),
      relationship: _selectedRelationship.toLowerCase(),
      age: _selectedAge.round(),
      gender: 'female',
      imagePath: finalImageUrl,
      image: finalImageUrl,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PersonalityTraitsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlack,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF222224),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.textPrimaryLight,
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: CustomText.bold(
          'Create AI Partner',
          fontSize: 16,
          color: AppColors.textPrimaryLight,
        ),
        actions: [
          TextButton(
            onPressed: _onNext,
            child: CustomText.bold(
              'Next',
              fontSize: 16,
              color: AppColors.primaryPink,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText.bold(
                'Create Your AI\nPartner',
                fontSize: 28,
                color: AppColors.textPrimaryLight,
                height: 1.2,
              ),
              const SizedBox(height: 6),
              CustomText.regular(
                'Customize your perfect companion',
                fontSize: 14,
                color: AppColors.textSecondaryLight,
              ),
              const SizedBox(height: 24),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFF6565),
                            AppColors.primaryPink,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withValues(alpha: 0.4),
                            blurRadius: 35,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _imageFile != null
                            ? Image.file(
                          _imageFile!,
                          width: 170,
                          height: 170,
                          fit: BoxFit.cover,
                        )
                            : (_uploadedImageUrl != null &&
                            _uploadedImageUrl!.isNotEmpty)
                            ? Image.network(
                          _uploadedImageUrl!,
                          width: 170,
                          height: 170,
                          fit: BoxFit.cover,
                        )
                            : const Center(
                          child: Icon(
                            Icons.people_alt_rounded,
                            size: 70,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ),
                    if (_isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child:  Center(
                            child: CupertinoActivityIndicator(
                              color: AppColors.primaryPink,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: _isUploading ? null : _pickImage,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black87,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomText.bold(
                'Her Name',
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
              const SizedBox(height: 12),
              Container(
                height: 54,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.adjust_rounded,
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(
                          color: AppColors.textPrimaryLight,
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter a beautiful name',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondaryLight,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              CustomText.bold(
                'Your Relationship',
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 12,
                children: _relationshipOptions.map((relation) {
                  final isSelected =
                      _selectedRelationship.toLowerCase() == relation.toLowerCase();
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedRelationship = relation.toLowerCase());
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryPink
                            : const Color(0xFF18181A),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryPink
                              : Colors.white.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: isSelected
                          ? CustomText.bold(
                        _capitalize(relation),
                        fontSize: 14,
                        color: Colors.white,
                      )
                          : CustomText.regular(
                        _capitalize(relation),
                        fontSize: 14,
                        color: AppColors.textPrimaryLight.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
              CustomText.bold(
                'Her Age: ${_selectedAge.round()}',
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                decoration: BoxDecoration(
                  color: AppColors.cardDarkBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        activeTrackColor: AppColors.primaryPink,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                        overlayColor: AppColors.primaryPink.withValues(alpha: 0.2),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                          elevation: 4,
                        ),
                      ),
                      child: Slider(
                        value: _selectedAge,
                        min: 18,
                        max: 45,
                        onChanged: (val) {
                          setState(() => _selectedAge = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}