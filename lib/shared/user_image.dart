import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/utils/custom_navigator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../utils/constants.dart';
import 'custom_image_widget.dart';
import 'dart:math' as math;

///Displays a particular user image using cached network image provider
class UserImage extends StatelessWidget {
  const UserImage({Key? key,
    required this.width,
    required this.height,
    this.user,
    this.iconSize = 17,
    this.padding,
    this.margin,
    this.showUserColor = false,
    this.showStoryWidget = true,
  }) : super(key: key);

  final double width;
  final double height;
  final SkibbleUser? user;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showUserColor;
  final bool showStoryWidget;
  @override
  Widget build(BuildContext context) {

    if (user != null) {
      if(user!.accountType == AccountType.kitchen) {
        if(user!.profileImageUrl != null) {
          return KitchenProfileImage(width: width, height: height,  margin: margin, padding: padding, user: user!,);
        }
        else {
          return KitchenNullImage(width: width, height: height,  margin: margin, padding: padding,);
        }
      }
      else {
        if(user!.profileMediaList != null) {

          if(user!.profileMediaList!.isNotEmpty) {
            return UserProfileImage(width: width, height: height,  margin: margin, padding: padding, user: user!, showStoryWidget: showStoryWidget,);

          }

          else {
            return UserNullImage(width: width, height: height,  margin: margin, padding: padding, user: showUserColor ? user : null,);
          }
        }

        else {
          return UserNullImage(width: width, height: height,  margin: margin, padding: padding, user: showUserColor ? user : null,);
        }
      }
    }

    else {
      return UserNullImage(width: width, height: height, margin: margin, padding: padding, user: showUserColor ? user : null,);
    }
  }
}


class UserProfileImage extends StatelessWidget {
  const UserProfileImage({Key? key,
    required this.width,
    required this.height,
    required this.user,
    this.iconSize = 17,
    this.padding,
    this.margin,
    this.showStoryWidget = false
  }) : super(key: key);

  final double width;
  final double height;
  final SkibbleUser user;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showStoryWidget;

  @override
  Widget build(BuildContext context) {
    // print(user.profileMediaList![0].toMap());
    return GestureDetector(
      onTap: () {
        CustomNavigator().navigateToProfileMediaStory(context, user);
      },
      child: Container(
        width: width ,
        height: height ,
        margin: margin,

        child: Column(
          children: [
            if(user.profileMediaList != null)

              if(showStoryWidget)
                CircularStepProgressIndicator(
                totalSteps: user.profileMediaList!.isNotEmpty ? user.profileMediaList!.length : 1,
                width: width,
                height: height,
                padding: math.pi / 8,

                circularDirection: CircularDirection.counterclockwise,
                customColor: (index) {
                  return kPrimaryColor;
                },
                // selectedColor: kPrimaryColor,
                // unselectedColor: Colors.grey.shade300,
                // selectedStepSize: 3,
                // unselectedStepSize: 3,
                stepSize: 2.5,
                // arcSize : math.pi * ,
                roundedCap: (index, _) => true,

                child: Container(
                  // width: width ,
                  // height: height ,
                  margin: const EdgeInsets.all(2.5),
                  decoration: user.profileMediaList == null ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: user.userCustomColor
                  ) : null,
                  child: user.profileMediaList == null ? const Center(
                      child: Icon(Iconsax.user, size: 28, color: kLightSecondaryColor,))
                      :
                  ExtendedImage.network(
                    user.profileMediaList![0].mediaUrl!,
                    height: width,
                    width: height,
                    fit: BoxFit.cover,
                    cache: true,
                    shape: BoxShape.circle,
                    loadStateChanged: (ExtendedImageState state) {
                      switch (state.extendedImageLoadState) {
                        case LoadState.loading:
                        // _controller.reset();
                          return Container(decoration: BoxDecoration(color: Colors.grey.shade300),);

                      ///if you don't want override completed widget
                      ///please return null or state.completedWidget
                      //return null;
                      //return state.completedWidget;
                        case LoadState.completed:
                        // _controller.forward();
                          return state.completedWidget;
                        case LoadState.failed:
                        // _controller.reset();
                          return GestureDetector(
                            child: const Center(
                              child: Text(
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
                  ),

                  ///
                ),

              )
              else
                Container(
                  height: width,
                  width: height,
                  margin: margin,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                  ),
                  child: CustomNetworkImageWidget(
                    height: width,
                    width: height,
                    isCircleShaped: true,
                    imageUrl: user.profileMediaList![0].mediaUrl!,),),
          ],
        ),
      ),
    );
  }
}
class UserNullImage extends StatelessWidget {
  const UserNullImage({Key? key,
    required this.width,
    required this.height,
    this.user,
    this.iconSize = 17,
    this.padding,
    this.margin
  }) : super(key: key);

  final double width;
  final double height;
  final SkibbleUser? user;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: width,
        width: height,
        alignment: Alignment.center,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: user?.userCustomColor ?? Colors.grey.shade300,
          // border: Border.all(color: user.userCustomColor ?? kPrimaryColor)
          //TODO: Work on this later
          // image: user.profileImageUrl != null ? DecorationImage(
          //     image: CachedNetworkImageProvider(user.profileImageUrl!),
          //   fit: BoxFit.cover
          // ) : null
        ),
        child: Center(child: Icon(CupertinoIcons.person_solid, size: (height * 5 ) / 8, color: kLightSecondaryColor,)));
  }
}

