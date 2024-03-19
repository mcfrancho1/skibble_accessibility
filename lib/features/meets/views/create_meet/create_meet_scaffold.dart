import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/loading_spinner.dart';
import 'package:skibble/features/meets/controllers/create_edit_meets_controller.dart';
import 'package:skibble/features/meets/controllers/meets_loading_controller.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';

import '../../../../utils/constants.dart';
import 'create_meet_complete.dart';
import 'meet_bills_handle_view.dart';
import 'meet_description_view.dart';
import 'meet_location_and_datetime_view.dart';
import 'meet_pick_image_view.dart';
import 'meet_title_view.dart';
import 'meet_type_view.dart';

class CreateMeetScaffold extends StatelessWidget {
  const CreateMeetScaffold({Key? key}) : super(key: key);

  final List<Widget> pages = const [
    MeetTypeView(),
    MeetTitleView(),
    MeetLocationAndDateTimeView(),
    MeetPickImageView(),
    MeetBillsHandleView(),
    MeetDescriptionView(),
    CompletedMeetsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateEditMeetsController>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () async{

                  //TODO: Show save to draft bottom sheet

                  if(data.currentPage != pages.length - 1) {
                    await MeetsBottomSheets().showMeetsSaveToDraftSheet(context);
                  }
                  else {
                    context.read<CreateEditMeetsController>().reset(context);
                    Navigator.pop(context);
                  }
                },
                splashRadius: 20,
                icon: Icon( Icons.clear, color: kDarkSecondaryColor,)),
            centerTitle: true,
            elevation: 0,
            leadingWidth: 35,
            title: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey.shade200,
                value: data.currentPage / (pages.length - 1),
                color: kPrimaryColor,
              ),
            )

            // Te,xt('Create a meet', style: TextStyle(fontWeight: FontWeight.bold,color: kDarkSecondaryColor)),
          ),

          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Expanded(
                child: pages[data.currentPage]),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: data.currentPage == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                    children: [
                      if(data.currentPage != 0 && data.currentPage != pages.length - 1)
                        GestureDetector(
                          onTap: () {
                            data.previousPage();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey.shade500,),
                          ),
                        ),

                      if(data.currentPage != pages.length - 1)
                        data.currentPage == pages.length - 2 ?
                            ElevatedButton(
                              onPressed: () async{
                                var functionValue = await data.createMeetsFunctions![data.currentPage]();

                                if(functionValue == true) {
                                  data.nextPage();
                                }
                              },
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                              child: Consumer<MeetsLoadingController>(
                                builder: (context, data, child) {
                                  return data.isLoadingThird ? LoadingSpinner(color: kDarkSecondaryColor, size: 20,) : Text(
                                    'Done',
                                    style: TextStyle(color: kDarkSecondaryColor),
                                  );
                                }
                              )
                        )
                            :
                        data.showForwardButton ? GestureDetector(
                          onTap: () async{
                            var functionValue = data.createMeetsFunctions![data.currentPage]();

                            if(functionValue == true) {
                              data.nextPage();
                            }
                          },
                          child:
                          CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            child: Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                          ),
                        ) : Container()
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}


