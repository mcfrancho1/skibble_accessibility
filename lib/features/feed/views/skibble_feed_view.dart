import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/features/feed/controllers/skibble_feed_controller.dart';
import 'package:skibble/features/feed/models/feed_component.dart';

import '../../../models/feed_post.dart';
import '../../../shared/loading_spinner.dart';
import '../../home/friend_suggestions_view.dart';
import '../../skibs/components/skib_card.dart';


class SkibbleFeedView extends StatefulWidget {
  const SkibbleFeedView({super.key, required this.feedComponents});

  final List<FeedComponent> feedComponents;

  @override
  State<SkibbleFeedView> createState() => _SkibbleFeedViewState();
}

class _SkibbleFeedViewState extends State<SkibbleFeedView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
    context.read<SkibbleFeedController>().initFeedController(widget.feedComponents, context, currentUser.userId!);

  }
  @override
  Widget build(BuildContext context) {
    //TODO:Add the refresh indicator
    return Consumer<SkibbleFeedController>(
      builder: (context, data, child) {
        return RefreshIndicator(
          onRefresh: () async{
            // await FeedDatabaseService().getUsersMoments(followingsIdList, context, currentUser);
            return Future.sync(() {
              return data.refreshController();
            });
          },
          child: CustomScrollView(
            key: _scaffoldKey,
            controller: data.feedPageScrollController,
            slivers: <Widget>[
              // SliverToBoxAdapter(
              //   child: MomentsPage(),
              // ),
              PagedSliverList<int, FeedPostGroup>(
                pagingController: data.pagingController,
                builderDelegate: PagedChildBuilderDelegate<FeedPostGroup>(
                    firstPageProgressIndicatorBuilder: (context) {
                      return const Center(
                          child: SizedBox(
                              width: 80,
                              height: 80,
                              child: LoadingSpinner(size: 30,)
                          )
                      );
                    },
                    itemBuilder: (context, item, index) {
                      switch(item.feedPostType) {
                        case FeedPostType.skib:
                        // print(item.timeCreated);
                          return Column(
                            children: List.generate(item.feedPostList!.length, (postIndex) => SkibblePostCard(
                              // key: UniqueKey(),
                                skibblePostId: item.feedPostList![postIndex].feedPostId,
                                skibblePost: item.feedPostList![postIndex].post!,
                                parentContext: _scaffoldKey.currentContext!,
                                //     postAuthorId: '', caption: ''),
                                // skibblePostAuthor: widget.feedPostList[index].post!.creatorUser!,
                                isFromFeedScreen: true
                            ),),
                          );
                        case FeedPostType.recipe:
                        // TODO: Handle this case.
                          return Container();
                      // return RecipeCard(
                      //     key: UniqueKey(),
                      //     recipe: feedPosts[index].recipe!);
                        case FeedPostType.ad:
                        // TODO: Handle this case.
                          return Container();
                        case FeedPostType.unknown:
                        // TODO: Handle this case.
                          return Container();
                        case FeedPostType.friendRecommendationsInterest:
                        // TODO: Handle this case.
                          return FriendSuggestionsView(friendSuggestions:  item.feedPostList?.map((e) => e.user!).toList() ?? [],);
                        case FeedPostType.friendRecommendationsLocation:
                        // TODO: Handle this case.
                          return Container();
                          //   FriendSuggestionsView(
                          //   friendSuggestions: item.feedPostList?.map((e) => e.user!).toList() ?? [],
                          // );
                        case FeedPostType.community:
                        // TODO: Handle this case.
                          return Container();
                          break;
                        case FeedPostType.chef:
                        // TODO: Handle this case.
                          return Container();
                          break;
                        case FeedPostType.kitchens:
                        // TODO: Handle this case.
                          return Container();
                          break;
                        case FeedPostType.spot:
                        // TODO: Handle this case.
                          return Container();
                          break;
                      }
                    }
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80,),)
            ],
          ),
        );
      }
    );

  }
}



class VerticalFeedView extends StatelessWidget {
  const VerticalFeedView({super.key, required this.child, required this.feedList});

  final Widget child;
  final List<FeedPost> feedList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (context, index) {
          return child;
    }));
  }
}

