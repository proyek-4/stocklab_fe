import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void myAlert(BuildContext context, Function(ImageSource) onImagePicked) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Pilih media'),
        content: Container(
          height: MediaQuery.of(context).size.height / 6,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onImagePicked(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(Icons.image),
                    Text('Dari Galeri'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onImagePicked(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(Icons.camera),
                    Text('Dari Kamera'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

