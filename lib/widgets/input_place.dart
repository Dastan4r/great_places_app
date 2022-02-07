import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

import 'package:image_picker/image_picker.dart';

class InputPlace extends StatefulWidget {
  Function inputPickerHandler;

  InputPlace(this.inputPickerHandler);

  @override
  _InputPlaceState createState() => _InputPlaceState();
}

class _InputPlaceState extends State<InputPlace> {
  File? _storedImage;
  bool loadingImage = false;

  Future<void> _takePicture() async {
    setState(() {
      loadingImage = true;
    });

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _storedImage = File(pickedImage!.path);
      loadingImage = false;
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedImage!.path);

    await pickedImage.saveTo('${appDir.path}/$fileName');

    widget.inputPickerHandler(File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: loadingImage
              ? const CircularProgressIndicator()
              : _storedImage != null
                  ? Image.file(
                      File(_storedImage!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Text('No image taken'),
          alignment: Alignment.center,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _takePicture,
            icon: const Icon(Icons.camera),
            label: const Text(
              'Take picture',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
