import 'package:flutter/material.dart';

import '../../../common/color_pallete.dart';
import '../../../common/utils.dart';

class MyTextField extends StatelessWidget {
  final Color? textColor;
  final Color? hintColor;
  final double? fontSize;
  final String? initialValue;
  final String? hintText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final bool? showLine;
  final bool? enabled;
  final bool? readOnly;
  final Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final void Function()? onTap;
  final TextEditingController? controller;

  const MyTextField(
      {super.key,
      this.textColor,
      this.hintColor,
      this.initialValue,
      this.hintText,
      this.obscureText,
      this.showLine,
      this.fontSize,
      this.keyboardType,
      this.onChanged,
      this.validator,
      this.enabled,
      this.onTap, this.readOnly, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly ?? false,
      validator: validator,
      key: Key(initialValue ?? ""),
      onChanged: onChanged,
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        border: showLine ?? false ? null : InputBorder.none,
        hintText: hintText ?? "",
        hintStyle: SafeGoogleFont('Roboto', fontSize: fontSize ?? 12, fontWeight: FontWeight.w400, color: hintColor ?? ColorPallete.grey),
        errorStyle: SafeGoogleFont('Roboto', fontSize: fontSize ?? 12, fontWeight: FontWeight.w400, color: ColorPallete.red),
      ),
      style: SafeGoogleFont('Roboto', fontSize: fontSize ?? 12, fontWeight: FontWeight.w500, color: textColor ?? ColorPallete.secondary),
      onTap: onTap,
    );
  }
}
