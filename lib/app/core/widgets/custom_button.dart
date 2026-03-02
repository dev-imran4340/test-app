import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/app/core/utils/app_colors.dart';
import 'package:test_app/app/core/utils/app_textstyles.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final String? iconPath;
  final Color? textColor , loadingColor    ;
  final Color? backColor;
  final VoidCallback ontap;
  final bool loading;

  const CustomButton({
    super.key,
    this.loading = false,
    required this.text,
    this.iconPath,
    required this.textColor,
    required this.ontap,
    this.loadingColor,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43.h,
      decoration: BoxDecoration(
        color: backColor ?? AppColors.accetColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12.r),
        color: backColor ?? AppColors.accetColor,
        child: InkWell(
          onTap: ontap,
          borderRadius: BorderRadius.circular(12.r),
          splashColor: backColor ?? AppColors.accetColor,
          child: Center(
            child: loading
                ? CircularProgressIndicator(
                    color:    loadingColor?? AppColors.primaryColor,
                    strokeWidth: 2,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (iconPath != null) ...[
                        SvgPicture.asset(
                          iconPath!,
                          height: 20.h,
                          width: 20.w,
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        text!,
                        textAlign: TextAlign.center,
                        style: AppTextstyles.mediumText.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
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
