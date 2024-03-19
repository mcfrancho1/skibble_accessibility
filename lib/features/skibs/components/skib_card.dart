import 'dart:async';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_stack/image_stack.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/skib_controller.dart';
import 'package:skibble/models/recipe.dart';
import 'package:skibble/models/stream_models/liked_skibs_stream.dart';
import 'package:skibble/models/stream_models/users_i_blocked_stream.dart';
import 'package:skibble/services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import 'package:skibble/services/change_data_notifiers/skibs_data.dart';
import 'package:skibble/services/firebase/custom_collections_references.dart';
import 'package:get/get.dart';
import 'package:skibble/features/kitchens/controllers/kitchen_controller.dart';
import 'package:skibble/features/skibs/components/share_content_view.dart';
import 'package:skibble/features/skibs/components/skibs_likes_view.dart';
import 'package:skibble/utils/number_display.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';
import '../../../enums/share_type.dart';
import '../../../localization/app_translation.dart';
import '../../../models/pop_up_item.dart';
import '../../../models/share_model.dart';
import '../../../models/skibble_file.dart';
import '../../../models/skibble_post.dart';
import '../../../models/skibble_user.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/change_data_notifiers/feed_data.dart';
import '../../../services/firebase/database/feed_database.dart';
import '../../../shared/custom_image_widget.dart';
import '../../../shared/custom_video_player.dart';
import '../../../shared/dialogs.dart';
import '../../../shared/profile_future.dart';
import '../../../shared/user_image.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/face_pile.dart';
import '../../../utils/helper_methods.dart';
import '../../booking/share_friend_view.dart';
import '../../profile/current_user_profile_page.dart';
import '../../profile/user_profile.dart';

import '../../recipes/recipe_creator/recipe_view.dart';
import 'comments_view.dart';
import 'likes_view.dart';

class SkibblePostCard extends StatefulWidget {
  const SkibblePostCard({Key? key,
    // required this.skibblePostStream,
    required this.skibblePostId,
    required this.skibblePost,
    required this.isFromFeedScreen, required this.parentContext}) : super(key: key);

  // final SkibblePostStream skibblePostStream;
  final bool isFromFeedScreen;
  final String skibblePostId;
  final SkibblePost skibblePost;
  final BuildContext parentContext;


  @override
  State<SkibblePostCard> createState() => _SkibblePostCardState();
}

class _SkibblePostCardState extends State<SkibblePostCard> with AutomaticKeepAliveClientMixin<SkibblePostCard>{

 @override
 bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    // var userPosts = Provider.of<FeedData>(context).userFeed;

