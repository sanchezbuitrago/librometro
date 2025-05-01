import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/app_bar.dart';

class DefaultScaffold extends StatelessWidget {
  final String appBarTitle;
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool isLoading;
  const DefaultScaffold({super.key, required this.appBarTitle, required this.body, this.bottomNavigationBar, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: DefaultAppBar(title: appBarTitle),
      bottomNavigationBar: bottomNavigationBar,
      body: isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,)) :body,
    );
  }
}
