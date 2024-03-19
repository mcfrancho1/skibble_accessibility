import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
// import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/shared/shimmer.dart';
import 'package:skibble/shared/user_image.dart';

import '../services/change_data_notifiers/app_data.dart';
import '../utils/constants.dart';
import '../utils/current_theme.dart';
import 'custom_image_widget.dart';

class UserProfileFuture extends StatefulWidget {
  const UserProfileFuture({Key? key,
    required this.userId,
    this.userProfileFuture,
    this.width = 40,
    this.height = 40,
    required this.hasFuture,
    required this.showName,
    this.titleTextColor,
    required this.isDoubleLine,
    this.secondLineText,
    this.useFullName = true,
    this.onSecondLineTextTapped,
    this.user,
    this.secondLinePreWidget,
    this.subTitleTextColor
    // required this.waitingWidget,
  })
      :
        super(key: key);

  final String userId;
  final SkibbleUser? user;
  final Future<SkibbleUser?>? userProfileFuture;
  final double height;
  final double width;
  final bool hasFuture;
  final bool showName;
  final bool useFullName;
  final bool isDoubleLine;
  final String? secondLineText;
  final Function()? onSecondLineTextTapped;
  final Color? titleTextColor;
  final Color? subTitleTextColor;
  final Widget? secondLinePreWidget;
  // final Widget userProfileWidget;
  // final Widget waitingWidget;

  @override
  _UserProfileFutureState createState() => _UserProfileFutureState();
}

class _UserProfileFutureState extends State<UserProfileFuture> {

  // final GlobalKey = GlobalKey();
  Future<SkibbleUser?>? userProfileFuture;
  SkibbleUser? userProfile ;
  @override
  void initState() {
    // TODO: implement initState
    var currentUser = Provider.of<AppData>(context,listen: false).skibbleUser!;

    userProfile = widget.user;

    if(userProfile == null) {
      if(currentUser.userId == widget.userId) {
        userProfileFuture = Future.value(currentUser);
      }

      else {
        if(!widget.hasFuture) {
          var user = Provider.of<AppData>(context,listen: false).getUserFromMap(widget.userId);

          if(user != null) {
            userProfileFuture = Future.value(user);
          }
          else {
            userProfileFuture = UserDatabaseService().getUserDoc(widget.userId, context);
          }
        }
        else {
          userProfileFuture = widget.userProfileFuture;
        }
      }
    }

    // else {
    //   if(userProfile!.userId == currentUser.userId) {
    //     userProfile = currentUser;
    //   }
    // }
    super.initState();
  }

