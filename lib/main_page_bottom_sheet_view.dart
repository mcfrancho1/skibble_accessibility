
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cu;
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble_accessibility/services/change_data_notifiers/app_data.dart';

import 'package:skibble_accessibility/shared/bottom_sheet_dialogs.dart';
import 'package:skibble_accessibility/utils/constants.dart';
import 'package:skibble_accessibility/utils/current_theme.dart';

import 'features/meets/controllers/create_edit_meets_controller.dart';
import 'features/meets/utils/meets_bottom_sheets.dart';

class MainPageBottomView extends StatefulWidget {
  const MainPageBottomView({Key? key, }) : super(key: key);

  @override
  State<MainPageBottomView> createState() => _MainPageBottomViewState();
}

class _MainPageBottomViewState extends State<MainPageBottomView> {
  late NavigatorState _navigator;


  @override
  void dispose() {
    // _provider.dispose();
    // _instaAssetsPicker.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AppData>(context).skibbleUser!;
    return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 90,
              margin: EdgeInsets.only(top: 8),
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 5),
              child: Text('Create',
                style: TextStyle(
                  color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),


            ListView(
            shrinkWrap: true,
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // separatorBuilder: (BuildContext context, int index) {  },
            // itemCount: 5,
            // itemBuilder: (BuildContext context, int index) {  },
            children: ListTile.divideTiles(
                context: context,
                color: Colors.grey.shade400,
                tiles: [
                  ListTile(
                    contentPadding:  EdgeInsets.only(top: 20.0, left: 20.0, right: 20, bottom: 5),
                    leading: Icon(
                        Iconsax.reserve,
                      color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                    ),
                    title: Transform.translate(
                      offset: Offset(-16, 0),
                        child: Text('Skib')),
                    onTap: () async{
                      Navigator.pop(context);
                      // CustomPickers().showSkibCreatorSheet(context);


                      ///
                      // await callPicker();


                      // var res = await FilesHandler().createSkib(context, _navigator);
                    },
                  ),
                  ListTile(
                    contentPadding:  EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                    leading: Icon(cu.CupertinoIcons.flame,
                      color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                    ),
                    title: Transform.translate(
                        offset: Offset(-16, 0),

                        child: Text('Meet')),
                    trailing: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: kPrimaryColor
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text('NEW', style: TextStyle(color: kContentColorLightTheme, fontSize: 13),),
                      ),
                    ),
                    onTap: () async{
                      CustomBottomSheetDialog.showProgressSheet(context);

                      var meet = await context.read<CreateEditMeetsController>().getDraftMeet();

                      if(meet != null) {
                        var res = await context.read<CreateEditMeetsController>().initRemixMeet(context, meet);
                      }
                      else {
                        context.read<CreateEditMeetsController>().initCreateMeet(_navigator.context);
                      }


                      Navigator.pop(context);
                      MeetsBottomSheets().showCreateMeetSheet(_navigator.context);

                      // MeetsBottomSheets().showCreateMeetSheet(_navigator.context);

                    },
                  ),
                  // ListTile(
                  //   contentPadding:  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  //
                  //   leading: CircleAvatar(
                  //       backgroundColor: Colors.orange.shade300,
                  //       child: Icon(Iconsax.video, color: kLightSecondaryColor,)),
                  //   title: Text('Go Live'),
                  //   onTap: () async{
                  //     Navigator.pop(context);
                  //     //TODO: Open another bottom sheet for users to enter the name of their live stream
                  //     // LiveStreamController().startLiveStream(user, 'Test', context);
                  //
                  //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  //     //     VideoFilePickerView(
                  //     //       fileType: FileType.video,
                  //     //       skibbleFriend: skibbleFriend,
                  //     //       conversationId: conversationId,
                  //     //       swipedMessage: swipedMessage,
                  //     //       onCancelReply: onCancelReply,
                  //     //     )));
                  //
                  //   },
                  // ),

                  ListTile(
                    contentPadding:  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),

                    leading: Icon(Iconsax.book_1,
                      color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                    ),
                    title: Transform.translate(
                        offset: const Offset(-16, 0),
                        child: const Text('Recipe')),
                    onTap: () {
                      Navigator.pop(context);
                    },

                  ),

                  ListTile(
                    contentPadding:  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                    leading: Icon(Iconsax.people,
                      color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                    ),
                    title: Transform.translate(
                        offset: const Offset(-16, 0),
                        child: const Text('Community')),
                    onTap: ()async {
                      Navigator.pop(context);

                    },
                  ),

                ]).toList()
          )],
        )
    );
  }

  Future<bool>? onBackPress() async{
    return true;
  }


}




class NewPostView extends StatelessWidget {
  const NewPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
