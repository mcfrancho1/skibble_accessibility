import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../utils/constants.dart';

class CustomCropper {

  static Future<CroppedFile?> cropImage(String filePath, {Function(CroppedFile? file)? onDone}) async {
    try {
      CroppedFile? file = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              // toolbarColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
              // toolbarWidgetColor: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,

              toolbarColor: kPrimaryColor,
              toolbarWidgetColor: kLightSecondaryColor,
              activeControlsWidgetColor: kPrimaryColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
            // minimumAspectRatio:
          ),
        ],
      );

      // if(file != null) {
        if(onDone != null) {
          onDone(file);
        }
      // }

      return file;
    }
    catch(e) {
      return null;
    }
  }
}