  Future<SkibbleUser?>? getUserData() {
    var user = Provider.of<AppData>(context,listen: false).getUserFromMap(widget.userId);

    if(user != null) {
      return Future.value(user);
    }
    else {

      return UserDatabaseService().getUserDoc(widget.userId, context);
    }
  }
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context,listen: false).skibbleUser!;
    var user = Provider.of<AppData>(context,listen: false).getUserFromMap(widget.userId);

    userProfile = currentUser.userId == widget.userId ? currentUser : widget.user;

    return userProfile != null ? Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserImage(width: widget.width, height: widget.height, user: userProfile,),
        // Container(
        //     height: widget.height,
        //     width: widget.width,
        //     // alignment: Alignment.center,
        //     // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        //     // margin: EdgeInsets.only(right: 20),
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.grey.shade200,
        //       //TODO: Work on this later
        //       // image: user.profileImageUrl != null ? DecorationImage(
        //       //     image: CachedNetworkImageProvider(user.profileImageUrl!),
        //       //     fit: BoxFit.cover
        //       // ) : null
        //     ),
        //     child: userProfile!.profileImageUrl == null ?
        //     Center(
        //         child: Icon(CupertinoIcons.person_solid, size: 18, color: Colors.grey,))
        //         :
        //     Padding(
        //       padding: const EdgeInsets.all(1.0),
        //       child: Center(
        //         child: CustomNetworkImageWidget(
        //           imageUrl: userProfile!.profileImageUrl!,
        //           isCircleShaped: true,
        //         )
        //
        //         // ExtendedImage.network(
        //         //   userProfile!.profileImageUrl!,                          // width: 25,
        //         //   // height: 400,
        //         //   fit: BoxFit.cover,
        //         //   cache: true,
        //         //   shape: BoxShape.circle,
        //         //   loadStateChanged: (ExtendedImageState state) {
        //         //     switch (state.extendedImageLoadState) {
        //         //       case LoadState.loading:
        //         //       // _controller.reset();
        //         //         return Container(decoration: BoxDecoration(color: Colors.grey.shade300),);
        //         //
        //         //     ///if you don't want override completed widget
        //         //     ///please return null or state.completedWidget
        //         //     //return null;
        //         //     //return state.completedWidget;
        //         //       case LoadState.completed:
        //         //       // _controller.forward();
        //         //         return state.completedWidget;
        //         //       case LoadState.failed:
        //         //       // _controller.reset();
        //         //         return GestureDetector(
        //         //           child: Center(
        //         //             child: Icon(Icons.error)
        //         //           ),
        //         //           onTap: () {
        //         //             state.reLoadImage();
        //         //           },
        //         //         );
        //         //
        //         //     }
        //         //   },
        //         //   // borderRadius: BorderRadius.all(Radius.circular(30.0)),
        //         //   //cancelToken: cancellationToken,
        //         // )
        //
        //         ///
        //         //
        //         // CachedNetworkImage(
        //         //   imageUrl: userProfile!.profileImageUrl!,
        //         //   fit: BoxFit.cover,
        //         //   memCacheWidth: 10,
        //         //   memCacheHeight: 10,
        //         //   // height: widget.height,
        //         //   // width: widget.width,
        //         //   imageBuilder: (context, imageProvider) => Container(
        //         //     height: widget.height,
        //         //     width: widget.width,
        //         //     decoration: BoxDecoration(
        //         //       shape: BoxShape.circle,
        //         //       image: DecorationImage(
        //         //           image: imageProvider,
        //         //           fit: BoxFit.cover
        //         //       ),
        //         //     ),
        //         //   ),
        //         // ),
        //       ),
        //     )
        //
        // ),
        widget.showName ? SizedBox(width: 10,)
            : Container(),

        widget.showName ? widget.isDoubleLine ?
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                        widget.useFullName ? userProfile!.fullName! : '@${userProfile!.userName!}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          color: widget.titleTextColor != null ? widget.titleTextColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                        )),
                  ),
                  SizedBox(width: 5,),
                  if(userProfile!.isUserVerified)
                    Icon(Iconsax.verify5, size: 15,
                      color: kPrimaryColor,)
                ],
              ),
              SizedBox(height: 2,),
              widget.secondLineText != null ? widget.secondLinePreWidget != null ?
              ///shows only the second line with a widget before it

              Row(
                children: [
                  widget.secondLinePreWidget!,
                  Flexible(
                    child: GestureDetector(
                        onTap: widget.onSecondLineTextTapped,
                        child: Text(
                          widget.secondLineText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: widget.subTitleTextColor != null ? widget.subTitleTextColor : Colors.grey, fontSize: 14),)),
                  )
                ],
              )
                  :
              ///shows only the second line without a widget before it
              GestureDetector(
                  onTap: widget.onSecondLineTextTapped,
                  child: Text(
                    widget.secondLineText!,
                    style: TextStyle(color: Colors.grey, fontSize: 14),))
                  :
              ///shows only the second line without a widget before it and using the user's username
              Text(
                '@${userProfile!.userName!}',
                style: TextStyle(color: widget.subTitleTextColor != null ? widget.subTitleTextColor : Colors.grey, fontSize: 14),)
            ],),
        )
            :
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                    widget.useFullName ? userProfile!.fullName! : '@${userProfile!.userName!}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      color: widget.titleTextColor != null ? widget.titleTextColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                    )
                ),
              ),
              SizedBox(width: 5,),
              if(userProfile!.isUserVerified)
                Icon(Iconsax.verify5, size: 15,
                  color: kPrimaryColor,)
            ],
          ),
        )
            :
        Container(),
      ],
    )
        :
    FutureBuilder(
      // key: ValueKey(userProfileId) ,
      future: userProfileFuture,
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return ProfileShimmer(showName: widget.showName,);

          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasData) {
              SkibbleUser user = snapshot.data as SkibbleUser;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                 UserImage(width: widget.height, height: widget.height, user: userProfile,),

                  // Container(
                  //     height: widget.height,
                  //     width: widget.width,
                  //     // alignment: Alignment.center,
                  //     // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  //     // margin: EdgeInsets.only(right: 20),
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: user.userCustomColor,
                  //       //TODO: Work on this later
                  //       // image: user.profileImageUrl != null ? DecorationImage(
                  //       //     image: CachedNetworkImageProvider(user.profileImageUrl!),
                  //       //     fit: BoxFit.cover
                  //       // ) : null
                  //     ),
                  //     child: user.profileImageUrl == null ? Center(
                  //         child: Icon(Iconsax.user, size: 15, color: kLightSecondaryColor,)) :
                  //     Center(
                  //         child: CustomNetworkImageWidget(
                  //           imageUrl:  userProfile?.profileImageUrl!,
                  //           isCircleShaped: true,
                  //         )
                  //       // ExtendedImage.network(
                  //       //   userProfile!.profileImageUrl!,                          // width: 25,
                  //       //   // height: 400,
                  //       //   fit: BoxFit.cover,
                  //       //   cache: true,
                  //       //   shape: BoxShape.circle,
                  //       //   loadStateChanged: (ExtendedImageState state) {
                  //       //     switch (state.extendedImageLoadState) {
                  //       //       case LoadState.loading:
                  //       //       // _controller.reset();
                  //       //         return Container(decoration: BoxDecoration(color: Colors.grey.shade300),);
                  //       //
                  //       //     ///if you don't want override completed widget
                  //       //     ///please return null or state.completedWidget
                  //       //     //return null;
                  //       //     //return state.completedWidget;
                  //       //       case LoadState.completed:
                  //       //       // _controller.forward();
                  //       //         return state.completedWidget;
                  //       //       case LoadState.failed:
                  //       //       // _controller.reset();
                  //       //         return GestureDetector(
                  //       //           child: Center(
                  //       //               child: Icon(Icons.error)
                  //       //           ),
                  //       //           onTap: () {
                  //       //             state.reLoadImage();
                  //       //           },
                  //       //         );
                  //       //
                  //       //     }
                  //       //   },
                  //       //   // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  //       //   //cancelToken: cancellationToken,
                  //       // )
                  //
                  //       ///
                  //       // CachedNetworkImage(
                  //       //   imageUrl: user.profileImageUrl!,
                  //       //   fit: BoxFit.cover,
                  //       //   memCacheWidth: 50,
                  //       //   memCacheHeight: 50,
                  //       //   // height: widget.height,
                  //       //   // width: widget.width,
                  //       //   imageBuilder: (context, imageProvider) => Container(
                  //       //     height: widget.height,
                  //       //     width: widget.width,
                  //       //     decoration: BoxDecoration(
                  //       //       shape: BoxShape.circle,
                  //       //       image: DecorationImage(
                  //       //         image: imageProvider,
                  //       //         fit: BoxFit.cover
                  //       //       ),
                  //       //     ),
                  //       // ),
                  //       // ),
                  //     )
                  //
                  // ),
                  widget.showName ? SizedBox(width: 10,) : Container(),

                  widget.showName ? widget.isDoubleLine ?
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.useFullName ? user.fullName! : '@${user.userName!}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: widget.titleTextColor != null ? widget.titleTextColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                                )),
                            ),
                            SizedBox(width: 5,),
                            if(user.isUserVerified)
                              Icon(Iconsax.verify5, size: 15,
                                color: kPrimaryColor,)
                          ],
                        ),
                        SizedBox(height: 2,),
                        widget.secondLineText != null ? widget.secondLinePreWidget != null ?
                        ///shows only the second line with a widget before it

                        Row(
                          children: [
                            widget.secondLinePreWidget!,
                            Flexible(
                              child: GestureDetector(
                                  onTap: widget.onSecondLineTextTapped,
                                  child: Text(
                                    widget.secondLineText!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: widget.subTitleTextColor != null ? widget.subTitleTextColor : Colors.grey, fontSize: 14),)),
                            )
                          ],
                        )
                            :
                            ///shows only the second line without a widget before it
                        GestureDetector(
                          onTap: widget.onSecondLineTextTapped,
                          child: Text(
                            widget.secondLineText!,
                            style: TextStyle(color: Colors.grey, fontSize: 14),))
                            :
                        ///shows only the second line without a widget before it and using the user's username
                        Text(
                          '@${user.userName!}',
                          style: TextStyle(color: widget.subTitleTextColor != null ? widget.subTitleTextColor : Colors.grey, fontSize: 14),)
                      ],),
                  )
                      :
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                              widget.useFullName ? user.fullName! : '@${user.userName!}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                              fontSize: 17,
                              color: widget.titleTextColor != null ? widget.titleTextColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                              )
                          ),
                        ),
                        SizedBox(width: 5,),
                        if(user.isUserVerified)
                          Icon(Iconsax.verify5, size: 15,
                          color: kPrimaryColor,)
                      ],
                    ),
                  )
                      :
                  Container(),
                ],
              );
            }
            else {
              return Row(
                children: [
                  Container(
                    height: widget.height,
                    width: widget.width,
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    // margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      color: Colors.grey
                    ),
                    child:  Center(
                        child: Icon(Iconsax.user, size: 15, color: kLightSecondaryColor,)),

                  ),
                  SizedBox(width: 15,),
                  Container(
                    child: Text('User Deleted', style: TextStyle(color: kErrorColor),),
                  ),
                ],
              );
            }
        }
      }
    );
  }
}

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({Key? key, required this.showName}) : super(key: key);

  final bool showName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(2),
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey
          ),
        ),

        showName ? SizedBox(width: 10,) : Container(),
        showName ? Container(
          width: 50,
          height: 15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey
          ),
        ) : Container()
      ],
    );
  }
}



