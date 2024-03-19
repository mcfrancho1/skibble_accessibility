// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:skibble/features/skibs/components/view_or_comment_post.dart';
//
// import '../../../models/combine_message_user_stream.dart';
// import '../../../models/skibble_post.dart';
// import '../../../services/firebase/database/feed_database.dart';
// import '../../../utils/constants.dart';
// import '../../../utils/current_theme.dart';
// import '../../chats/friends_display/friends_list_view.dart';
// import '../../profile/followers_followings/shared/followers_view.dart';
//
// class SkibsLikesView extends StatefulWidget {
//   const SkibsLikesView({Key? key, required this.post}) : super(key: key);
//   final SkibblePost post;
//
//   @override
//   State<SkibsLikesView> createState() => _SkibsLikesViewState();
// }
//
// class _SkibsLikesViewState extends State<SkibsLikesView> {
//
//   Future? likesFuture;
//   @override
//   void initState() {
//     likesFuture = FeedDatabaseService().getAllLikesForPost(widget.post, context);
//
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.9,
//       maxChildSize: 1,
//       minChildSize: 0.9,
//       // expand: false,
//       builder: (_, controller) {
//         return Container(
//           // width: double.infinity,
//           margin: EdgeInsets.symmetric(horizontal: 10,),
//           decoration: BoxDecoration(
//               color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme
//           ),
//           child: Column(
//             // controller: controller,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 10,),
//               Row(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: Icon(Icons.keyboard_arrow_down_rounded, size: 30,)),
//
//                   SizedBox(width: 10,),
//
//
//                   Text(
//                     'Likes',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold
//                     ),
//                   ),
//
//                 ],
//               ),
//
//               Divider(),
//
//               // SizedBox(height: 15,),
//               Expanded(
//                 child: FutureBuilder(
//                     future: likesFuture,
//                     builder: (context, snapshot) {
//                       switch(snapshot.connectionState) {
//
//                         case ConnectionState.none:
//                         case ConnectionState.waiting:
//                           return Container();
//                         case ConnectionState.active:
//                         case ConnectionState.done:
//                           if(snapshot.hasData) {
//                             Map<String,List<String>> likesMap = snapshot.data as Map<String,List<String>>;
//                             // widget.post.likesDocMap = likes;
//                             List<String> likes = [];
//                             likesMap.values.forEach((list) {likes.addAll(list.toSet()); });
//
//                             return MediaQuery.removePadding(
//                                 context   : context,
//                                 removeTop: true,
//                                 child: FriendsFollowersListView(
//                                     pageKey: '',
//                                     // scrollController: controller,
//                                     user:  widget.post.creatorUser!,
//                                     followersIDList: likes,
//                                     emptyListString: 'Nothing here',
//                                     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
//                                 ));
//                           }
//
//                           else {
//                             return Text('No data');
//                           }
//                       }
//                     }),
//               )
//
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
