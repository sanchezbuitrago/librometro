// Flutter imports:
import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?) validator;
  final TextInputType textInputType;
  final int? maxLength;
  final bool obscureText;

  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,
    this.textInputType = TextInputType.text,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      maxLength: maxLength,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primary,
        labelText: labelText,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.onError),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
