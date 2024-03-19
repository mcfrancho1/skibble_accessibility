import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/utils/constants.dart';
import 'package:get/get.dart';
import 'package:skibble/utils/current_theme.dart';

import '../localization/app_translation.dart';


class AnimatedSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final Function? onTap;
  const AnimatedSearchBar({Key? key, this.onChanged, this.onTap}) : super(key: key);

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {

  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: _folded ? 100 : size.width - 30,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        // color: Colors.red
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: !_folded ?
                TextField(
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: CurrentTheme(context).isDarkMode ? BorderSide.none : BorderSide(color: kPrimaryColor)
                    ),
                    hintText: 'Search Chats...',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _folded = !_folded;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                )
                : null,
          )),

          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            child: InkWell(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(_folded ? 32 : 0),
              //   topRight: Radius.circular(32),
              //   bottomLeft: Radius.circular(_folded ? 32 : 0),
              //   bottomRight: Radius.circular(32)

              // ),
              onTap: () {
                widget.onTap!;
                setState(() {
                  _folded = !_folded;
                });
              },
              child: _folded ? Container(
                height: 85,
                width: 85,
                // color: Colors.blue,
                margin: EdgeInsets.symmetric(horizontal: 5),
                // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor,
                      ),
                      child: Icon(Iconsax.search_normal_1, color: kLightSecondaryColor,),
                    ),
                    SizedBox(height: 3,),
                    Text(tr.search, maxLines: 1, overflow: TextOverflow.ellipsis,)
                  ],
                ),
              ) : Container()
              // child: Icon(
              //   _folded ? Icons.search : Icons.close,
              //   color: Colors.blue[900],
              //
              // ),
            ),
          )
        ],
      ),
    );
  }
}
