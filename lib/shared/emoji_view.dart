import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

import '../localization/app_translation.dart';

class EmojiPickerWidget extends StatelessWidget {
  final ValueChanged<String> onEmojiSelected;

  const EmojiPickerWidget({
    required this.onEmojiSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2.7,
      child: EmojiPicker(
        config: Config(
          bgColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
          noRecents: Text(tr.noRecents, style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),)
        ),
        onEmojiSelected: (category, emoji) => onEmojiSelected(emoji.emoji),
      ),
    );
  }
}