
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skibble_accessibility/features/authentication/views/shared_screens/welcome_page.dart';

import '../../../../localization/app_translation.dart';

import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../utils/size_config.dart';
import '../../../main_page_parent.dart';
import '../../../models/skibble_user.dart';
import '../../../splash_screen.dart';
import '../controllers/auth_provider.dart';
import 'auth_flow_scaffold.dart';


/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Note: this class used to be called [LandingPage].
class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key,
    // required this.user,
    required this.userSnapshot
  }) : super(key: key);
  // final SkibbleUser? user;
  final AsyncSnapshot<SkibbleUser?> userSnapshot;

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.userSnapshot.connectionState == ConnectionState.active) {
      var user = widget.userSnapshot.data;
      if(user != null) {
        context.read<SkibbleAuthProvider>().initAuthFlow(context, user);

      }
    }

    }
  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<AppData>(context).skibbleUser;
    SizeConfig().init(context);
    // Globals.init();
    AppTranslations.init(context);


    if(widget.userSnapshot.connectionState == ConnectionState.active) {
      return Consumer<SkibbleAuthProvider>(
        builder: (context, data, child) {
          var user = widget.userSnapshot.data;


          if(user == null) {
            return WelcomePage();
          }

          else {
            if(data.currentPage != -1 )
              return AuthFlowScaffold();

            else {
              return MainPageParent(tab: 'feed');
            }
          }
        }
      );

    }
    else {
      return const LoadingPage();

    }

    // if(userSnapshot.hasData) {
    //   var user = userSnapshot.data;
    //
    //   if(user!.isEmailVerified!) {
    //
    //     ///Accounts that are chefs should be routed here
    //    if(user.accountType == AccountType.chef ) {
    //      if(user.chef!.kitchenName == null || user.chef!.serviceLocation == null) {
    //
    //        // print(user.chef!.serviceLocation);
    //
    //        // WidgetsBinding.instance.addPostFrameCallback((_) => loadChef(context));
    //        return ChefRegisterPage();
    //      }
    //      else {
    //        return MainPageParent(tab: 'feed',);
    //      }
    //    }
    //
    //    else if(user.accountType == AccountType.kitchen) {
    //      if(user.kitchen!.kitchenName == null || user.kitchen!.serviceLocation == null) {
    //
    //        // print(user.chef!.serviceLocation);
    //
    //        // WidgetsBinding.instance.addPostFrameCallback((_) => loadChef(context));
    //        return UserKitchenRegisterPage();
    //      }
    //      else {
    //        return MainPageParent(tab: 'feed',);
    //      }
    //    }
    //
    //    else {
    //      if(user.userName != null) {
    //        if(user.contentPreferences!.isNotEmpty) {
    //          if(!user.isLocationServicesEnabled) {
    //            return const LocationPermissionView();
    //          }
    //
    //          if(!user.isNotificationPermissionEnabled) {
    //            return const NotificationsPermissionView();
    //          }
    //          CustomAwesomeNotifications().startNotifications(user, context);
    //
    //
    //          return MainPageParent(tab: 'feed',);
    //        }
    //        else {
    //          return UserFoodPreferencesView(user: user,);
    //        }
    //      }
    //      else {
    //        return SetFullNameUserNameView(currentUser: user);
    //      }
    //    }
    //
    //   }
    //   else {
    //     return VerifyUserEmailView(currentUser: user,);
    //   }
    // }
    //
    // else {
    //   // return ChefAccountDetails();
    //   // return ChefKitchenDetailsView();
    //
    //   // return ChefQualificationsDetailsView();
    //   // return UserAuthPage();
    //   return const WelcomePage();
    //
    // }
  }
}