class KitchenProfileImage extends StatelessWidget {
  const KitchenProfileImage({Key? key,
    required this.width,
    required this.height,
    required this.user,
    this.iconSize = 17,
    this.padding,
    this.margin
  }) : super(key: key);

  final double width;
  final double height;
  final SkibbleUser user;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width + 5,
      child: Stack(
        children: [
          Container(
              height: width,
              width: height,
              margin: margin,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kDarkSecondaryColor, width: 2)
              ),
              child: CustomNetworkImageWidget(
                height: width,
                width: height,
                isCircleShaped: true,
                imageUrl: user.profileImageUrl!,),),

          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                    height:((width + height) / 8 )* 1.7,
                    width: ((width + height) / 8 ) * 2.4,
                    decoration: BoxDecoration(
                        color: kDarkSecondaryColor,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Icon(Iconsax.shop, size: ((width + height) / 8) + 2, color: kLightSecondaryColor,))
                ),
              )
          )
        ],
      ),
    );
    // return Container(
    //   margin: margin,
    //   child: CustomNetworkImageWidget(
    //     height: width,
    //     width: height,
    //     isCircleShaped: true,
    //     imageUrl: user!.profileImageUrl!,),
    // );
  }
}


class KitchenNullImage extends StatelessWidget {
  const KitchenNullImage({Key? key,
    required this.width,
    required this.height,
    this.user,
    this.iconSize = 17,
    this.padding,
    this.margin
  }) : super(key: key);

  final double width;
  final double height;
  final SkibbleUser? user;
  final double iconSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width + 5,
      child: Stack(
        children: [
          Container(
              height: width,
              width: height,
              alignment: Alignment.center,
              padding: padding,
              margin: margin,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                  border: Border.all(color: kDarkSecondaryColor, width: 2)
                //TODO: Work on this later
                // image: user.profileImageUrl != null ? DecorationImage(
                //     image: CachedNetworkImageProvider(user.profileImageUrl!),
                //   fit: BoxFit.cover
                // ) : null
              ),
              child: Center(child: Icon(CupertinoIcons.person_solid, size: (height * 5 ) / 8, color: kLightSecondaryColor,))),

          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                    height:((width + height) / 8 )* 1.7,
                    width: ((width + height) / 8 ) * 2.4,
                    decoration: BoxDecoration(
                        color: kDarkSecondaryColor,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(child: Icon(Iconsax.shop, size: ((width + height) / 8) + 2, color: kLightSecondaryColor,))
                ),
              )
          )
        ],
      ),
    );
  }
}