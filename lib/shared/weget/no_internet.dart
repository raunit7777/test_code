import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121214),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular Wi-Fi Off Icon with Gradient
                Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xFF501B31),
                        Color(0xFF281320),
                        Color(0xFF191217),
                      ],
                      stops: [0.3, 0.7, 1.0],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 58,
                      color: Color(0xFFFF2B6D),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Title Text
                const Text(
                  'Connection Lost',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF2B6D),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Description Text
                const Text(
                  'Oops! Looks like you\'re offline.\nPlease check your internet connection and try\nagain.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 36),

                // Try Again Button (No action)
                SizedBox(
                  width: 170,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: null, // Fully disabled / No action
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: const Color(0xFFFF2B6D),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Try Again',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}