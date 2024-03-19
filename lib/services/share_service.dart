import 'package:appinio_social_share/appinio_social_share.dart';

import '../enums/share_type.dart';
import 'firebase/dynamic_links.dart';

class ShareService {

  static Future<String?> shareToTwitter(ShareType type, String id, {String? title, String? description, String? imageUrl}) async{
    try {
      var result = await DynamicLinks().createDynamicLink(
          type,
          id,
          title: '$title',
          imageUrl: imageUrl,
          description: description
      );

      if(result != null) {
        //with hashtags and link
        return await AppinioSocialShare().shareToTwitter(result);
      }
      else {
        return null;
      }
    }

    catch(e) {
      return null;
    }
  }

  static Future<String?> copyToClipBoard(ShareType type, String id, {String? title, String? description, String? imageUrl}) async{
    try {
      var result = await DynamicLinks().createDynamicLink(
          type,
          id,
          title: '$title',
          imageUrl: imageUrl,
          description: description
      );

      if(result != null) {
        //with hashtags and link
        return await AppinioSocialShare().copyToClipBoard(
            result
        );
      }

      else {
        return null;
      }
    }
    catch(e) {
      print(e);

      return null;
    }
  }


  static Future<String?> shareToSms(ShareType type, String id, {String? title, String? description, String? imageUrl}) async{
    try {
      var result = await DynamicLinks().createDynamicLink(
          type,
          id,
          title: '$title',
          imageUrl: imageUrl,
          description: description
      );

      if(result != null) {
        return await AppinioSocialShare().shareToSMS(
            result
        );
      }

      else {
        return null;
      }
    }

    catch(e) {
      return null;
    }
  }


  static Future<String?> shareToWhatsapp(ShareType type, String id, {String? title, String? description, String? imageUrl}) async{
    try {
      var result = await DynamicLinks().createDynamicLink(
          type,
          id,
          title: '$title',
          imageUrl: imageUrl,
          description: description
      );

      if(result != null) {
        return await AppinioSocialShare().shareToWhatsapp(result);
      }

      else {
        return null;
      }
    }

    catch(e) {
      return null;
    }
  }


}