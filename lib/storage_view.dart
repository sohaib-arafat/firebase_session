
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  ImagePickerWidgetState createState() => ImagePickerWidgetState();
}

class ImagePickerWidgetState extends State<ImagePickerWidget> {
  XFile? image;
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                image = await picker.pickImage(source: ImageSource.gallery);

                final storageRef = FirebaseStorage.instance.ref();
                final imageRef = storageRef.child('images/${image!.name}');
                await imageRef.putFile(File(image!.path));


                imageUrl = await imageRef.getDownloadURL();
                if (kDebugMode) {
                  print(imageUrl);
                }

                setState(() {});
              },
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            if (imageUrl != null)
              Image.network(imageUrl!),
          ],
        ),
      ),
    );
  }
}

