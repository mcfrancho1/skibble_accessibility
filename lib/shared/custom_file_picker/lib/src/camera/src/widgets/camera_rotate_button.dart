// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/utils/custom_icons.dart';

import '../controllers/cam_controller.dart';
import 'camera_builder.dart';

///
class CameraRotateButton extends StatelessWidget {
  ///
  const CameraRotateButton({
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
        return InkWell(
          onTap: () {
            if (!value.hideCameraRotationButton) {
              controller.switchCameraDirection(value.oppositeLensDirection);
            }
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            width: 54,
            alignment: Alignment.center,
            child: value.hideCameraRotationButton
                ? const SizedBox()
                : const Icon( Icons.flip_camera_ios_rounded,

                    // CustomIcons.cameraRotate,
                    color: Colors.white,
                  ),
          ),
        );
      },
    );
  }
}
