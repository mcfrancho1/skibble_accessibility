import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../../controllers/skib_controller.dart';
import '../../../controllers/skib_data_controller.dart';
import '../../../models/skibble_user.dart';
import '../../../services/change_data_notifiers/skibs_data.dart';
import '../../../services/change_data_notifiers/users_data.dart';
import '../../../services/firebase/database/user_database.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../profile/followers_followings/shared/user_info_card.dart';


class SkibsLikesView extends StatefulWidget {
  const SkibsLikesView({Key? key, required this.collectionRef}) : super(key: key);
  final CollectionReference collectionRef;

  @override
  State<SkibsLikesView> createState() => _SkibsLikesViewState();
}

class _SkibsLikesViewState extends State<SkibsLikesView> {
  // static const _pageSize = 20;
  // final PagingController<int, SkibbleUser> _pagingController = PagingController(firstPageKey: 0);


  @override
  void initState() {
    context.read<SkibController>().initSkibLikesPageController(widget.collectionRef, context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 1,
      minChildSize: 0.9,
      // expand: false,
      builder: (_, controller) {
        return Container(
          // width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 10,),
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
                      onTap: () {
                        // Provider.of<SkibsDataController>(context, listen: false).disposeController();

                        Navigator.pop(context);
                      },
                      child: Icon(Icons.keyboard_arrow_down_rounded, size: 30,)),

                  SizedBox(width: 10,),


                  Text(
                    'Likes',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                ],
              ),

              Divider(),

              Expanded(
                child: Consumer<SkibController>(
                  builder: (context, data, child) {

                    return PagedListView(
                      // showNewPageProgressIndicatorAsGridChild: true,
                      // showNewPageErrorIndicatorAsGridChild: false,
                      // showNoMoreItemsIndicatorAsGridChild: false,
                      shrinkWrap: true,
                      // scrollController: widget.scrollController,
                      // key: new PageStorageKey(widget.pageKey),

                      // physics: NeverScrollableScrollPhysics(),

                      pagingController: data.skibLikesPagingController,
                      builderDelegate: PagedChildBuilderDelegate<SkibbleUser>(
                        // itemCount: widget.followersList.length,
                        // shrinkWrap: true,
                          itemBuilder: (context, user , index) {
                            return UserInfoCard(
                              navigationString: 'profile',
                              user: user,
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            );
                          },

                          firstPageProgressIndicatorBuilder: (context) {
                            return Container(
                                height: 400,
                                child: Center(child: CircularProgressIndicator(strokeWidth: 2,)));
                          },

                          noItemsFoundIndicatorBuilder: (context) {
                            return Container(
                              height: 200,
                              child: Center(
                                child: Text('No Users found'),
                              ),
                            );
                          }
                      ),
                    );
                  }
                ),
              )

            ],
          ),
        );
      },
    );
  }
}
