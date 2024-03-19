import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/custom_search_controller.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/shared/user_image.dart';
import 'package:skibble/features/chats/all_search_view.dart';
import 'package:skibble/features/meets/controllers/meets_privacy_controller.dart';
import 'package:skibble/features/profile/user_profile.dart';
import 'package:skibble/utils/constants.dart';

import '../../../../models/skibble_user.dart';
import '../../../../utils/current_theme.dart';
import '../../../profile/current_user_profile_page.dart';

class PrivateMeetChooserView extends StatefulWidget {
  const PrivateMeetChooserView({Key? key}) : super(key: key);

  @override
  State<PrivateMeetChooserView> createState() => _PrivateMeetChooserViewState();
}

class _PrivateMeetChooserViewState extends State<PrivateMeetChooserView> {
 final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // var friendsList = Provider.of<AppData>(context).friendsList;
    // var friendRequestList = Provider.of<AppData>(context).friendRequestList;

    var currentUser = Provider.of<AppData>(context).skibbleUser!;

    return Consumer2<CustomSearchController, MeetsPrivacyController>(
      builder: (context, data, privacyData, child) {
        List<SkibbleUser> skibbleUsersList = data.userSearchResults;
        List<SkibbleUser> selectedUsersList = privacyData.selectedPrivateUsers;


        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 2/3,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Choose your members', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                  const SizedBox(height: 20,),
                  Container(
                    height: 40,
                    // padding: EdgeInsets.all(10),

                    child: TextField(
                      onChanged: (value) => context.read<CustomSearchController>().onSearch(value, currentUser.userId!),
                      controller: controller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400,),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none
                          ),
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade400
                          ),
                          hintText: "Search to add members..."
                      ),
                    ),
                  ),

                  SizedBox(
                    height: selectedUsersList.isEmpty ? 0: 70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: selectedUsersList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {

                                SkibbleUser selectedUser = selectedUsersList[index];

                                // bool _isFound = false;
                                // var foundUser = selectedUsersList.firstWhere((element) => element.userId == selectedUser.userId, orElse: () => SkibbleUser());
                                //
                                // if(foundUser.userId != null) {
                                //   _isFound = true;
                                // }


                                return Container(
                                  width: 170,
                                  padding: const EdgeInsets.only(top: 4, bottom: 4, left: 10, right:  10),
                                  margin: const EdgeInsets.only(right: 10,),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: kPrimaryColor),
                                    color: kLightSecondaryColor
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            UserImage(width: 25, height: 25, user: selectedUser,),
                                            const SizedBox(width: 5,),
                                            SizedBox(width: 80, child: Text(selectedUser.fullName!, maxLines: 1, overflow: TextOverflow.ellipsis,),),
                                          ],
                                        ),
                                      ),

                                      GestureDetector(
                                        child: const Icon(Icons.cancel_rounded, color: kPrimaryColor,),
                                        onTap: () {
                                          // if(_isFound) {
                                            privacyData.removePrivateUserFromList(selectedUser);
                                          // }
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }),
                          ),

                          const Divider(),
                        ],
                      ),
                    )
                  ),


                  Flexible(
                      child: skibbleUsersList.length > 0 ?
                      ListView.builder(
                          itemCount: skibbleUsersList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            bool _isFound = false;
                            var foundUser = selectedUsersList.firstWhere((element) => element.userId == skibbleUsersList[index].userId, orElse: () => SkibbleUser());

                            if(foundUser.userId != null) {
                              _isFound = true;
                            }

                            return InkWell(
                              onTap: () {
                                if(!_isFound) {
                                  if(currentUser.userId != skibbleUsersList[index].userId) {
                                    privacyData.addPrivateUserToList(skibbleUsersList[index], context);
                                  }
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right:  10),
                                  margin: const EdgeInsets.only(top: 10,),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: _isFound ? kPrimaryColor: Colors.grey.shade200)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                          children: [
                                            UserImage(
                                              height: 40,
                                              width: 40,
                                              user: skibbleUsersList[index],

                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      skibbleUsersList[index].fullName!,
                                                      style: TextStyle(
                                                          color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor
                                                          , fontWeight: FontWeight.w500)),
                                                  const SizedBox(height: 5,),
                                                  Text('@${skibbleUsersList[index].userName!}', style: TextStyle(color: Colors.grey[500])),
                                                ]
                                            )
                                          ]
                                      ),

                                      if(_isFound)
                                        const Icon(Icons.check_circle_rounded, color: kPrimaryColor,)
                                    ],
                                  )),
                            );
                          })
                          : const Center(child: Text("No Results Found", style: TextStyle(color: Colors.white),))
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
