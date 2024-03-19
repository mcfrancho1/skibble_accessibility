import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';

import '../../../enums/share_type.dart';
import '../../../models/chat_models/chat_message.dart';
import '../../../models/share_model.dart';
import '../../../services/firebase/dynamic_links.dart';
import '../../../services/share_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/helper_methods.dart';
import '../../booking/share_friend_view.dart';

class ShareContentButton extends StatelessWidget {
  const ShareContentButton({Key? key,
    required this.shareModel,

  }) : super(key: key);


  final ShareModel shareModel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async{
          // await MapLauncherController().launchMaps(context, widget.skibblePost.postAddress!);

          var link = await CustomBottomSheetDialog.showCustomShareSheet(context, shareModel);


          // Navigator.pop(context);
          //
          // if(link != null) {
          //   HelperMethods().shareData(context,
          //       'Check out this skib on the Skibble App!\n$link',
          //       'Share this skib with friends!');
          // }
        },
        splashRadius: 20,
        icon: Icon(Iconsax.send_2, size: 28, color: shareModel.iconColor,)
    );
  }
}
