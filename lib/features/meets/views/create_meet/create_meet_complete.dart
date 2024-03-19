import 'package:flutter/material.dart';

import '../../../../utils/emojis.dart';

class CompletedMeetsPage extends StatelessWidget {
  const CompletedMeetsPage({Key? key}) : super(key: key);

  static final EmojiController emojiController = EmojiController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(emojiController.emojiMap['tada'], style: TextStyle(fontSize: 80),)),
        Align(
            alignment: Alignment.center,
            child: Center(
                child: Text(
                  'Hooray!',
                  style: TextStyle(fontSize: 20, ),
                  textAlign: TextAlign.center,
                )
            )
        ),

        SizedBox(height: 8,),
        Align(
            alignment: Alignment.center,
            child: Center(
                child: Text(
                  'Your meet has been created successfully!',
                  style: TextStyle(fontSize: 14, ),
                  textAlign: TextAlign.center,
                )
            )
        ),

        //TODO: Share button here

      ],
    );
  }
}
