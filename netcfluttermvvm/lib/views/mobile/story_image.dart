// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class StoryImage extends StatefulWidget {
  const StoryImage({super.key});

  @override
  _StoryImageState createState() => _StoryImageState();
}

class _StoryImageState extends State<StoryImage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imageFile != null
            ? GestureDetector(
                onTap: () {
                  showImageViewer(
                    context,
                    FileImage(_imageFile!),
                    swipeDismissible: true,
                    doubleTapZoomable: true,
                  );
                },
                child: Image(
                  image: FileImage(_imageFile!),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 200,
                height: 200,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 100),
              ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Pick Story Image'),
        ),
      ],
    );
  }
}