import 'package:flutter/material.dart';
import 'package:test_app/app/core/utils/app_colors.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child, floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? scaffloadBgColor;

  const CustomScaffold(
      {super.key,
      required this.child,
      this.scaffloadBgColor,
      this.floatingActionButton,
      this.floatingActionButtonLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButton: floatingActionButton,
        backgroundColor: scaffloadBgColor,
        body: scaffloadBgColor == null
            ? Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  AppColors.gardainColor2,
                  AppColors.gardainColor1
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: child,
              )
            : child);
  }
}
