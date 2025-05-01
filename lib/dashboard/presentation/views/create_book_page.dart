import 'dart:io';
import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/scaffold.dart';
import 'package:librometro/core/presentation/widgets/bottom_sheet.dart';

import 'package:librometro/core/presentation/widgets/form_fields.dart';
import 'package:librometro/core/services/routes.dart';
import 'package:librometro/dashboard/domain/models/events.dart';
import 'package:librometro/dashboard/domain/veiw_model/create_book.dart';

import 'package:librometro/core/presentation/widgets/buttons.dart';

class CreateBookPage extends StatefulWidget {
  const CreateBookPage({super.key});

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  File? imageFile;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _totalPagesController = TextEditingController();
  final CreateBookViewModel createBookViewModel = CreateBookViewModel();
  bool isLoading = false;

  void onSave(File? file) {
    setState(() {
      imageFile = file;
    });
  }

  void submit() async {
    print(imageFile);
    print(imageFile?.path);
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading=true;
      });
      processLibraryEvents(await createBookViewModel.createBook(
        _nameController.text,
        int.parse(_totalPagesController.text),
        imageFile?.path
      ));
    }
  }

  void processLibraryEvents(LibraryEvent event){
    if(event is BookCreated){
      AppRoutes.goBack(context);
    }
    setState(() {
      isLoading =false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBarTitle: "Crear Libro",
      bottomNavigationBar: DefaultButtonNavigationBar(
        onPressed: submit,
        child: Text("Agregar Libro"),
      ),
      isLoading: isLoading,
      body: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: RectImageSelector(onSave: onSave, height: 200, width: 160),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DefaultTextFormField(
                    controller: _nameController,
                    labelText: "Nombre del Libro",
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El nombre del libro es requerido";
                      }
                      return null;
                    },
                  ),
                  DefaultTextFormField(
                    controller: _totalPagesController,
                    labelText: "Número de paginas",
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "El número de paginas es requerido";
                      }

                      int? numberPages = int.tryParse(value);
                      if(numberPages == null){
                        return "El número de paginas debe ser un número entero";
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RectImageSelector extends StatefulWidget {
  final double width;
  final double height;
  final Function(File?) onSave;

  const RectImageSelector({
    super.key,
    required this.width,
    required this.height,
    required this.onSave,
  });

  @override
  State<RectImageSelector> createState() => _RectImageSelectorState();
}

class _RectImageSelectorState extends State<RectImageSelector> {
  File? image;

  void _getImage() {
    GetImageBottomSheetController().showGetImageBottomSheet(
      context,
      onSave: (file) {
        setState(() {
          image = file;
          widget.onSave(file);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = 10;
    return InkWell(
      onTap: _getImage,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey,
            child:
                image == null
                    ? Center(
                      child: Icon(Icons.photo_album, color: Colors.black),
                    )
                    : Image.file(image!, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
