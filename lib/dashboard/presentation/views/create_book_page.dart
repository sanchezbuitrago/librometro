import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/scaffold.dart';

class CreateBookPage extends StatefulWidget {
  const CreateBookPage({super.key});

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBarTitle: "Agregar Libro",
      body: Text("Create book"),
    );
  }
}
