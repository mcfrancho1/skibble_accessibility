
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/map_launcher_controller.dart';
import 'package:skibble/models/combine_message_user_stream.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/services/firebase/database/feed_database.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/shared/profile_future.dart';
import 'package:skibble/shared/user_image.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/helper_methods.dart';


import '../../../controllers/skib_controller.dart';
import '../../../models/chat_models/chat_message.dart';
import '../../../models/pop_up_item.dart';
import '../../../models/skibble_post.dart';
import '../../../models/skibble_post_comment.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../shared/dialogs.dart';
import '../../../shared/flag_post_view.dart';
import '../../../shared/read_more_text.dart';
import '../../../shared/report_user_view.dart';
import '../../booking/share_friend_view.dart';
import '../../profile/current_user_profile_page.dart';
import '../../profile/user_profile.dart';
import 'skib_card.dart';
import '../../home/feed_page.dart';

///Used to fetch the likes for a skibble post

///Used to fetch the likes for a skibble post
// class ViewPostFutureLikes extends StatefulWidget {
//   const ViewPostFutureLikes({Key? key, required this.post}) : super(key: key);
//   final SkibblePost post;
//
//
//   @override
//   State<ViewPostFutureLikes> createState() => _ViewPostFutureLikesState();
// }
//
// class _ViewPostFutureLikesState extends State<ViewPostFutureLikes> {
//
//
//   Future? likesFuture;
//   @override
//   void initState() {
//     likesFuture = FeedDatabaseService().getAllLikesForPost(widget.post, context);
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: likesFuture,
//         builder: (context, snapshot) {
//           switch(snapshot.connectionState) {
//
//             case ConnectionState.none:
//             case ConnectionState.waiting:
//               return Scaffold(
//                 body: Container(
//                     // height: 200,
//                     // // width: ,
//                     // decoration: BoxDecoration(
//                     //   color: Colors.grey,
//                     //   borderRadius: BorderRadius.circular(20),
//                     // )
//                 ),
//               );
//             case ConnectionState.active:
//
//             case ConnectionState.done:
//               if(snapshot.hasData) {
//                 Map<String,List<String>> likes = snapshot.data as Map<String,List<String>>;
//                 widget.post.likesDocMap = likes;
//                 likes.values.forEach((list) {widget.post.likesList!.addAll(list.toSet()); });
//
//                 return ViewPostScreen(post: widget.post, isFromFeedScreen: false);
//               }
//               else {
//                 return Container(
//                   height: 200,
//                   // width: ,
//                   decoration: BoxDecoration(
//                     color: Colors.grey,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Center(child: Text('This post is unavailable')),
//                 );
//               }
//           }
//         }
//     );
//   }
// }

class ViewPostScreen extends StatefulWidget {
  final String postId;
  // final SkibbleUser? skibAuthor;
  final bool isFromFeedScreen;
  final bool closeAppOnBackPressed;
  final StreamController<SkibblePost?>? streamController;