    return GestureDetector(
      onTap: () async{
        // var likes = await Navigator.of(context).push<num>(
        //     MaterialPageRoute(
        //         builder: (context) => ViewPostScreen(
        //           postId: skibblePost.postId!,
        //           // skibAuthor: skibblePost.creatorUser,
        //           isFromFeedScreen: true,
        //           streamController: _streamController,
        //         )
        //     )
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Card(
          elevation: 0,
          color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
          margin: const EdgeInsets.only(top: 4, bottom:4, left: 0, right: 0),
          shape: const RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => widget.skibblePost.postAuthorId == currentUser.userId ?
                                const CurrentUserProfilePageView()
                                    :
                                UserProfilePageView(userId: widget.skibblePost.postAuthorId))),
                        child: UserProfileFuture(
                          key: UniqueKey(),
                          userProfileFuture: Future.value(widget.skibblePost.creatorUser),
                          userId: widget.skibblePost.postAuthorId,
                          user: widget.skibblePost.postAuthorId == currentUser.userId? currentUser : widget.skibblePost.creatorUser,

                          hasFuture: true,
                          showName: true,
                          isDoubleLine: widget.skibblePost.postAddress != null ? true : widget.skibblePost.customLocation != null ? true : false,
                          secondLineText: widget.skibblePost.postAddress != null ?  widget.skibblePost.postAddress!.placeName! : widget.skibblePost.customLocation != null ? widget.skibblePost.customLocation : '',
                          onSecondLineTextTapped: () async {

                            if(widget.skibblePost.postAddress != null) {
                              // await HelperMethods().fetchAndLoadPlaceInfo(widget.skibblePost.postAddress!.googlePlaceId!, context, contentId: widget.skibblePost.postId);

                              await KitchenController().fetchKitchenFromGoogle(context, widget.skibblePost.postAddress!.googlePlaceId!);
                            }
                          },
                          subTitleTextColor: kPrimaryColor,
                          secondLinePreWidget: Container(
                              margin: const EdgeInsets.only(right: 3),
                              child: const Icon(Icons.restaurant, color: kPrimaryColor, size: 15,)),
                        ),

                      ),
                    ),
                    Consumer<UsersIBlockedStream>(
                      builder: (context, data, child) {
                        var usersIBlocked = data.getIds();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomDialog(context).showPopupMenu(
                              [
                                if(widget.skibblePost.postAuthorId == currentUser.userId)
                                  PopUpChoiceItem(iconData: Iconsax.edit, choiceString: 'Edit'),

                                // PopUpChoiceItem(iconData: Iconsax.send_2, choiceString: 'Share'),

                                if(widget.skibblePost.postAuthorId != currentUser.userId)
                                  PopUpChoiceItem(iconData: Iconsax.flag, choiceString: 'Flag'),

                                if(widget.skibblePost.postAuthorId != currentUser.userId)
                                  PopUpChoiceItem(iconData: Iconsax.info_circle, choiceString: 'Report'),

                                if(widget.skibblePost.postAuthorId != currentUser.userId)
                                  PopUpChoiceItem(iconData: Iconsax.user_remove, choiceString: usersIBlocked.contains(widget.skibblePost.postAuthorId) ? 'Unblock' : 'Block'),

                                if(widget.skibblePost.postAuthorId == currentUser.userId)
                                  PopUpChoiceItem(iconData: Iconsax.trash, choiceString: tr.delete.capitalizeFirst),

                              ],
                              Iconsax.more,
                              iconColor: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                              onSelected: (p0) async => await HelperMethods().handleSkibPopupMenu(widget.skibblePost, p0, currentUser, widget.parentContext)
                           ),
                        );
                      }
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5,),

              SkibContentView(
                onLikePost: (){},
                skibblePost: widget.skibblePost,
                isOnCommentPage: false,
                skibAuthor: widget.skibblePost.creatorUser,
                // streamController: _streamController,
              )
            ],
          ),
        ),
      ),
    );
  }
}


class SkibContentView extends StatefulWidget {
  const SkibContentView({Key? key, this.streamController, required this.skibblePost, required this.isOnCommentPage, required this.onLikePost, this.skibAuthor}) : super(key: key);
  final SkibblePost skibblePost;
  final bool isOnCommentPage;
  final Function() onLikePost;
  final SkibbleUser? skibAuthor;
  final StreamController? streamController;


  @override
  State<SkibContentView> createState() => _SkibContentViewState();
}

class _SkibContentViewState extends State<SkibContentView> {


  bool _isLiked = false;
  int maxLines = 2;
  bool isExpand = false;

  int noArrowMaxLines = 2;

  // late final ValueNotifier<Set<String>> likedSkibsNotifier;
  // late final StreamController<SkibblePost?> _streamController;

  //Used to track the number of likes in a post
  // late final Stream<SkibblePost?> postStream;

  @override
  void initState() {
    // _streamController = StreamController<SkibblePost?>();

    //Used to track the number of likes in a post
    // postStream = FeedDatabaseService().streamTotalLikesFromPost(widget.skibblePost.postId!);
        // FeedDatabaseService().streamSkib(widget.skibblePost.postId!, context);

    // _streamController.addStream(postStream);
    // postStream.listen((event) {
    //   print('hey');
    //   _streamController.sink.add(event!);
    // });
    // likedSkibsNotifier = ValueNotifier(Provider.of<FeedData>(context, listen: false).likedSkibsList);

    // likedSkibsNotifier = ValueNotifier(Provider.of<LikedSkibsStream>(context, listen: false).likedSkibsList);

    super.initState();
  }


