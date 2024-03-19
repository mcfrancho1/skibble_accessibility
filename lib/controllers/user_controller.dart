import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/stream_models/followings_stream.dart';
import 'package:skibble/models/stream_models/users_i_blocked_stream.dart';

import '../features/notifications/models/notification_enums.dart';
import '../models/notification_model/notification.dart';
import '../models/skibble_user.dart';
import '../services/change_data_notifiers/app_data.dart';
import '../services/firebase/database/friend_requests_database.dart';
import '../services/firebase/database/user_database.dart';
import '../services/firebase/skibble_functions_handler.dart';
import '../shared/dialogs.dart';

class UserController {

  Future<bool> handleFollowLogic(SkibbleUser currentUser, SkibbleUser receiver, context, {bool isDeletingUser = false}) async{
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    var followings = Provider.of<FollowingsStream>(context,listen: false).getIds();

    CustomNotification notification = CustomNotification(
      idFrom: currentUser.userId,
      idTo: receiver.userId,
      timeStamp: timeStamp,
      notificationType: NotificationType.followRequest,
    );

      if(followings.contains(receiver.userId)) {
        receiver.totalFollowers = receiver.totalFollowers! - 1;

        Provider.of<AppData>(context,listen: false).removeFromUserFollowing(receiver.userId!);
        return await FriendRequestsDatabaseService().unFollowUser(currentUser, receiver);

      }
      else {
        receiver.totalFollowers = receiver.totalFollowers! + 1;
        Provider.of<AppData>(context,listen: false).addToUserFollowing(receiver.userId!);

        return await FriendRequestsDatabaseService().followUser(currentUser, receiver, notification);

      }
  }


  Future<void> deleteUserFromFollowingsFollowers(SkibbleUser user, String deletedUserId, context) async {
    try {

      await FriendRequestsDatabaseService().deleteUserFromFollowersFollowing(user, deletedUserId, context);

    }
    catch(e) {

    }
  }

  Future<bool> handleBlockUserLogic(SkibbleUser currentUser, SkibbleUser receiver, context) async{

   try {
     var usersIBlockedIdList = Provider.of<UsersIBlockedStream>(context, listen: false).getIds();
     if(usersIBlockedIdList.contains(receiver.userId)) {
       // CustomDialog(context).showProgressDialog('Unblocking this user');

       var result = await UserDatabaseService().unBlockUser(currentUser, receiver, context);


       if(result) {
         // Navigator.pop(context);
         Provider.of<AppData>(context, listen: false).unBlockUser(receiver.userId!);
         CustomDialog(context).showCustomMessage('Success', '${receiver.fullName} has been unblocked.');

       }
       else {
         // Navigator.pop(context);
         CustomDialog(context).showErrorDialog('Error', 'Unable to unblock this user');
       }
     }
     else {
       // CustomDialog(context).showProgressDialog('Blocking friend');

       var result = await UserDatabaseService().blockUser(currentUser, receiver, context).then((value) async{

         //don't await this call
         // SkibbleFirebaseFunctions().callFunction('onUnFollowUser', data: {'removedUser': receiver.userId});

         return value;
       });

      

       if(result) {
         // Navigator.pop(context);
         Provider.of<AppData>(context, listen: false).blockUser(receiver.userId!);
         CustomDialog(context).showCustomMessage('Success', '${receiver.fullName} has been blocked.');

       }
       else {
         // Navigator.pop(context);
         CustomDialog(context).showErrorDialog('Error', 'Unable to block this user');
       }
     }

     return true;
   }
   catch(e) { return false;}
  }
}