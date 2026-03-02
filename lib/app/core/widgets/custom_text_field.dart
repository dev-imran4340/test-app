// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';

import '../utils/app_colors.dart';

// ignore: must_be_immutable
class CustomTextfeild extends StatelessWidget {
  final VoidCallback? ontap;
  final Widget? icon, prefix;
  final Widget? prefixwidget;
  final Color bordercolor;
  final bool obscureText;
  final GlobalKey? formkey;
  final String errorText;
  final Color errorcolor;
  final Color errorbordercolor;
  final Color shadowColor;
  final bool filled;
  final Color? focusbordercolor;
  final Color? enablebordercolor, titleColor, textColor;
  final Color iconcolor;
  final Color? hintcolor;
  final Color? outlinebordercolor;
  final Color? fillcolor;
  final bool autofocus;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int maxlines;
  final int errormaxlines;
  FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatter;
  final String? title;
  final bool readonly;
  BoxConstraints? boxConstraints;
  final keyBoardType;
  final String hinttext;
  final IconData? iconPath;
  final List<String>? dropdownItems;
  final String? selectedItem;
  final Function(String?)? onDropdownChanged;
  final Color? cursorColor;
  CustomTextfeild({
    super.key,
    this.readonly = false,
    this.enablebordercolor,
    this.boxConstraints,
    this.formkey,
    this.errormaxlines = 1,
    this.cursorColor,
    this.keyBoardType,
    this.maxlines = 1,
    this.title,
    this.fillcolor,
    this.bordercolor = AppColors.whiteColor,
    this.errorcolor = AppColors.transparentColor,
    this.errorbordercolor = AppColors.transparentColor,
    this.focusbordercolor,
    this.iconcolor = Colors.white,
    this.autofocus = false,
    this.filled = false,
    this.obscureText = false,
    required this.hinttext,
    this.focusNode,
    this.ontap,
    this.icon,
    this.hintcolor,
    this.shadowColor = AppColors.transparentColor,
    this.controller,
    this.errorText = "",
    this.validator,
    this.prefixwidget,
    this.iconPath,
    this.dropdownItems,
    this.selectedItem,
    this.onDropdownChanged,
    this.titleColor,
    this.prefix,
    this.outlinebordercolor,
    this.inputFormatter,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ignore: unnecessary_null_comparison
        if (title != null)
          Column(
            children: [
              Text(
                title!,
                style: AppTextstyles.smallText.copyWith(
                  color: titleColor ?? AppColors.whiteColor,
                ),
              ),
              SizedBox(height: size.height / 136),
            ],
          ),
        TextFormField(
          inputFormatters: inputFormatter,
          onTap: ontap,
          readOnly: readonly,
          key: formkey,
          keyboardType: keyBoardType,
          controller: controller,
          cursorColor: cursorColor ?? AppColors.whiteColor,
          style: AppTextstyles.smallText.copyWith(
            color: textColor ?? AppColors.whiteColor,
          ),
          obscureText: obscureText,
          focusNode: focusNode,
          validator: validator,
          maxLines: maxlines,
          autofocus: autofocus,
          decoration: InputDecoration(
            enabled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(
                width: 1,
                color:
                    outlinebordercolor ?? AppColors.whiteColor.withOpacity(0.7),
              ),
            ),
            errorStyle: AppTextstyles.smallText.copyWith(
              color: AppColors.redColor,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(width: 1.5, color: AppColors.redColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(width: 1.5, color: AppColors.redColor),
            ),
            filled: true,
            fillColor: fillcolor ?? AppColors.transparentColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 10.h,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(
                width: 1.5,
                color: focusbordercolor ?? AppColors.whiteColor,
              ),
            ),
            suffixIcon: icon,
            prefix: prefixwidget,
            hintText: hinttext,
            prefixIconConstraints: boxConstraints,
            hintStyle: AppTextstyles.smallText.copyWith(
              color: hintcolor ?? AppColors.whiteColor.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}
