
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/shared/custom_file_picker/lib/src/camera/src/widgets/ui_handler.dart';
import 'package:skibble/utils/custom_icons.dart';

import '../../../../drishya_picker.dart';
import 'camera_builder.dart';

///
class CameraCloseButton extends StatelessWidget {
  ///
  const CameraCloseButton({
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
        if (value.hideCameraCloseButton) {
          return const SizedBox();
        }
        return child!;
      },
      child: InkWell(
        onTap: () {
          // UIHandler.of(context).pop;
          Navigator.pop(context);
        },
        child: Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black26,
          ),
          child: const Icon(
            Iconsax.arrow_left,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}
