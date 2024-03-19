import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../shared/no_content_view.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../../../../utils/tab_bar_flexible_tabs.dart';
import '../../../profile/followers_followings/shared/user_info_card.dart';

class InterestedInvitedMeetPals extends StatefulWidget {
  const InterestedInvitedMeetPals({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<InterestedInvitedMeetPals> createState() => _InterestedInvitedMeetPalsState();
}

class _InterestedInvitedMeetPalsState extends State<InterestedInvitedMeetPals> with TickerProviderStateMixin {

  late TabController tabController;
  late ScrollController _scrollController = ScrollController();

  Future? dataFuture;
  late final List<String> tabsContent;

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 2, vsync: this, initialIndex: widget.index);

    tabsContent = ['Interested', 'Invited'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context,
            bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context),
              sliver: SliverAppBar(
                expandedHeight: 110,
                elevation: 5,
                floating: false,
                pinned: true,
                snap: false,
                // stretch: true,
                shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                // toolbarHeight: 90,
                automaticallyImplyLeading: false,
                centerTitle: true,
                // leadingWidth: 35,
                actions: const [

                  // Opacity(
                  //   opacity: 0,
                  //   child: Icon(Icons.abc))
                ],
                // leading: BackButton(color: kDarkSecondaryColor,),
                backgroundColor: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,

                  background: Container(
                    // height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back)),
                        Center(
                          child: Text(
                            '${context.read<MeetsController>().selectedMeetForDetails!.meetTitle}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkSecondaryColor),
                          ),
                        ),
                        Opacity(opacity: 0, child: IconButton(onPressed: null, icon: Icon(Icons.abc)),)
                      ],
                    ),
                  ),
                  centerTitle: true,
                  // titlePadding: EdgeInsets.all(0),
                  // background: AppBar(),
                ),

                bottom:  PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Align(
                    alignment: Alignment.centerLeft,

                    child: TabBar(
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      controller: tabController,
                      isScrollable: false,
                      indicatorColor: kPrimaryColor,
                      tabs: const [
                        Tab(
                          text: "Interested",
                        ),

                        Tab(
                          text: "Invited",
                        ),

                      ],
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.label,

                      unselectedLabelStyle: TextStyle(fontSize: 17),
                      // add it here
                      labelColor: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      // indicator: DotIndicator(
                      //   color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                      //   distanceFromCenter: 16,
                      //   radius: 3,
                      //   paintingStyle: PaintingStyle.fill,
                      // ),
                      indicator: MaterialIndicator(
                        color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kPrimaryColor,
                        // distanceFromCenter: 16,
                        // radius: 3,
                        topLeftRadius: 20,
                        topRightRadius: 20,
                        paintingStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: const [
            InterestedMeetPals(),
            InvitedMeetPals()
          ],
        )
      ),
    );
  }
}


class InterestedMeetPals extends StatelessWidget {
  const InterestedMeetPals({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    var size = MediaQuery.of(context).size;
    return Builder(
        builder: (context) {
          return CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),

            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),

              SliverToBoxAdapter(
                child: Consumer<MeetsController>(
                  builder: (context, data, child) {
                    return data.selectedMeetForDetails!.interestedUsers!.isNotEmpty ?
                    Column(
                      children: List.generate(data.selectedMeetForDetails!.interestedUsers!.length, (index) =>
                          Row(
                            children: [
                              Expanded(
                                child: UserInfoCard(
                                  navigationString: 'profile',
                                  user: data.selectedMeetForDetails!.interestedUsers![index],
                                  margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 20),
                                ),
                              ),

                              //show the invite button if the meet creator is the current user
                              if(data.selectedMeetForDetails!.meetCreator.userId == currentUser.userId)
                                  Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ElevatedButton(
                                  onPressed: () async{
                                    await data.inviteToMeet(currentUser, data.selectedMeetForDetails!.interestedUsers![index], context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kLightSecondaryColor,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: kDarkSecondaryColor),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 6, horizontal:  20),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: Size(0, 0),
                                      elevation: 1
                                  ),
                                  child: const Text(
                                    'Invite',
                                    style: TextStyle(color: kDarkSecondaryColor),
                                  ),
                                ),
                              )


                            ],
                          )),
                    )
                        :
                     SizedBox(

                      height: size.height / 2,
                      child: const Center(child: Text('No new interests', style: TextStyle(color: Colors.grey, fontSize: 15),)));
                  }
                ),
              )

            ],
          );
        }
    );
  }
}


class InvitedMeetPals extends StatelessWidget {
  const InvitedMeetPals({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    var size = MediaQuery.of(context).size;
    return Builder(
        builder: (context) {
          return CustomScrollView(
            physics: NeverScrollableScrollPhysics(),

            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),

              SliverToBoxAdapter(
                child: Consumer<MeetsController>(
                    builder: (context, data, child) {
                      return Column(
                        children: List.generate(data.selectedMeetForDetails!.invitedUsers!.length, (index) =>
                            Row(
                              children: [
                                Expanded(
                                  child: UserInfoCard(
                                    navigationString: 'profile',
                                    user: data.selectedMeetForDetails!.invitedUsers![index],
                                    margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 20),
                                  ),
                                ),


                                //show the invite button if the meet creator is the current user
                                if(data.selectedMeetForDetails!.meetCreator.userId == currentUser.userId && data.selectedMeetForDetails!.meetCreator.userId != data.selectedMeetForDetails!.invitedUsers![index].userId)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: ElevatedButton(
                                      onPressed: () async{
                                        await data.unInviteToMeet(currentUser, data.selectedMeetForDetails!.invitedUsers![index], context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: kLightSecondaryColor,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(color: kDarkSecondaryColor),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 6, horizontal:  20),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          minimumSize: Size(0, 0),
                                          elevation: 1
                                      ),
                                      child: const Text(
                                        'Cancel invite',
                                        style: TextStyle(color: kDarkSecondaryColor),
                                      ),
                                    ),
                                  )




                              ],
                            )),
                      );
                    }
                ),
              )

            ],
          );
        }
    );
  }
}
