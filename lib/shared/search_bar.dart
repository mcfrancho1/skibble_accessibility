import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';


class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final bool? showArrowBack;
  final ValueChanged<String?> onChanged;
  const CustomSearchBar({Key? key, required this.hintText, this.showArrowBack, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 55,
        // margin: EdgeInsets.symmetric( vertical: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(13)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color:   CurrentTheme(context).isDarkMode ? kDarkSecondaryColor.withOpacity(.3) : Colors.grey.withOpacity(.3),
              blurRadius: 15,
              offset: Offset(5, 5),
            )
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: InputBorder.none,
            hintText: hintText,
            prefixIcon: showArrowBack != null && showArrowBack != false? GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_rounded, color: kPrimaryColor,)) : null,
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: SizedBox(
                width: 50,
                child: Icon(Icons.search, color: kPrimaryColor)
            ),
          ),
        )
    );
  }
}