  ViewPostScreen({
    this.streamController,
    required this.postId,
    // this.skibAuthor,
    required this.isFromFeedScreen,
    this.closeAppOnBackPressed = false
  });

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {

  // StreamController<List<CombineMessageUserStream>>? streamController;
  //
  // Stream<List<CombineMessageUserStream>>? commentsStream;

  TextEditingController commentsController = TextEditingController();

  late ScrollController _scrollController;
  bool isScrolled = false;
  double controllerOffset = 300.0;

  void _listenToScrollChange() {
    if (_scrollController.offset >= controllerOffset) {

      setState(() {
        isScrolled = true;
      });
    } else {
      setState(() {
        isScrolled = false;
      });
    }
  }

  Future<SkibbleUser?>? userFuture;

  StreamController<SkibblePost?>? _postStreamController;
  late final Stream<SkibblePost?> postStream;

  @override
  void initState() {
    // TODO: implement initState

    _postStreamController = StreamController<SkibblePost?>();

    postStream = FeedDatabaseService().streamSkib(widget.postId, context);
    _postStreamController!.addStream(postStream);

    // if(widget.streamController != null) {
    //   _postStreamController = widget.streamController!;
    //
    //   // postStream = widget.streamController!.stream;
    //
    //   _postStreamController!.stream.listen((event) {
    //     print('hey');
    //     _postStreamController!.add(event);
    //
    //   });
    //
    // }
    // else {
    //   _postStreamController = StreamController<SkibblePost?>.broadcast();
    //
    //   postStream = FeedDatabaseService().streamSkib(widget.postId, context);
    //   _postStreamController!.addStream(postStream);
    // }


    // if(widget.skibAuthor == null) {
    //   var user = Provider.of<AppData>(context,listen: false).getUserFromMap(widget.post.postAuthorId);
    //
    //   if(user != null) {
    //     userFuture = Future.value(user);
    //     _postAuthor = user;
    //   }
    //   else {
    //     userFuture = UserDatabaseService().getUserDoc(widget.post.postAuthorId, context).then((value) {
    //       setState(() {
    //         _postAuthor = value!;
    //       });
    //       return value;
    //     });
    //   }
    // }
    // else {
    //   _postAuthor = widget.skibAuthor!;
    //   userFuture = Future.value(widget.skibAuthor);
    // }

    // streamController = StreamController<List<CombineMessageUserStream>>.broadcast();
    // streamController!.addStream(FeedDatabaseService().streamSkibblePostComments(widget.postId)!);

    // commentsStream = FeedDatabaseService().streamSkibblePostComments(widget.post.postId!);

    _scrollController = ScrollController();

    _scrollController.addListener(_listenToScrollChange);

    super.initState();
  }

  @override
  void dispose() {
    if(widget.streamController == null){
      _postStreamController = null;
    }
    // streamController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;

    return Scaffold(
      body: StreamBuilder<SkibblePost?>(
        stream: _postStreamController!.stream,
        builder: (context, snapshot) {

          switch(snapshot.connectionState) {
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:

              return Center(
                child: Container(
                width: 80,
                height: 80,
                  child: CircularProgressIndicator(color: kPrimaryColor, strokeWidth: 1,)));
            case ConnectionState.active:
            case ConnectionState.done:
            SkibblePost skibblePost = snapshot.data as SkibblePost;
            if(skibblePost.postExists) {
              return GestureDetector(
                onTap: () => HelperMethods().dismissKeyboard(context),
                child: Scaffold(
                  // backgroundColor: Color(0xFFEDF0F6),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
                    leadingWidth: 25,
                    leading: IconButton(
                        onPressed: () {
                          if(widget.closeAppOnBackPressed) {
                            SystemNavigator.pop();
                          }
                          else {
                            Navigator.of(context).pop(skibblePost.totalLikes);
                          }
                        },
                        splashRadius: 20,
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                        )) ,

                    title: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => skibblePost.postAuthorId == currentUser.userId ?
                              CurrentUserProfilePageView()
                                  :
                              UserProfilePageView(userId: skibblePost.postAuthorId))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: UserProfileFuture(
                          //userProfileFuture: userProfileFuture,
                          userProfileFuture: Future.value(skibblePost.creatorUser),
                          userId: skibblePost.postAuthorId,
                          user: skibblePost.postAuthorId == currentUser.userId? currentUser : skibblePost.creatorUser,
                          hasFuture: true,
                          // userProfileFuture: userFuture!,
                          showName: true,
                          isDoubleLine: skibblePost.postAddress != null ? true : skibblePost.customLocation != null ? true : false,
                          secondLineText: skibblePost.postAddress != null ?  skibblePost.postAddress!.placeName! : skibblePost.customLocation != null ? skibblePost.customLocation : '',
                          onSecondLineTextTapped: () async {
                            if(skibblePost.postAddress != null) {

                              await HelperMethods().fetchAndLoadPlaceInfo(skibblePost.postAddress!.googlePlaceId!, context, contentId: widget.postId);
                            }
                          },
                          subTitleTextColor: kPrimaryColor,
                          secondLinePreWidget: Container(
                              margin: EdgeInsets.only(right: 3),
                              child: Icon(Icons.restaurant, color: kPrimaryColor, size: 15,)),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomDialog(context).showPopupMenu(
                            [
                              if(skibblePost.postAuthorId == currentUser.userId)
                                PopUpChoiceItem(iconData: Iconsax.edit, choiceString: 'Edit skib'),

                              PopUpChoiceItem(iconData: Iconsax.send_2, choiceString: 'Share with friends'),
                              PopUpChoiceItem(iconData: Iconsax.flag, choiceString: 'Flag skib'),
                              if(skibblePost.postAuthorId != currentUser.userId)
                                PopUpChoiceItem(iconData: Iconsax.info_circle, choiceString: 'Report user'),

                              if(skibblePost.postAuthorId == currentUser.userId)
                                PopUpChoiceItem(iconData: Iconsax.trash, choiceString: 'Delete skib'),
                            ],
                            Iconsax.more,
                            iconColor: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                            onSelected: (p0) async => await HelperMethods().handleSkibPopupMenu(skibblePost, p0,currentUser, context)
                        ),
                      ),
                      // SizedBox(width: kDefaultPadding / 2),
                    ],
                  ),

                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10,),
                              SkibContentView(
                                onLikePost: () async{
                                  // bool value = await PostController().handleLikeAndDislikePost(context, user, widget.post);
                                  // // await likePost(user);
                                  // // print(value);
                                  // if(!value) {
                                  //   setState(() {
                                  //     if(!widget.post.likesList!.contains(user.userId)) {
                                  //       widget.post.likesList!.add(user.userId!);
                                  //       // widget.post.totalLikes += 1;
                                  //     }
                                  //     else {
                                  //       widget.post.likesList!.remove(user.userId!);
                                  //       // widget.post.totalLikes -= 1;
                                  //     }
                                  //   });
                                  // }
                                  //
                                  // else {
                                  //   if(!widget.isFromFeedScreen) {
                                  //     setState(() {
                                  //       if(!widget.post.likesList!.contains(user.userId)) {
                                  //         widget.post.likesList!.add(user.userId!);
                                  //         // widget.post.totalLikes += 1;
                                  //       }
                                  //       else {
                                  //         widget.post.likesList!.remove(user.userId!);
                                  //         // widget.post.totalLikes -= 1;
                                  //       }
                                  //     });
                                  //   }
                                  //   else {
                                  //     setState(() {});
                                  //   }
                                  // }

                                },
                                skibblePost: skibblePost,
                                isOnCommentPage: true,
                                skibAuthor: skibblePost.creatorUser,                              ),

                              // Divider(),
                              //
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              //     )),
                              // Container(
                              //   // width: double.infinity,
                              //   // decoration: BoxDecoration(
                              //   //   color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                              //   // ),
                              //   child: StreamBuilder(
                              //       stream: streamController!.stream,
                              //       builder: (context, snapshot) {
                              //         switch(snapshot.connectionState) {
                              //
                              //           case ConnectionState.none:
                              //             return Container();
                              //           case ConnectionState.waiting:
                              //             return Container();
                              //
                              //           case ConnectionState.active:
                              //           case ConnectionState.done:
                              //           // TODO: Handle this case.
                              //             if(snapshot.hasData) {
                              //
                              //               List<CombineMessageUserStream> comments = snapshot.data as List<CombineMessageUserStream>;
                              //               return comments.isEmpty ?
                              //               Center(
                              //                   child: Text('No Comments', style: TextStyle(color: Colors.grey),))
                              //                   :
                              //               Column(
                              //                   children: List.generate(
                              //                       comments.length, (index) => SkibblePostCommentTile(
                              //                       index: index, comment: comments[index]))
                              //               );
                              //             }
                              //             else {
                              //               return Container(child: Text('No comments'),);
                              //             }
                              //         }
                              //
                              //       }
                              //   ),
                              // )
                            ],
                          ),
                        ),
                      ),

