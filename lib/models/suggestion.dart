import 'package:flutter/cupertino.dart';

import '../custom_icons/chef_icons_icons.dart';
import '../utils/constants.dart';

abstract class Suggestion {
  String title;
  String? subTitle;
  String type;
  bool isImage;
  String? imageUrl;
  Icon? icon;
  String? id;

  Suggestion({
    required this.title,
    this.subTitle,
    this.imageUrl,
    required this.type,
    this.isImage = true,
    this.icon = const Icon(ChefIcons.chef_hat, color: kLightSecondaryColor,),
    this.id
  });



  // factory Suggestion.fromJson(Map<String, dynamic> json, Icon icon, bool isImage) {
  //   return Suggestion(
  //       // placeId: json['place_id'],
  //     title: json['structured_formatting']['main_text'],
  //     subTitle: json['structured_formatting']['secondary_text'],
  //     icon: icon,
  //     isImage: isImage
  //   );
  // }
}

