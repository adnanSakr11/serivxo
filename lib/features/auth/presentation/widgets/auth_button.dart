import 'package:flutter/material.dart';
import '../../../../core/const/app_const.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;

  const AuthButton({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor ?? colors.primary,
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.3),
              blurRadius: 3,
              offset: Offset(-3, 6),
            ),
          ],
        ),

        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: textColor ?? colors.onSurface,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? colors.onSurface,
                      fontSize: fontSize ?? 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontFamily: fontFamily,
                    ),
                  ),
                  if (icon != null) ...[const SizedBox(width: 12), icon!],
                ],
              ),
      ),
    );
  }
}
