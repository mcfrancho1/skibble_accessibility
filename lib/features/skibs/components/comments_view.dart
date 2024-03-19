import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/loading_spinner.dart';
import 'package:skibble/features/skibs/components/view_or_comment_post.dart';

import '../../../models/chat_models/chat_message.dart';
import '../../../models/combine_message_user_stream.dart';
import '../../../models/skibble_post.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/firebase/database/feed_database.dart';
import '../../../shared/user_image.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/helper_methods.dart';

class SkibsCommentsView extends StatefulWidget {
  const SkibsCommentsView({Key? key, required this.post}) : super(key: key);
  final SkibblePost post;

  @override
  State<SkibsCommentsView> createState() => _SkibsCommentsViewState();
}

class _SkibsCommentsViewState extends State<SkibsCommentsView> {

  StreamController<List<CombineMessageUserStream>>? streamController;

  Stream<List<CombineMessageUserStream>>? commentsStream;

  TextEditingController commentsController = TextEditingController();

  bool _isTyping = false;

  @override
  void initState() {

    streamController = StreamController<List<CombineMessageUserStream>>.broadcast();
    streamController!.addStream(FeedDatabaseService().streamSkibblePostComments(widget.post.postId!)!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var currentUser = Provider.of<AppData>(context).skibbleUser!;

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 1,
        minChildSize: 0.9,

        // expand: false,
        builder: (_, controller) {
          return Container(
            // width: double.infinity,
            decoration: BoxDecoration(
                color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme
            ),
            child: Column(
              // controller: controller,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30,)),

                    const SizedBox(width: 10,),

                    const Text(
                      'Comments',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),

                const Divider(),

                // SizedBox(height: 15,),
                Expanded(
                  child: SingleChildScrollView(
                    // width: double.infinity,
                    // decoration: BoxDecoration(
                    //   color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                    // ),
                    child: StreamBuilder(
                        stream: streamController!.stream,
                        builder: (context, snapshot) {
                          switch(snapshot.connectionState) {

                            case ConnectionState.none:
                              return Container();
                            case ConnectionState.waiting:
                              return Center(child: Container(height: 70, width: 70, child: const LoadingSpinner(size: 40,),));

                            case ConnectionState.active:
                            case ConnectionState.done:
                            // TODO: Handle this case.
                              if(snapshot.hasData) {
                                List<CombineMessageUserStream> comments = snapshot.data as List<CombineMessageUserStream>;
                                return comments.isEmpty ?
                                Container(
                                  height: size.height / 2,
                                  child: const Center(
                                      child: Text('No Comments', style: TextStyle(color: Colors.grey),)),
                                )
                                    :
                                Column(
                                    children: List.generate(
                                        comments.length, (index) => SkibblePostCommentTile(
                                        index: index, comment: comments[index]))
                                );
                              }
                              else {
                                print(snapshot.error);
                                return Container(child: const Center(child: Text('No comments')),);
                              }
                          }

                        }
                    ),
                  ),
                ),

                Container(
                  height: 90.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -2),
                        blurRadius: 6.0,
                      ),
                    ],
                    color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kLightSecondaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: commentsController,
                      onChanged: (value) {

                        if(!_isTyping && value.isNotEmpty) {
                          setState(() {
                              _isTyping = true;
                          });
                        }
                        else if(_isTyping && value.isEmpty) {
                          setState(() {
                            _isTyping = false;
                          });
                        }

                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          contentPadding: const EdgeInsets.all(20.0),
                          hintText: 'Comment on this skib...',

                          prefixIcon: Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 48.0,
                            height: 48.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey,
                              //     offset: Offset(0, 2),
                              //     blurRadius: 1.0,
                              //   ),
                              // ],

                            ),
                            child: UserImage(user: currentUser, height: 48, width: 48, showStoryWidget: true, showUserColor: false,),
                          ),
                          suffixIcon: Container(
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                color: _isTyping ? kPrimaryColor : Colors.grey.shade200,
                                shape: BoxShape.circle
                            ),
                            child: InkWell(

                                onTap: () async{
                                  if(commentsController.text.isNotEmpty) {
                                    int timePosted = DateTime.now().millisecondsSinceEpoch;
                                    // SkibblePostComment comment = SkibblePostComment(
                                    //     userId: user.userId!,
                                    //     userComment: commentsController.text,
                                    //     commentId: '',
                                    //     timePosted: timePosted
                                    // );

                                    ChatMessage chatMessage = ChatMessage(
                                      idFrom: currentUser.userId!, idTo: widget.post.postId!,
                                      timestamp: timePosted,
                                      content: commentsController.text,
                                      messageType: ChatMessageType.text,
                                      messageFrom: currentUser
                                    );

                                    commentsController.clear();
                                    HelperMethods().dismissKeyboard(context);

                                    await FeedDatabaseService().commentOnPost(chatMessage, widget.post);

                                  }
                                },
                                child: _isTyping ? const Icon(
                                  Iconsax.send_2,
                                  color: Colors.white,
                                ) : const Icon(
                                  Iconsax.send_2,
                                  color: Colors.grey,
                                )
                            ),
                          )
                      ),
                    ),
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }
}
