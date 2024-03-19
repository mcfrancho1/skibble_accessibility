import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/constants.dart';
import '../controllers/auth_provider.dart';



class AuthFlowScaffold extends StatelessWidget {
  const AuthFlowScaffold({Key? key}) : super(key: key);

  // final List<Widget> pages = const [
  //
  //   CreateUpdateCommunityPrivacyView(),
  //   CreateUpdateCommunityNameView(),
  //   CreateUpdateCommunityDescriptionView(),
  //   CreateUpdateCommunityRulesView(),
  //   CreateUpdateCommunityPhotoView(),
  //   CreateUpdateCommunityFoodTagsView(),
  //   CommunityCreationCompleteMessageView()
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer<SkibbleAuthProvider>(
        builder: (context, data, child) {

          var pages = data.authFlowFunctions!.keys.toList();
          var functions = data.authFlowFunctions!.values.toList();
          return Scaffold(
            // appBar: AppBar(
            //
            //     centerTitle: true,
            //     elevation: 0,
            //     leadingWidth: 35,
            //     title: ClipRRect(
            //       borderRadius: BorderRadius.all(Radius.circular(10)),
            //       child: LinearProgressIndicator(
            //         backgroundColor: Colors.grey.shade200,
            //         value: data.currentPage + 1 / (pages.length - 1),
            //         color: kPrimaryColor,
            //       ),
            //     )
            //
            //   // Te,xt('Create a meet', style: TextStyle(fontWeight: FontWeight.bold,color: kDarkSecondaryColor)),
            // ),

            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 10,),
                (data.authFlowFunctions??{}).isNotEmpty ? Expanded(
                    child: pages[data.currentPage]) : Container(),

              ],
            ),
          );
        }
    );
  }
}


