import 'package:flutter/material.dart';

// Language Model Data Structure
class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String initial;

  LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.initial,
  });
}

class SelectLanguageScreen extends StatefulWidget {
  final String initialLanguage;

  const SelectLanguageScreen({
    super.key,
    this.initialLanguage = 'Hindi',
  });

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  late String _selectedLanguage;

  final List<LanguageOption> _languages = [
    LanguageOption(code: 'en', name: 'English', nativeName: 'English', initial: 'E'),
    LanguageOption(code: 'hi', name: 'Hindi', nativeName: 'हिंदी', initial: 'ह'),
    LanguageOption(code: 'mr', name: 'Marathi', nativeName: 'मराठी', initial: 'म'),
    LanguageOption(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', initial: 'த'),
    LanguageOption(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', initial: 'తె'),
    LanguageOption(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', initial: 'ગ'),
    LanguageOption(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', initial: 'বা'),
    LanguageOption(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', initial: 'ಕ'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage;
  }

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFFF4D79);
    const darkBg = Color(0xFF121212);
    const cardBg = Color(0xFF1C1C1E);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Customize Personality', // Title as shown in design image
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                'Partner Language',
                style: TextStyle(
                  color: Color(0xFFFFA5B9), // Soft pink section heading
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Language Options List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: _languages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final lang = _languages[index];
                  final isSelected = lang.name == _selectedLanguage;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguage = lang.name;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? primaryPink
                              : Colors.white.withOpacity(0.08),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Initial Circle Avatar
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? primaryPink.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.06),
                            ),
                            child: Center(
                              child: Text(
                                lang.initial,
                                style: TextStyle(
                                  color: isSelected ? primaryPink : Colors.white70,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Titles
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  lang.nativeName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? primaryPink
                                        : Colors.white38,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Check/Radio Icon
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? primaryPink : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? primaryPink
                                    : Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Apply Language Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Selected Language Name/Code return kar sakte hain
                    Navigator.pop(context, _selectedLanguage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply Language',
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
        ),
      ),
    );
  }
}