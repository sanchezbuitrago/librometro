import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/app_bar.dart';

class DefaultScaffold extends StatelessWidget {
  final String appBarTitle;
  final Widget body;
  const DefaultScaffold({super.key, required this.appBarTitle, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: DefaultAppBar(title: appBarTitle),
      body: body,
    );
  }
}
