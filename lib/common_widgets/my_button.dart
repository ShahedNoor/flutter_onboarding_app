import 'package:flutter/material.dart';
import 'package:flutter_onboarding_app/colors/colors.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onTap;
  final Color buttonBackgroundColor;
  const MyButton({super.key, required this.onTap, required this.buttonText, required this.buttonBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: buttonBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(buttonText, style: TextStyle(color: AppColors.onPrimary)),
        ),
      ),
    );
  }
}
