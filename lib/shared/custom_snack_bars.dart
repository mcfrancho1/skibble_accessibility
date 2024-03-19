import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/constants.dart';


class CustomSnackBars {

  SnackBar showErrorSnackBar(context, String title, String message) {
    return SnackBar(
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              height: 90,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xFFC72C41),

              ),
              child: Row(
                children: [
                  SizedBox(width: 48,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                          style: TextStyle(
                              fontSize: 18,
                              color:  kLightSecondaryColor),
                        ),
                       Spacer(),

                        Text(
                          message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              color: kLightSecondaryColor
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),

          Positioned(
              bottom: 0,
              child: SvgPicture.asset(
                'assets/images/bubble.svg',
                height: 48,
                width: 40,

              )),

          Positioned(
              top: -15,
              left: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/chat_bubble.svg',
                    height: 35,
                  ),

                  Icon(Icons.clear, size: 20, color: kLightSecondaryColor,)
                ],
              ))
        ],
      ),
      behavior:  SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}