                      //chat box at the bottom of the page
                      // Container(
                      //   height: 100.0,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(30.0),
                      //       topRight: Radius.circular(30.0),
                      //     ),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black12,
                      //         offset: Offset(0, -2),
                      //         blurRadius: 6.0,
                      //       ),
                      //     ],
                      //     color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kLightSecondaryColor,
                      //   ),
                      //   child: Padding(
                      //     padding: EdgeInsets.all(12.0),
                      //     child: TextField(
                      //       controller: commentsController,
                      //       decoration: InputDecoration(
                      //           border: InputBorder.none,
                      //           enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(30.0),
                      //             borderSide: BorderSide(color: Colors.grey),
                      //           ),
                      //           focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(30.0),
                      //             borderSide: BorderSide(color: Colors.grey),
                      //           ),
                      //           contentPadding: EdgeInsets.all(20.0),
                      //           hintText: 'Comment on this skib...',
                      //
                      //           prefixIcon: Container(
                      //             margin: EdgeInsets.all(8.0),
                      //             width: 48.0,
                      //             height: 48.0,
                      //             decoration: BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               boxShadow: [
                      //                 BoxShadow(
                      //                   color: Colors.black45,
                      //                   offset: Offset(0, 2),
                      //                   blurRadius: 6.0,
                      //                 ),
                      //               ],
                      //
                      //             ),
                      //             child: CircleAvatar(
                      //                 child: UserImage(user: currentUser, height: 48, width: 48,)
                      //             ),
                      //           ),
                      //           suffixIcon: Container(
                      //             padding: EdgeInsets.all(12.0),
                      //             margin: EdgeInsets.symmetric(horizontal: 8),
                      //             decoration: BoxDecoration(
                      //                 color: kPrimaryColor,
                      //                 shape: BoxShape.circle
                      //             ),
                      //             child: InkWell(
                      //
                      //                 onTap: () async{
                      //                   if(commentsController.text.isNotEmpty) {
                      //                     int timePosted = DateTime.now().millisecondsSinceEpoch;
                      //                     // SkibblePostComment comment = SkibblePostComment(
                      //                     //     userId: user.userId!,
                      //                     //     userComment: commentsController.text,
                      //                     //     commentId: '',
                      //                     //     timePosted: timePosted
                      //                     // );
                      //
                      //                     ChatMessage chatMessage = ChatMessage(
                      //                       idFrom: currentUser.userId!, idTo: widget.postId,
                      //                       timestamp: timePosted,
                      //                       content: commentsController.text,
                      //                       messageType: ChatMessageType.text,
                      //                     );
                      //
                      //                     commentsController.clear();
                      //                     HelperMethods().dismissKeyboard(context);
                      //
                      //                     await FeedDatabaseService().commentOnPost(chatMessage, widget.postId);
                      //
                      //                   }
                      //                 },
                      //                 child: Icon(
                      //                   Iconsax.send_2,
                      //                   color: Colors.white,
                      //                 )
                      //             ),
                      //           )
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),

                ),
              );
            }
            else {
              return Container(child: Center(child: Text('This post may have been deleted')),);
            }
          }
        }
      ),
    );
  }
}

