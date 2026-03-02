import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/app/core/utils/app_colors.dart';

class AppTextstyles {
  static final TextStyle textStyle =
      TextStyle(fontFamily: "Montserrat", color: AppColors.whiteColor);

  static final TextStyle xSmallText = textStyle.copyWith(fontSize: 12.sp);
  static final TextStyle smallText = textStyle.copyWith(fontSize: 14.sp);
  static final TextStyle xMediumText = textStyle.copyWith(fontSize: 16.sp);
  static final TextStyle mediumText = textStyle.copyWith(fontSize: 18.sp);
  static final TextStyle xLargeText = textStyle.copyWith(fontSize: 22.sp);
  static final TextStyle largeText = textStyle.copyWith(fontSize: 29.sp);
}