  @override
  void dispose() {
    // _streamController.close();
    super.dispose();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;

    // setState(() {
    //   likes = _isLiked ? (likes - 1) : (likes + 1);
    // // });

    bool res = await context.read<SkibController>().handleLikeAndDislikePost(context, currentUser, widget.skibblePost);

    //TODO: update the user likedskib list to show the animation first
    // likedSkibsNotifier.value = Provider.of<FeedData>(context, listen: false).likedSkibsList;
    // likedSkibsNotifier.value = Provider.of<LikedSkibsStream>(context, listen: false).getIds().toSet();


    // PostController().handleLikeAndDislikePost(context, currentUser, widget.skibblePost);

    return !isLiked;
  }


  @override
  Widget build(BuildContext context) {
    // var currentUser = Provider.of<AppData>(context).skibbleUser!;
    Size size = MediaQuery.of(context).size;
    // var likedSkibs = Provider.of<FeedData>(context).likedSkibsList;
    // _isLiked = likedSkibs.contains(widget.skibblePost.postId);
    var feedPosts = Provider.of<FeedData>(context,).userFeed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.skibblePost.postContentList!.length == 1 ?
        Container(
          height: widget.isOnCommentPage ? size.height /1.7 : 400,
          width: size.width,
          margin: const EdgeInsets.symmetric(horizontal: 10),

          child: widget.skibblePost.postContentList!.first.fileType == SkibbleFileType.image ?
          Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),

                child: ZoomOverlay(
                  minScale: 0.5, // Optional
                  maxScale: 3.0, // Optional
                  twoTouchOnly: true,
                  child: CustomNetworkImageWidget(
                    imageUrl:  widget.skibblePost.postContentList!.first.mediaUrl!,
                    isCircleShaped: false,
                  )

                  // ExtendedImage.network(
                  //   widget.skibblePost.postContentList!.first!['content'],
                  //   // width: 25,
                  //   // height: 400,
                  //   fit: BoxFit.cover,
                  //   cache: true,
                  //   // shape: BoxShape.circle,
                  //   loadStateChanged: (ExtendedImageState state) {
                  //     switch (state.extendedImageLoadState) {
                  //       case LoadState.loading:
                  //       // _controller.reset();
                  //         return Container(decoration: BoxDecoration(color: Colors.grey.shade300),);
                  //
                  //     ///if you don't want override completed widget
                  //     ///please return null or state.completedWidget
                  //     //return null;
                  //     //return state.completedWidget;
                  //       case LoadState.completed:
                  //       // _controller.forward();
                  //         return state.completedWidget;
                  //       case LoadState.failed:
                  //       // _controller.reset();
                  //         return GestureDetector(
                  //           child: Center(
                  //             child: Text(
                  //               "Image loading failed, click to reload",
                  //               textAlign: TextAlign.center,
                  //             ),
                  //           ),
                  //           onTap: () {
                  //             state.reLoadImage();
                  //           },
                  //         );
                  //
                  //     }
                  //   },
                  //   // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  //   //cancelToken: cancellationToken,
                  // )

                  // CachedNetworkImage(
                  //   imageUrl: widget.skibblePost.postContentList!.first!['content'],
                  //   fit: BoxFit.cover,
                  //   memCacheHeight: 400,
                  //   memCacheWidth: (size.width - 20).toInt(),
                  //   placeholder: (context, s) {
                  //     return Container(decoration: BoxDecoration(color: Colors.grey.shade300),);
                  //   },
                  // ),
                ),
              )
            // decoration: BoxDecoration(
            //   // color: Colors.red,
            //
            // ),
          )
              :
          CustomVideoMultiPlayerList(
            videoUrl: widget.skibblePost.postContentList!.first.mediaUrl,
            image: widget.skibblePost.postContentList!.first.videoThumbnailUrl ,
          ),
        )
            :
        SizedBox(
          height: widget.isOnCommentPage ? size.height /1.7 : 430,
          width: size.width,
          child: Swiper(
            loop: false,

            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 300,
                width: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                // decoration: BoxDecoration(
                //   // color: Colors.red,
                //   borderRadius: BorderRadius.circular(15),
                //   image: widget.skibblePost.postContentList![index]!['type'] == 'image' ? DecorationImage(
                //       image: CachedNetworkImageProvider(widget.skibblePost.postContentList![index]!['content']),
                //       fit: BoxFit.cover
                //   ) : null,
                // ),
                child: widget.skibblePost.postContentList![index].fileType == SkibbleFileType.image ?
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ZoomOverlay(
                    minScale: 0.5, // Optional
                    maxScale: 3.0, // Optional
                    twoTouchOnly: true,
                    child: CustomNetworkImageWidget(
                      imageUrl:  widget.skibblePost.postContentList![index].mediaUrl!,
                      isCircleShaped: false,
                    )
                    // ExtendedImage.network(
                    //   widget.skibblePost.postContentList![index]!['content'],                          // width: 25,
                    //   // height: 400,
                    //   fit: BoxFit.cover,
                    //   cache: true,
                    //   // shape: BoxShape.circle,
                    //   loadStateChanged: (ExtendedImageState state) {
                    //     switch (state.extendedImageLoadState) {
                    //       case LoadState.loading:
                    //       // _controller.reset();
                    //         return Container(decoration: BoxDecoration(color: Colors.grey.shade300),);
                    //
                    //     ///if you don't want override completed widget
                    //     ///please return null or state.completedWidget
                    //     //return null;
                    //     //return state.completedWidget;
                    //       case LoadState.completed:
                    //       // _controller.forward();
                    //         return state.completedWidget;
                    //       case LoadState.failed:
                    //       // _controller.reset();
                    //         return GestureDetector(
                    //           child: Center(
                    //             child: Text(
                    //               "Image loading failed, click to reload",
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ),
                    //           onTap: () {
                    //             state.reLoadImage();
                    //           },
                    //         );
                    //
                    //     }
                    //   },
                    //   // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    //   //cancelToken: cancellationToken,
                    // )

                    // CachedNetworkImage(
                    //   imageUrl: widget.skibblePost.postContentList![index]!['content'],
                    //   fit: BoxFit.cover,
                    //   // memCacheHeight: (Get.width * 0.6).toInt(),
                    //   // memCacheWidth: (Get.width * 0.6).toInt()  ,
                    //   placeholder: (context, s) {
                    //     return Container(decoration: BoxDecoration(color: Colors.grey.shade300),);
                    //   },
                    // ),
                  ),
                )
                    :
                // CustomChewieVideoPlayer(
                //   urlType: 'network',
                //   size: size,
                //   videoUrl: widget.skibblePost.postContentList![index]!['content'],
                //   // canBuildVideo: widget.canBuildVideo,
                //   isFullScreen: false,
                // ),
                CustomVideoMultiPlayerList(
                  videoUrl: widget.skibblePost.postContentList![index].mediaUrl,
                  image: widget.skibblePost.postContentList![index].videoThumbnailUrl,
                ),
              );
            },
            itemCount: widget.skibblePost.postContentList!.length,
            viewportFraction: 1.0,
            scale: 0.9,
            outer: true,
            // layout: SwiperLayout.STACK,
            pagination: SwiperPagination(
                margin: new EdgeInsets.only(top: 10),
                builder: DotSwiperPaginationBuilder(
                    activeColor: kPrimaryColor,
                    color: Colors.grey.shade300,
                    activeSize: 8,
                    size: 4
                )
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<LikedSkibsStream>(
                    builder: (context, data, child) {
                      return LikeButton(
                          isLiked: data.getIds().contains(widget.skibblePost.postId),
                          animationDuration: const Duration(milliseconds: 800),
                          likeBuilder: (value) {
                            return !value ? const Icon(Iconsax.heart, size: 28,) : const Icon(Iconsax.heart5, color: kErrorColor, size: 28,);
                          },
                          onTap: onLikeButtonTapped
                      );
                    }
                  ),
                ),
                // IconButton(
                //     onPressed: widget.onLikePost,
                //     splashRadius: 20,
                //     icon: widget.skibblePost.likesList!.contains(currentUser.userId) ?
                //     Icon(
                //       Iconsax.heart5,
                //       color: kErrorColor,
                //       size: 30,
                //     )
                //         :
                //     Icon(Iconsax.heart, size: 30)
                // ) ,

                IconButton(
                    onPressed: () async{
                      showModalBottomSheet(
                        // enableDrag: false,
                        // isDismissible: false,
                        isScrollControlled: true,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                        // ),
                        context: context,
                        builder: (context) => SkibsCommentsView(post: widget.skibblePost,),
                      );
                    },
                    splashRadius: 20,
                    icon: const Icon(
                      Iconsax.message,
                      size: 28,
                    )
                ),


                ShareContentButton(
                  shareModel: ShareModel(
                    header: 'Share your food experience',
                    subHeader: 'Let your friends know about this your mouth-watering food',
                    contentId: widget.skibblePost.postId!,
                    previewContent: widget.skibblePost.caption,
                    shareType: ShareType.skib,
                    contentTitle: 'Skib by ${widget.skibAuthor!.fullName}',
                    imageUrl: widget.skibblePost.postContentList![0].fileType == SkibbleFileType.image ? widget.skibblePost.postContentList![0].mediaUrl  : widget.skibblePost.postContentList![0].videoThumbnailUrl,
                    authorName: widget.skibAuthor!.fullName,
                  ),
                ),

              ],
            ),

            widget.skibblePost.attachedRecipeId != null ?  Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 8),
              child: ElevatedButton(
                onPressed: (){
                  //TODO: navigate to recipe screen
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeDisplay(recipe: Recipe(title: '', recipeId: widget.skibblePost.attachedRecipeId, creatorUser: SkibbleUser()))));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kContentColorLightTheme,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: kDarkSecondaryColor)
                    )
                ),
                child: const Row(
                  children: [
                    Icon(Iconsax.book_1, color: kDarkSecondaryColor,),
                    SizedBox(width: 5,),
                    Text('Recipe', style: TextStyle(color: kDarkSecondaryColor),)
                  ],
                ),

              ),
            ) : Container()
          ],
        ),


       FeedCardLikeView(skibblePost: widget.skibblePost),
        Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 0),
            child:  ExpandableText(
              widget.skibblePost.caption,
              expandText: 'show more',
              collapseText: 'show less',
              maxLines: 3,

              linkColor: kPrimaryColor,
              animation: true,
              collapseOnTextTap: true,
              style: TextStyle(fontSize: 15, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
              prefixText: '${widget.skibAuthor!.userName == null ? '' : widget.skibAuthor!.userName}',
              // onPrefixTap: () => showProfile(username),
              prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
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
            )

          // CustomReadMoreText(
          //   widget.skibblePost.caption,
          //   trimLines: 3,
          //   preData: '@${widget.skibAuthor!.userName == null ? '' : widget.skibAuthor!.userName}  ',
          //   colorClickableText: kPrimaryColor,
          //   trimMode: CustomTrimMode.Line,
          //   style: TextStyle(
          //       fontFamily: 'Brand Regular' ),
          //   trimCollapsedText: 'show more',
          //   trimExpandedText: 'show less',
          //   moreStyle: TextStyle(fontSize: 16, color: Colors.grey),
          //   lessStyle: TextStyle(fontSize: 16, color: Colors.grey),
          //
          // ),
        ),

        widget.isOnCommentPage ?
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            runSpacing: 0,
            // maxLines: 1,
            // overflowWidget: _expandButton(),
            spacing: 5,
            children: List.generate(
                widget.skibblePost.postTags!.length, (index) => Chip(
              backgroundColor: kPrimaryColor,
              label: Text(
                '#${widget.skibblePost.postTags![index]}',
              ),
              // labelPadding: EdgeInsets.all(2),
              labelStyle: const TextStyle(color: kLightSecondaryColor),
            )
            ),
          ),
        )
            :
        (widget.skibblePost.postTags ?? []).isNotEmpty ?
        SizedBox(
          height: 50,

          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
                itemCount: widget.skibblePost.postTags!.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      visualDensity: const VisualDensity(horizontal: 0.0, vertical: -4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: kDarkColor)
                      ),
                      backgroundColor: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
                      label: Text(
                        '${context.read<FoodOptionsPickerData>().getTagEmoji(widget.skibblePost.postTags![index].toString().toLowerCase())} ${widget.skibblePost.postTags![index]}',
                      ),
                      // labelPadding: EdgeInsets.all(2),
                      labelStyle: TextStyle(
                        fontSize: 14,
                          color: kDarkColor),
                    ),
                  );
                }
            ),
          ),
        )
            :
        Container(),

        if(widget.skibblePost.recentComments != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.skibblePost.recentComments!.length > 2 ? 2 : widget.skibblePost.recentComments!.length, (index) {
              var comment = widget.skibblePost.recentComments!.values.toList()[index];
              return Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10, top: 4),
                  child:  ExpandableText(
                    comment.content!,
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 3,
                    linkColor: kPrimaryColor,
                    animation: true,
                    collapseOnTextTap: true,
                    style: TextStyle(fontSize: 13, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
                    prefixText: '${comment.messageFrom == null ? 'Anonymous' : comment.messageFrom!.userName}',
                    // onPrefixTap: () => showProfile(username),
                    prefixStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
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
                  )

                // CustomReadMoreText(
                //   widget.skibblePost.caption,
                //   trimLines: 3,
                //   preData: '@${widget.skibAuthor!.userName == null ? '' : widget.skibAuthor!.userName}  ',
                //   colorClickableText: kPrimaryColor,
                //   trimMode: CustomTrimMode.Line,
                //   style: TextStyle(
                //       fontFamily: 'Brand Regular' ),
                //   trimCollapsedText: 'show more',
                //   trimExpandedText: 'show less',
                //   moreStyle: TextStyle(fontSize: 16, color: Colors.grey),
                //   lessStyle: TextStyle(fontSize: 16, color: Colors.grey),
                //
                // ),
              );
            }),
          ),

        if(widget.skibblePost.totalComments > 1)
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  // enableDrag: false,
                  // isDismissible: false,
                  isScrollControlled: true,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  // ),
                  context: context,
                  builder: (context) => SkibsCommentsView(post: widget.skibblePost,),
                );
              },
              child: Text('View all ${widget.skibblePost.totalComments} comments', style: const TextStyle(color: Colors.blueGrey),)),
          ),

        // !widget.isOnCommentPage ? Container(
        //   margin: const EdgeInsets.only(left: 5, top: 5, bottom: 4),
        //   child: InkWell(
        //     onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewPostScreen(post: widget.skibblePost, skibAuthor: widget.skibAuthor, isFromFeedScreen: true,))),
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 5, top: 8.0, bottom: 8.0, right: 8.0),
        //       child: Text('View all comments', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
        //     ),
        //   ),
        // ) : Container(),

        Padding(
          padding: !widget.isOnCommentPage ? const EdgeInsets.only(left: 12.0, bottom: 10, top: 10) : const EdgeInsets.only(left: 10, top: 8.0, bottom: 12.0, right: 8.0),
          child: Text(
            HelperMethods().formatFeedTimeStamp(widget.skibblePost.timePosted!),
            // HelperMethods().getTimeFromTimeStamp(widget.skibblePost.timePosted!),
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 12
            ),),
        ),
      ],
    );
  }

  Route _createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}


