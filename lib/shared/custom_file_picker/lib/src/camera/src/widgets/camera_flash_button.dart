// ignore_for_file: always_use_package_imports


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/utils/custom_icons.dart';

import '../../../../drishya_picker.dart';
import 'camera_builder.dart';


///
class CameraFlashButton extends StatelessWidget {
  ///
  const CameraFlashButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  ///
  final CamController controller;

  @override
  Widget build(BuildContext context) {
    return CameraBuilder(
      controller: controller,
      builder: (value, child) {
        if (value.hideCameraFlashButton) {
          return const SizedBox();
        }
        final isOn = value.flashMode != FlashMode.off;
        return InkWell(
          onTap: controller.changeFlashMode,
          child: Container(
            height: 36,
            width: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black26,
            ),
            child: Icon(
              isOn ? Iconsax.flash_1 : Iconsax.flash_slash,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
