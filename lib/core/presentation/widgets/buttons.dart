import 'package:flutter/material.dart';

class DefaultButtonNavigationBar extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  const DefaultButtonNavigationBar(
      {super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
          onPressed != null ? WidgetStateProperty.all(Theme.of(context).colorScheme.secondary) : WidgetStateProperty.all(Colors.grey),
          foregroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.onSecondary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