class SkibblePostCommentTile extends StatefulWidget {
  const SkibblePostCommentTile({Key? key, required this.index, required this.comment, this.contentPadding}) : super(key: key);
  final int index;
  final CombineMessageUserStream comment;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<SkibblePostCommentTile> createState() => _SkibblePostCommentTileState();
}

class _SkibblePostCommentTileState extends State<SkibblePostCommentTile> {

  Future? userFuture;
  @override
  void initState() {
    // TODO: implement initState
    // var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
    //
    // if(currentUser.userId == widget.comment.userId) {
    //   userFuture = Future.value(currentUser);
    // }
    // else {
    //   var user = Provider.of<AppData>(context,listen: false).getUserFromMap(widget.comment.userId);
    //
    //   if(user != null) {
    //     userFuture = Future.value(user);
    //   }
    //   else {
    //     userFuture = UserDatabaseService().getUserDoc(widget.comment.userId, context);
    //   }
    // }

    // userFuture = user.userId == widget.comment.userId ? Future.value(user) :  UserDatabaseService().getUserDoc(widget.comment.userId);


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<AppData>(context).skibbleUser!;
    return Padding(
      padding: EdgeInsets.only(top: 0.0, bottom: 0, left: 0, right: 10),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            if(widget.comment.user == null || widget.comment.user!.userId == null) {
              CustomBottomSheetDialog.showErrorSheet(context, 'This user may have been deleted', onButtonPressed: () => Navigator.pop(context));

            }
            else {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfilePageView(userId: widget.comment.user!.userId!, user: widget.comment.user!, )));
            }
          },
          child: UserImage(user: widget.comment.user!, height: 40, width: 40,)),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 10, bottom: 0),
          child: Text('${HelperMethods().formatFeedTimeStamp(widget.comment.chatMessage!.timestamp)}', style: TextStyle(color: Colors.grey, fontSize: 10),),
        ),
        contentPadding: widget.contentPadding,
        title: Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 10, bottom: 0),
          child: ExpandableText(
            widget.comment.chatMessage!.content!,
            expandText: 'show more',
            collapseText: 'show less',
            maxLines: 3,

            linkColor: kPrimaryColor,
            animation: true,
            collapseOnTextTap: true,
            style: TextStyle(fontSize: 15, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
            prefixText: '${widget.comment.user!.userName ?? 'User Deleted'}',
            // onPrefixTap: () => showProfile(username),
            prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: widget.comment.user!.userName != null ? CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor : kErrorColor),
            // onHashtagTap: (name) => showHashtag(name),
            // hashtagStyle: TextStyle(
            //   color: Color(0xFF30B6F9),
            // ),
            // onMentionTap: (username) => showProfile(username),
            // mentionStyle: TextStyle(
            //   fontWeight: FontWeight.w600,
            // ),
            //onUrlTap: (url) => launchUrl(url),
            // urlStyle: TextStyle(
            //   decoration: TextDecoration.underline,
            // ),
          ),

          // CustomReadMoreText(
          //   widget.comment.chatMessage!.content!,
          //   trimLines: 3,
          //   preData: '${widget.comment.user!.userName}  ',
          //   colorClickableText: kPrimaryColor,
          //   trimMode: CustomTrimMode.Line,
          //   style: TextStyle(
          //     fontFamily: 'Brand Regular', fontSize: 14,),
          //   trimCollapsedText: 'show more',
          //   trimExpandedText: 'show less',
          //   moreStyle: TextStyle(fontSize: 16, color: Colors.grey),
          //   lessStyle: TextStyle(fontSize: 16, color: Colors.grey),
          //
          // ),
        ),
        // subtitle: Text('How did bake the cakes to get that colour?', style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
        // trailing: InkWell(
        //   onTap: () {
        //     print('Pss');
        //   },
        //   customBorder: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(30)
        //   ),
        //   child: Icon(
        //     Icons.favorite_border,
        //     size: 15,
        //   ),
        // ),
      ),
    );
    //   FutureBuilder(
    //   future: userFuture,
    //   builder: (context, snapshot) {
    //     switch(snapshot.connectionState) {
    //
    //       case ConnectionState.none:
    //       case ConnectionState.waiting:
    //         return ProfileShimmer(showName: true,);
    //       case ConnectionState.active:
    //       case ConnectionState.done:
    //        if(snapshot.hasData) {
    //          SkibbleUser authorUserData = snapshot.data as SkibbleUser;
    //          return Padding(
    //            padding: EdgeInsets.only(top: 5.0, bottom: 0, left: 0, right: 10),
    //            child: ListTile(
    //              leading: UserImage(user: authorUserData, height: 40, width: 40,),
    //              subtitle: Padding(
    //                padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 0),
    //                child: Text('${HelperMethods().formatFeedTimeStamp(widget.comment.timePosted!)}', style: TextStyle(color: Colors.grey, fontSize: 10),),
    //              ),
    //              title: Padding(
    //                padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 0),
    //                child: CustomReadMoreText(
    //                  widget.comment.content!,
    //                  trimLines: 3,
    //                  preData: '${authorUserData.userName}  ',
    //                  colorClickableText: kPrimaryColor,
    //                  trimMode: CustomTrimMode.Line,
    //                  style: TextStyle(
    //                    fontFamily: 'Brand Regular', fontSize: 14,),
    //                  trimCollapsedText: 'show more',
    //                  trimExpandedText: 'show less',
    //                  moreStyle: TextStyle(fontSize: 16, color: Colors.grey),
    //                  lessStyle: TextStyle(fontSize: 16, color: Colors.grey),
    //
    //                ),
    //              ),
    //              // subtitle: Text('How did bake the cakes to get that colour?', style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
    //              // trailing: InkWell(
    //              //   onTap: () {
    //              //     print('Pss');
    //              //   },
    //              //   customBorder: RoundedRectangleBorder(
    //              //       borderRadius: BorderRadius.circular(30)
    //              //   ),
    //              //   child: Icon(
    //              //     Icons.favorite_border,
    //              //     size: 15,
    //              //   ),
    //              // ),
    //            ),
    //          );
    //        }
    //        else {
    //          return Container();
    //        }
    //     }
    //
    //   }
    // );
  }
}

