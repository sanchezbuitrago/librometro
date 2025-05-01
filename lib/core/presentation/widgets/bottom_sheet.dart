import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class GetImageBottomSheetController {
  Future<void> _getFromCamera({Function(File)? onSave}) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      onSave!(File(pickedFile.path));
    }
  }

  Future<void> _getFromGallery({Function(File)? onSave}) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      onSave!(File(pickedFile.path));
    }
  }

  void showGetImageBottomSheet(BuildContext context, {Function(File)? onSave}) {
    Color iconColor = Colors.white;
    TextStyle textStyle = const TextStyle(color: Colors.white);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.black87,
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.image, color: iconColor),
                  title: Text('Galeria', style: textStyle),
                  onTap: () {
                    Navigator.pop(context);
                    _getFromGallery(onSave: onSave);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera,
                    color: iconColor,
                  ),
                  title: Text('Camara', style: textStyle),
                  onTap: () {
                    Navigator.pop(context);
                    _getFromCamera(onSave: onSave);
                  },
                ),
              ],
            ),
          );
        });
  }
}
