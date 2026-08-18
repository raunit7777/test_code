import 'package:flutter/material.dart';

class AnimatedFlameBadge extends StatefulWidget {
  final bool canClaim;
  final bool streakBreak; // 🟢 New parameter added

  const AnimatedFlameBadge({
    super.key,
    required this.canClaim,
    this.streakBreak = false, // Default false
  });

  @override
  State<AnimatedFlameBadge> createState() => _AnimatedFlameBadgeState();
}

class _AnimatedFlameBadgeState extends State<AnimatedFlameBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Controller for continuous pulse animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true); // Continuous breathing effect

    // Flame/Heart Scaling (1.0x to 1.15x)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Dynamic Glow Radius
    _glowAnimation = Tween<double>(begin: 6.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 Dynamic values based on streakBreak and canClaim
    final bool isBroken = widget.streakBreak;
    final String emoji = isBroken ? '💔' : '🔥';

    final Color borderColor = isBroken
        ? const Color(0xFF882222)
        : (widget.canClaim ? const Color(0xFFFF6A00) : const Color(0xFF552D1B));

    final Color bgColor = isBroken
        ? const Color(0xFF2A1515)
        : const Color(0xFF331D12);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(
              color: borderColor,
              width: 3.5,
            ),
            boxShadow: [
              if (widget.canClaim && !isBroken)
                BoxShadow(
                  color: const Color(0xFFFF6A00).withOpacity(0.5),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: 2,
                )
              else if (isBroken)
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Center(
            child: Transform.scale(
              scale: isBroken ? 1.0 : _scaleAnimation.value, // Stop pulse animation if broken
              child: Text(
                emoji,
                style: const TextStyle(
                  fontSize: 70,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}