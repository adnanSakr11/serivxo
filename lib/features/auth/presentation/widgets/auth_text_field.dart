import 'package:flutter/material.dart';

import '../../../../core/const/app_const.dart';

class AppTextFormField extends StatefulWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final bool isPassword;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final TextEditingController? controller;
  final double? width;
  final TextInputType? keyboardType;

  const AppTextFormField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.onChanged,
    this.validator,
    this.fillColor,
    this.controller,
    this.width,
    this.keyboardType,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.05),
        boxShadow: [
          BoxShadow(
            color: colors.background.withOpacity(0.5),
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        style: TextStyle(color: colors.onSurface),
        obscureText: _obscureText,
        cursorColor: colors.onSurface,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: colors.onSurface,
            fontFamily: fontFamily,
            letterSpacing: 1.2,
          ),
          prefixIcon: widget.prefixIcon,
          prefixIconColor: colors.onSurface,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: colors.onSurface,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: colors.onSurface.withOpacity(0.4),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: colors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
