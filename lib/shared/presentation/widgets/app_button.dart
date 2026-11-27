import 'package:flutter/material.dart';

class AUthButton extends StatelessWidget {
  void Function()? onTap;
  double? width;
  double? height;
  Color? backgroundColor;
  Widget? child;
  AUthButton({
    super.key,
    this.onTap,
    this.width,
    this.height,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 50,
        decoration: BoxDecoration(
          color: backgroundColor ?? colors.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: child,
      ),
    );
  }
}
