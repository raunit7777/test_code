import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import 'const_text.dart' show CustomText;


class AppBtn extends StatefulWidget {
  final String? title;
  final Color? titleColor;
  final Color? color;
  final Function()? onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool loading;
  final Gradient? gradient;
  final bool hideBorder;
  final Widget? child;
  final FontWeight? fontWeight;
  final BoxBorder? border;
  final double borderRadius;

  const AppBtn({
    super.key,
    this.title,
    this.titleColor,
    this.color,
    this.onTap,
    this.width,
    this.height,
    this.fontSize,
    this.loading = false,
    this.gradient,
    this.hideBorder = false,
    this.child,
    this.fontWeight,
    this.border,
    this.borderRadius = 8,
  });

  @override
  State<AppBtn> createState() => _AppBtnState();
}

class _AppBtnState extends State<AppBtn> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.loading ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {

          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.loading
                ?CupertinoActivityIndicator()
                : Container(
              height: widget.height ?? 56,
              width: widget.width ?? screenWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.color ?? AppColors.primaryPink,
                border: widget.border,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: widget.gradient,
              ),
              child: SizedBox(
                width: widget.width ?? screenWidth * 0.75,
                child: Center(
                  child: widget.child ??
                      CustomText.semiBold(
                        widget.title ?? "",
                        color: widget.titleColor ?? AppColors.whiteSheetBg,
                        maxLines: 1,
                        fontSize: widget.fontSize ?? 16,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}