import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_love/core/constants/app_color.dart';

import 'font_family.dart'; // Ensure correct path for FontConst

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool? filled;
  final Color? fillColor;
  final void Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? hintSize;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? contentPadding;
  final double? cursorHeight;
  final Color? cursorColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BorderRadius? fieldRadius;
  final bool? enabled;
  final void Function()? onTap;
  final bool autofocus;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? margin;
  final String? errorText;
  final BorderSide? borderSide;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    this.style,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.minLines,
    this.maxLength,
    this.obscureText = false,
    this.keyboardType,
    this.hintText,
    this.filled,
    this.fillColor,
    this.onChanged,
    this.height,
    this.width,
    this.hintSize,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.contentPadding,
    this.cursorHeight,
    this.cursorColor,
    this.prefixIcon,
    this.suffixIcon,
    this.fieldRadius,
    this.enabled,
    this.maxLines,
    this.onTap,
    this.autofocus = false,
    this.onSaved,
    this.validator,
    this.margin,
    this.errorText,
    this.borderSide,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const defaultRadius = BorderRadius.all(Radius.circular(14));

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: margin,
        height: height ?? (screenHeight * 0.07),
        width: width ?? (screenWidth * 0.9),
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines ?? 1,
          minLines: minLines,
          maxLength: maxLength,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          autofocus: autofocus,
          textAlign: textAlign,
          autovalidateMode: autovalidateMode,
          cursorColor: cursorColor ?? AppColors.primaryPink,
          cursorHeight: cursorHeight,
          textInputAction: textInputAction ?? TextInputAction.done,
          style: style ??
              const TextStyle(
                fontFamily: FontConst.family,
                fontSize: 16,
                color: AppColors.textPrimaryLight,
              ),
          decoration: InputDecoration(
            errorText: errorText,
            counter: const Offstage(),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: filled ?? true,
            fillColor: fillColor ?? AppColors.cardDarkBg,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textSecondaryDark,
              fontFamily: FontConst.family,
              fontSize: hintSize ?? 15,
            ),
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderSide: borderSide ??
                  const BorderSide(
                    width: 1,
                    color: AppColors.cardBorder,
                  ),
              borderRadius: fieldRadius ?? defaultRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: borderSide ??
                  const BorderSide(
                    width: 1.5,
                    color: AppColors.primaryPink,
                  ),
              borderRadius: fieldRadius ?? defaultRadius,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: borderSide ??
                  const BorderSide(
                    width: 1,
                    color: AppColors.cardBorder,
                  ),
              borderRadius: fieldRadius ?? defaultRadius,
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: borderSide ??
                  const BorderSide(
                    width: 1,
                    color: AppColors.cardBorder,
                  ),
              borderRadius: fieldRadius ?? defaultRadius,
            ),
          ),
        ),
      ),
    );
  }
}