import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cu;

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:skibble/features/meets/controllers/meets_filter_controller.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';
import 'package:skibble/utils/constants.dart';

import '../../../../custom_icons/skibble_custom_icons_icons.dart';
import '../../../../custom_icons/skibble_icons_icons.dart';
import '../../../../new_custom_icons/icons.dart';
import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../utils/current_theme.dart';
import '../../../../utils/emojis.dart';

class MeetsPageHeader extends StatelessWidget {
  const MeetsPageHeader({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AppData>(context).skibbleUser!;

    return  Container(
      width: double.infinity,
      // height: 400,
      decoration: const BoxDecoration(
          color: kContentColorLightTheme,
        // border: Border(bottom: BorderSide(color: Colors.grey.shade300))
      ),
      // ClipRRect(
      //     child: BackdropFilter(
      //         filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      //         child: Container(
      //           width: MediaQuery.of(context).size.width,
      //           height: MediaQuery.of(context).padding.top,
      //           color: Colors.transparent,
      //         )
      //     )
      // )
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 8),
            //     child: Text('Meets', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            //   ),
            // ),
            Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 16.0, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///This is the search bar that will be added in the future

                  // const Text('Meets', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                  Icon(
                    SkibbleIcons.skibble_wordmark_light,
                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kPrimaryColor,
                    size: 40,
                  ),
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(24.0),
                  //       boxShadow: const [
                  //         BoxShadow(
                  //             color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 5.0)
                  //       ],
                  //     ),
                  //     child: const Row(
                  //       children: [
                  //         Icon(cu.CupertinoIcons.search),
                  //         SizedBox(width: 10,),
                  //         Text(
                  //           "Find meets nearby...",
                  //           style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(width: 6,),
                  Consumer<MeetsFilterController>(
                    builder: (context, filterData, child) {
                      return GestureDetector(
                        onTap: ()async {
                          await MeetsBottomSheets().showMeetsFilterSheet(context,);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UserSpotsView()));
                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 5.0)
                              ],
                              border: filterData.meetFilter != null ? Border.all(color: kDarkSecondaryColor, width: 1.5) : null
                            ),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 4.0, left: 4, right: 4),
                                child: Icon(
                                  SkibbleCustomIcons.filter_thick,
                                  // Icons.steppers,
                                  size: 19,
                                ),
                              ),
                            )
                        ),
                      );
                    }
                  ),
                  // IconButton(onPressed: () {}, icon: Icon(Iconsax.add))
                  // CircleIconButton(onTap: () {}, icon: , theme: ThemeData.light())

                ],
              ),
            ),
            Consumer<MeetsController>(
              builder: (context, data, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: .0,),
                  child: SizedBox(
                    height: 45,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // padding: const EdgeInsets.all(8),
                        itemCount: data.meetsHeaderTexts.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return NeumorphicButton(
                            // curve: Neumorphic.DEFAULT_CURVE,

                            onPressed: () {
                              data.selectedHeader = index;

                              switch(index) {

                              case 0:
                                break;

                                case 1:
                                  break;

                                case 2:
                                  break;

                                case 3:
                                  break;
                              }
                            },
                            style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                                depth: 0,
                                shape: NeumorphicShape.flat,
                                border: NeumorphicBorder(
                                    color:  kLightSecondaryColor , width: data.selectedHeader == index ? 0.8 : 0
                                ),
                                // lightSource: LightSource.bottom,
                                color: index != data.selectedHeader ? kLightSecondaryColor : kPrimaryColorLight
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                            // width: 100,
                            child: Center(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    data.meetsHeaderIcons[index],
                                    color: data.selectedHeader == index ? kPrimaryColor : kDarkSecondaryColor.withOpacity(0.8),
                                    size: 15,
                                  ),

                                  const SizedBox(width: 5,),
                                  Text(
                                    data.meetsHeaderTexts[index],
                                    style: TextStyle(
                                    color: data.selectedHeader == index ? kPrimaryColor : kDarkSecondaryColor.withOpacity(0.8),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );

    // return ClipRRect(
    //     child: BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    //         child: Container(
    //           width: MediaQuery.of(context).size.width,
    //           height: MediaQuery.of(context).padding.top,
    //           // color: Colors.transparent,
    //           child: SafeArea(
    //             top: true,
    //             bottom: false,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Container(
    //                   padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       ///This is the search bar that will be added in the future
    //
    //                       Expanded(
    //                         child: Container(
    //                           padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
    //                           decoration: BoxDecoration(
    //                             color: Colors.white,
    //                             borderRadius: BorderRadius.circular(24.0),
    //                             boxShadow: const [
    //                               BoxShadow(
    //                                   color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 10.0)
    //                             ],
    //                           ),
    //                           child: Row(
    //                             children: [
    //                               Icon(cu.CupertinoIcons.search),
    //                               SizedBox(width: 10,),
    //                               const Text(
    //                                 "Find food spots nearby",
    //                                 style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //
    //                       SizedBox(width: 6,),
    //                       GestureDetector(
    //                         onTap: () {
    //                           // Navigator.push(context, MaterialPageRoute(builder: (context) => UserSpotsView()));
    //                         },
    //                         child: Container(
    //                             padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
    //                             decoration: BoxDecoration(
    //                               color: Colors.white,
    //                               shape: BoxShape.circle,
    //                               boxShadow: const [
    //                                 BoxShadow(
    //                                     color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 10.0)
    //                               ],
    //                             ),
    //                             child: Padding(
    //                               padding: const EdgeInsets.all(3.0),
    //                               child: Icon(
    //                                 Iconsax.filter,
    //                                 // cu.CupertinoIcons.flame,
    //                                 size: 19,
    //                               ),
    //                             )
    //                         ),
    //                       ),
    //                       // IconButton(onPressed: () {}, icon: Icon(Iconsax.add))
    //                       // CircleIconButton(onTap: () {}, icon: , theme: ThemeData.light())
    //
    //                     ],
    //                   ),
    //                 ),
    //                 Consumer<MeetsController>(
    //                     builder: (context, data, child) {
    //                       return Padding(
    //                         padding: EdgeInsets.symmetric(horizontal: 5.0,),
    //                         child: SizedBox(
    //                           height: 50,
    //                           child: ListView.builder(
    //                               scrollDirection: Axis.horizontal,
    //                               // padding: const EdgeInsets.all(8),
    //                               itemCount: data.meetsHeaderTexts.length,
    //                               shrinkWrap: true,
    //                               itemBuilder: (BuildContext context, int index) {
    //                                 return NeumorphicButton(
    //                                   // curve: Neumorphic.DEFAULT_CURVE,
    //
    //                                   onPressed: () {
    //                                     data.selectedHeader = index;
    //
    //                                     switch(index) {
    //
    //                                       case 0:
    //                                         break;
    //
    //                                       case 1:
    //                                         break;
    //
    //                                       case 2:
    //                                         break;
    //
    //                                       case 3:
    //                                         break;
    //                                     }
    //                                   },
    //                                   style: NeumorphicStyle(
    //                                       boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
    //                                       depth: 0,
    //                                       shape: NeumorphicShape.flat,
    //                                       border: NeumorphicBorder(
    //                                           color:  kDarkSecondaryColor , width: data.selectedHeader == index ? 0.8 : 0
    //                                       ),
    //                                       // lightSource: LightSource.bottom,
    //                                       color: index != data.selectedHeader ? kLightSecondaryColor : kDarkSecondaryColor
    //                                   ),
    //                                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
    //                                   padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
    //                                   // width: 100,
    //                                   child: Center(
    //                                     child: Row(
    //                                       children: <Widget>[
    //                                         Icon(
    //                                           data.meetsHeaderIcons[index],
    //                                           color: data.selectedHeader == index ? kLightSecondaryColor : Colors.grey.shade600,
    //                                           size: 15,
    //                                         ),
    //
    //                                         SizedBox(width: 5,),
    //                                         Text(
    //                                           '${data.meetsHeaderTexts[index]}', style: TextStyle(
    //                                             color: data.selectedHeader == index ? kLightSecondaryColor : Colors.grey.shade600,
    //                                             fontWeight: FontWeight.bold
    //                                         ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 );
    //                               }),
    //                         ),
    //                       );
    //                     }
    //                 ),
    //
    //               ],
    //             ),
    //           ),
    //         )
    //     )
    // );
  }


}
