import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skibble/utils/environment.dart';

import '../../enums/share_type.dart';

class DynamicLinks {
// 1. Pass a Ref argument to the constructor
//   DynamicLinksService(Ref ref) {
//     // 2. Call _init as soon as the object is created
//     _init();
//     this.ref = ref;
//   }
//   late final Ref ref;
//
//   void _init() {
//
//     final onDynamicLinkProvider = StreamProvider<PendingDynamicLinkData>((ref) {
//       // For simplicity, here we use FirebaseDynamicLinks directly.
//       // On production codebases we would get the stream from a DynamicLinksRepository.
//       return FirebaseDynamicLinks.instance.onLink;
//     });
//
//     // 3. listen to the StreamProvider
//     ref.listen<AsyncValue<PendingDynamicLinkData>>(onDynamicLinkProvider,
//             (previous, next) {
//           // 4. Implement the event handling code
//           final linkData = next.value;
//           if (linkData != null) {
//             debugPrint(linkData.toString());
//             // TODO: Handle linkData
//           }
//         });
//   }

  final String devPackageName = 'com.mcfranchostudios.skibble.dev';
  final String prodPackageName = 'com.mcfranchostudios.skibble';

  final String devUrlPrefix = 'https://skibble.page.link';
  final String prodUrlPrefix = 'https://skibble.app';



  // Future<String?> createDynamicLinkDev(ShareType type, String id, {String? title, String? description, String? imageUrl}) async {
  //
  //   try {
  //     var subPath = generateSubPath(type);
  //
  //     var parameters = DynamicLinkParameters(
  //       uriPrefix: '${devUrlPrefix}',
  //       link: Uri.parse('${devUrlPrefix}/$subPath?type=${type.name}&id=$id'),
  //       androidParameters: AndroidParameters(
  //         packageName: "${devPackageName}",
  //       ),
  //       //Uncomment for iOS
  //       iosParameters: IOSParameters(
  //         bundleId: "${devPackageName}",
  //         appStoreId: '1633887491',
  //       ),
  //       // navigationInfoParameters: NavigationInfoParameters(
  //       //
  //       // ),
  //
  //       socialMetaTagParameters: SocialMetaTagParameters(
  //           title: title != null ? title : null,
  //           imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
  //           description: description != null ? description : null
  //       ),
  //     );
  //
  //     var shortLink = await FirebaseDynamicLinks.instance.buildShortLink(
  //       parameters,
  //       shortLinkType: ShortDynamicLinkType.unguessable,
  //     );
  //     var shortUrl = shortLink.shortUrl;
  //
  //     return shortUrl.toString();
  //   }
  //   catch(e) {
  //     return null;
  //   }
  // }


  Future<String?> createDynamicLink(ShareType type, String id, {String? title, String? description, String? imageUrl}) async {



    try {
      var subPath = generateSubPath(type);

      var prefix = AppEnvironment.currentEnv == AppEnvironmentType.dev ? devUrlPrefix : '${prodUrlPrefix}/$subPath';
      var packageName = AppEnvironment.currentEnv == AppEnvironmentType.dev ? devPackageName : prodPackageName;
      var link = AppEnvironment.currentEnv == AppEnvironmentType.dev ?
      Uri.parse('${prefix}/$subPath?type=${type.name}&id=$id')
          :
      Uri.parse('${prefix}?type=${type.name}&id=$id');

      var parameters = DynamicLinkParameters(
        uriPrefix: prefix,
        link: link,
        androidParameters: AndroidParameters(
          packageName: packageName,
        ),
        //Uncomment for iOS
        iosParameters: IOSParameters(
          bundleId: packageName,
          appStoreId: '1633887491',
        ),
        // navigationInfoParameters: NavigationInfoParameters(
        //
        // ),



        socialMetaTagParameters: SocialMetaTagParameters(
            title: title != null ? title : null,
            imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
            description: description != null ? description : null
        ),
      );



      var shortLink = await FirebaseDynamicLinks.instance.buildShortLink(
        parameters,
        shortLinkType: ShortDynamicLinkType.unguessable,
      );
      var shortUrl = shortLink.shortUrl;

      return shortUrl.toString();
    }
    catch(e) {
      return null;
    }
  }


  String generateSubPath(ShareType type) {
    var subPath = '';
    switch(type) {


      case ShareType.chatMessage:
        subPath = 'chat_messages';
        break;
      case ShareType.communityMessage:
        subPath = 'community_messages';
        break;
      case ShareType.skib:
      case ShareType.recipe:
      case ShareType.meet:
      case ShareType.spot:
      case ShareType.chef:
      case ShareType.kitchen:
      case ShareType.user:
        subPath = '${type.name}s';
        break;
      case ShareType.community:
      // TODO: Handle this case.
        subPath = 'communities';
        break;

      case ShareType.mealInvite:
        subPath = 'meal_invites';
        break;
      case ShareType.foodEvent:
        subPath = 'food_events';
        break;
      case ShareType.foodBank:
        subPath = 'food_banks';
        break;
      default:
        subPath = '';
        break;
    }

    return subPath;
  }

}