class FeedCardLikeView extends StatefulWidget {
  const FeedCardLikeView({Key? key, required this.skibblePost}) : super(key: key);
  final SkibblePost skibblePost;

  @override
  State<FeedCardLikeView> createState() => _FeedCardLikeViewState();
}

class _FeedCardLikeViewState extends State<FeedCardLikeView> {

  //Used to track the number of likes in a post
  late final Stream<List<SkibbleUser>> likesStream;

  @override
  void initState() {
    // _streamController = StreamController<SkibblePost?>();

    //Used to track the number of likes in a post
    likesStream = FeedDatabaseService().streamLikesFromPost(widget.skibblePost.postId!);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<AppData>().skibbleUser!;
    return StreamBuilder<List<SkibbleUser>>(
        stream: likesStream,
        initialData: [],
        builder: (context, snapshot) {
          // num updatedTotalLikes = 0;
          if(snapshot.hasData) {
            List<SkibbleUser>? updatedLikes = snapshot.data;
            // print(updatedTotalLikes);
            return updatedLikes!.isNotEmpty ? GestureDetector(
              onTap: () async{
                // widget.skibblePost.totalLikes =
                context.read<SkibsData>().currentSkibLikesBeingViewed = widget.skibblePost;
                showModalBottomSheet(
                  // enableDrag: false,
                  // isDismissible: false,
                  isScrollControlled: true,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                  // ),
                  context: context,
                  builder: (context) {
                    return SkibsLikesView(
                      // post: widget.skibblePost,
                      collectionRef: FirebaseCollectionReferences.postsCollection.doc(widget.skibblePost.postId).collection(FirebaseCollectionReferences.likesDataSubCollection),
                    );

                  },
                );
                // Navigator.of(context).push(_createRoute(SkibsLikesView(post: widget.skibblePost,)));
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     fullscreenDialog: true,
                //     builder: (context) {
                //       return SkibsLikesView(post: widget.skibblePost,);
                //     },
                //   ),
                // );
                // Navigator.push(
                //   context, SlideBottomRoute(
                //     widget: SkibsLikesView(post: widget.skibblePost,)
                // ),
                // );
              },
              child:

              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                child: Row(
                  children: [
                    Row(
                      children: [

                        ImageStack.widgets(
                          totalCount: updatedLikes.sublist(0, updatedLikes.length > 2 ? 2: updatedLikes.length).length,
                          extraCountTextStyle: TextStyle(fontSize: 10, fontWeight:  FontWeight.w600),
                          children: updatedLikes.sublist(0, updatedLikes.length > 2 ? 2: updatedLikes.length).map((user) => UserImage(width: 24, height: 24, user: user, showStoryWidget: false,)).toList(),
                          widgetBorderColor: kLightSecondaryColor,
                          extraCountBorderColor: kGreyColor,
                          showTotalCount: false,
                          widgetCount: 3,
                          widgetRadius: 28,
                        ),

                        // FacePile(
                        //   users: updatedLikes.sublist(0, updatedLikes.length > 2 ? 2: updatedLikes.length),
                        //   radius: 10,
                        //   space: 12,
                        //   border: Border.all(color: kDarkSecondaryColor, ),
                        //
                        // ),
                        const SizedBox(width: 5,),
                      ],
                    ),

                    RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(text: '${updatedLikes[0].userId == currentUser.userId ? 'You' : updatedLikes[0].userName}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor
                                ),
                              ),

                              TextSpan(
                                text: updatedLikes.length - 1 > 1 ?
                                ' and ${NumberDisplay(decimal: 0).displayDelivery(updatedLikes.length - 1)} others liked this'
                                    :
                                updatedLikes.length - 1 == 1 ? ' and ${NumberDisplay(decimal: 0).displayDelivery(updatedLikes.length - 1)} other liked this' : ' liked this',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor
                                ),
                              ),
                              // TextSpan(
                              //   text: updatedLikes.length > 1 ?
                              //   tr.likes.toLowerCase() : tr.like.toLowerCase(),
                              //   style: TextStyle(fontWeight: FontWeight.bold,
                              //       fontSize: 13,
                              //       color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor
                              //   ),
                              // ),

                            ]
                        )),
                  ],
                ),
              ),
            ) : Container();
          }
          else {
            return Container();
          }

        }
    );
  }
}

