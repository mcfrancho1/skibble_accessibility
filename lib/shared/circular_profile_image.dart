import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../models/skibble_user.dart';
import '../utils/constants.dart';

class CircularProfileImage extends StatelessWidget {
  const CircularProfileImage({Key? key, required this.user, this.imageFile}) : super(key: key);
  final SkibbleUser user;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return
      imageFile != null ?
      Container(
            width: 20,
            height: 20,
            child: ExtendedImage.file(
              imageFile!,
              width: 18,
              height: 18,
              fit: BoxFit.cover,
              border: Border.all(
                  color: user.userCustomColor!, width: 0.5),
              shape: BoxShape.circle,
              loadStateChanged: (ExtendedImageState state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                  // _controller.reset();
                    return Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: user.userCustomColor,
                          border: Border.all(color: kPrimaryColor)
                      ),
                    );

                ///if you don't want override completed widget
                ///please return null or state.completedWidget
                //return null;
                //return state.completedWidget;
                  case LoadState.completed:
                  // _controller.forward();
                    return state.completedWidget;
                //   ExtendedRawImage(
                //   image: state.extendedImageInfo?.image,
                // );
                // break;
                  case LoadState.failed:
                  // _controller.reset();
                    return GestureDetector(
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset(
                            "assets/failed.jpg",
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Text(
                              "load image failed, click to reload",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        state.reLoadImage();
                      },
                    );
                }
              },
              // borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //cancelToken: cancellationToken,
            )
          ///
          // CachedNetworkImage(
          //   imageUrl: user.profileImageUrl!,
          //   memCacheWidth: 76,
          //   memCacheHeight: 76,
          //   // width: 25,
          //   // height: 25,
          //   imageBuilder: (context, imageProvider) {
          //     return Container(
          //       width: 25,
          //       height: 25,
          //       decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           image: DecorationImage(
          //               image: imageProvider,
          //             fit: BoxFit.cover
          //           )
          //       ),
          //     );
          //   },
          // ),

          ///
          // Container(
          //   width: 25,
          //   height: 25,
          //   decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //
          //       image: DecorationImage(
          //           image: CachedNetworkImageProvider(user.profileImageUrl!),
          //         fit: BoxFit.cover
          //       )
          //   ),
          // ),
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   color: user.userCustomColor != null ? user.userCustomColor : kPrimaryColor,
          //   border: Border.all(color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kPrimaryColor)
          // ),
        )
          :
      user.profileImageUrl != null ?
      Container(
          width: 20,
          height: 20,
          child: ExtendedImage.network(
            user.profileImageUrl!,
            width: 18,
            height: 18,
            fit: BoxFit.cover,
            cache: true,

            border: Border.all(
                color: user.userCustomColor!, width: 0.5),
            shape: BoxShape.circle,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                // _controller.reset();
                  return Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: user.userCustomColor,
                        border: Border.all(color: kPrimaryColor)
                    ),
                  );

              ///if you don't want override completed widget
              ///please return null or state.completedWidget
              //return null;
              //return state.completedWidget;
                case LoadState.completed:
                // _controller.forward();
                  return state.completedWidget;
              //   ExtendedRawImage(
              //   image: state.extendedImageInfo?.image,
              // );
              // break;
                case LoadState.failed:
                // _controller.reset();
                  return GestureDetector(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(
                          "assets/failed.jpg",
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Text(
                            "load image failed, click to reload",
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      state.reLoadImage();
                    },
                  );
              }
            },
            // borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //cancelToken: cancellationToken,
          )
        ///
        // CachedNetworkImage(
        //   imageUrl: user.profileImageUrl!,
        //   memCacheWidth: 76,
        //   memCacheHeight: 76,
        //   // width: 25,
        //   // height: 25,
        //   imageBuilder: (context, imageProvider) {
        //     return Container(
        //       width: 25,
        //       height: 25,
        //       decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           image: DecorationImage(
        //               image: imageProvider,
        //             fit: BoxFit.cover
        //           )
        //       ),
        //     );
        //   },
        // ),

        ///
        // Container(
        //   width: 25,
        //   height: 25,
        //   decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //
        //       image: DecorationImage(
        //           image: CachedNetworkImageProvider(user.profileImageUrl!),
        //         fit: BoxFit.cover
        //       )
        //   ),
        // ),
        // decoration: BoxDecoration(
        //   shape: BoxShape.circle,
        //   color: user.userCustomColor != null ? user.userCustomColor : kPrimaryColor,
        //   border: Border.all(color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kPrimaryColor)
        // ),
      )
          :
      Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: user.userCustomColor,
          border: Border.all(color: kPrimaryColor)
      ),

      child: Container(
        width: 16,
        height: 16,
        // padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
            child:
            // Text(user.fullName!.split('').first.capitalize!, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),))
            Icon(Iconsax.user, size: 12, color: kLightSecondaryColor,)),
      ),
    );
  }
}
