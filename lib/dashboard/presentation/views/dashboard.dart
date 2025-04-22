import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/scaffold.dart';
import 'package:librometro/core/presentation/widgets/text.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBarTitle: "librómetro",
      body: const PrimaryText("Librómetro"),
    );
  }
}
