import 'package:flutter/material.dart';

class CustomizePersonalityScreen extends StatefulWidget {
  const CustomizePersonalityScreen({super.key});

  @override
  State<CustomizePersonalityScreen> createState() =>
      _CustomizePersonalityScreenState();
}

class _CustomizePersonalityScreenState
    extends State<CustomizePersonalityScreen> {
  // --- Slider States (0.0 to 1.0) ---
  double _shyNaughtyValue = 0.5;
  double _caringPlayfulValue = 0.5;
  double _matureChildishValue = 0.5;

  // --- Additional Traits Multi-Select State ---
  final List<String> _availableTraits = [
    'Loyal',
    'Sarcastic',
    'Talkative',
    'Teasing',
    'Flirty',
    'Jealous',
    'Witty',
    'Serious',
    'Adventurous',
  ];

  final Set<String> _selectedTraits = {'Loyal', 'Sarcastic'};

  void _toggleTrait(String trait) {
    setState(() {
      if (_selectedTraits.contains(trait)) {
        _selectedTraits.remove(trait);
      } else {
        if (_selectedTraits.length < 3) {
          _selectedTraits.add(trait);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can select up to 3 traits only!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
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
          'Customize Personality',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
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
                          Stack(
                            alignment: Alignment.center,
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
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage('assets/21.png'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryPink,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Ayushi',
                              style: TextStyle(
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
                    const Text(
                      'Personality Traits',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Slider 1: Shy vs Naughty
                    _buildSliderCard(
                      leftText: '😳 Shy',
                      rightText: 'Naughty 😏',
                      value: _shyNaughtyValue,
                      activeColor: primaryPink,
                      onChanged: (val) => setState(() => _shyNaughtyValue = val),
                    ),
                    const SizedBox(height: 14),

                    // Slider 2: Caring vs Playful
                    _buildSliderCard(
                      leftText: '💝 Caring',
                      rightText: 'Playful 😜',
                      value: _caringPlayfulValue,
                      activeColor: primaryPink,
                      onChanged: (val) =>
                          setState(() => _caringPlayfulValue = val),
                    ),
                    const SizedBox(height: 14),

                    // Slider 3: Mature vs Childish
                    _buildSliderCard(
                      leftText: '👔 Mature',
                      rightText: 'Childish 🧸',
                      value: _matureChildishValue,
                      activeColor: primaryPink,
                      onChanged: (val) =>
                          setState(() => _matureChildishValue = val),
                    ),

                    const SizedBox(height: 28),

                    // --- 3. ADDITIONAL TRAITS ---
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
                      'Select up to 3 traits for your AI model',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 10,
                      runSpacing: 12,
                      children: _availableTraits.map((trait) {
                        final isSelected = _selectedTraits.contains(trait);
                        return ChoiceChip(
                          label: Text(trait),
                          selected: isSelected,
                          onSelected: (_) => _toggleTrait(trait),
                          backgroundColor: cardBg,
                          selectedColor: primaryPink,
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
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
                  onPressed: () {
                    final selectedData = {
                      'shyNaughty': _shyNaughtyValue,
                      'caringPlayful': _caringPlayfulValue,
                      'matureChildish': _matureChildishValue,
                      'additionalTraits': _selectedTraits.toList(),
                    };
                    Navigator.pop(context, selectedData);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
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
        ),
      ),
    );
  }

  // --- Helper Widget for Slider Cards ---
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
              activeTrackColor: activeColor, // 🟢 FIX: Active progress bar Pink ho jayegi
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