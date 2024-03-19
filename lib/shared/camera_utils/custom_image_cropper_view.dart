import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'mobile_ui_helper.dart';

// import 'cropper/ui_helper.dart'
//     if (dart.library.io) 'cropper/mobile_ui_helper.dart'
//     if (dart.library.html) 'cropper/web_ui_helper.dart';

class CustomImageCropper extends StatefulWidget {
  const CustomImageCropper({Key? key, required this.file}) : super(key: key);
  final File file;

  @override
  State<CustomImageCropper> createState() => _CustomImageCropperState();
}

class _CustomImageCropperState extends State<CustomImageCropper> {

  CroppedFile? _croppedFile;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all( 16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 0.8 * screenWidth,
                    maxHeight: 0.7 * screenHeight,
                  ),
                  child: Image.file(File(widget.file.path)),
                ),
            ),
          ),
        ),
        const SizedBox(height: 24.0),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  _clear();
                },
                backgroundColor: Colors.redAccent,
                tooltip: 'Delete',
                child: const Icon(Icons.delete),
              ),
              if (_croppedFile == null)
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _cropImage();
                    },
                    backgroundColor: const Color(0xFFBC764A),
                    tooltip: 'Crop',
                    child: const Icon(Icons.crop),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  void _clear() {
    setState(() {
      _croppedFile = null;
    });
  }

  Future<void> _cropImage() async {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: widget.file.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: buildUiSettings(context),
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }

  }
}
