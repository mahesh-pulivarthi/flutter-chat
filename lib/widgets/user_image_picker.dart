import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imageFn;

  const UserImagePicker({Key? key, required this.imageFn}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  late File _pickedImage;

  @override
  initState() {
    super.initState();
    _pickedImage = File('');
  }

  Future<void> takePicture() async {
    final picker = ImagePicker();
    XFile? imageFile = XFile('');
    imageFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 20);

    if (imageFile == null) return;

    setState(() {
      _pickedImage = File(imageFile!.path);
    });
    widget.imageFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage.path != '' ? FileImage(_pickedImage) : null,
        ),
        TextButton.icon(
            onPressed: () {
              takePicture();
            },
            icon: const Icon(Icons.image),
            label: const Text('Click here to add image'))
      ],
    );
  }
}
