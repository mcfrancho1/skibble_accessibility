import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImageWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isCircleShaped;
  final String imageUrl;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  const CustomNetworkImageWidget({Key? key, this.fit = BoxFit.cover, this.borderRadius, required this.imageUrl, this.width, this.height, this.isCircleShaped = false, this.errorWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ExtendedImage.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      cache: true,
      borderRadius: borderRadius,
      shape: isCircleShaped ? BoxShape.circle : null,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
          // _controller.reset();
            return Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200),);

        ///if you don't want override completed widget
        ///please return null or state.completedWidget
        //return null;
        //return state.completedWidget;
          case LoadState.completed:
          // _controller.forward();
            return state.completedWidget;
          case LoadState.failed:
          // _controller.reset();
            return errorWidget ?? GestureDetector(
              child: Center(
                child: isCircleShaped ? const Icon(Icons.error) : const Text(
                  "Image loading failed, click to reload",
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                state.reLoadImage();
              },
            );

        }
      },
      // borderRadius: BorderRadius.all(Radius.circular(30.0)),
      //cancelToken: cancellationToken,
    );
  }
}


class CustomFileImageWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isCircleShaped;
  final File imageFile;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  const CustomFileImageWidget({Key? key, this.fit = BoxFit.cover, this.borderRadius, required this.imageFile, this.width, this.height, this.isCircleShaped = false, this.errorWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ExtendedImage.file(
      imageFile,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      shape: isCircleShaped ? BoxShape.circle : null,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
          // _controller.reset();
            return Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200),);

        ///if you don't want override completed widget
        ///please return null or state.completedWidget
        //return null;
        //return state.completedWidget;
          case LoadState.completed:
          // _controller.forward();
            return state.completedWidget;
          case LoadState.failed:
          // _controller.reset();
            return errorWidget != null ? errorWidget : GestureDetector(
              child: Center(
                child: isCircleShaped ? Icon(Icons.error) : Text(
                  "Image loading failed, click to reload",
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                state.reLoadImage();
              },
            );

        }
      },
      // borderRadius: BorderRadius.all(Radius.circular(30.0)),
      //cancelToken: cancellationToken,
    );
  }
}
