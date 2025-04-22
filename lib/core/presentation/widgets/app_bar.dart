import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/text.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const DefaultAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: SecondaryText(title), backgroundColor: Theme.of(context).colorScheme.secondary,);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
