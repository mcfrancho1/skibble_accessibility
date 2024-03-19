import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/custom_icons/chef_icons_icons.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

class KitchenProfileOverviewView extends StatelessWidget {
  const KitchenProfileOverviewView({Key? key, required this.skibbleUser}) : super(key: key);

  final SkibbleUser skibbleUser;
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20,
                        right: 20,
                        top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Description',
                          style: TextStyle(
                              fontFamily: 'Brand Regular',
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                              color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor

                          ),
                        ),
                        SizedBox(height: 15,),
                        // Divider(),
                        Text(
                          skibbleUser.kitchen!.description ?? '',

                          style: TextStyle(fontSize: 15, ),
                        ),

                        // Container(
                        //   child: ExpandableText(
                        //     text: 'Use the Read More plugin when we have to show two-three lines of the entire paragraph, '
                        //         'the rest of the text is hidden. '
                        //         'To create such a view, we use the properties of the Read More plugin and the user can give two texts anything. '
                        //         'Which can be clicked to show and less the text of the paragraph.',
                        //     style: TextStyle(
                        //
                        //         fontSize: 17,
                        //         //fontWeight: FontWeight.bold,
                        //         fontFamily: 'Nunito Regular'
                        //     ),
                        //   ),
                        // ),

                        SizedBox(height: 30,),

                        if(skibbleUser.kitchen!.workExperienceList!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 2,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                                  borderRadius: BorderRadius.circular(40)
                                ),
                              ),

                              SizedBox(height: 20,),


                              Text(
                                'Work Experience',
                                style: TextStyle(
                                    fontFamily: 'Brand Regular',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                  // color: kPrimaryColor
                                ),
                              ),

                              SizedBox(height: 5),

                              Column(
                              children: List.generate(skibbleUser.kitchen!.workExperienceList!.length, (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),

                                  Row(
                                    children: [
                                      Icon(ChefIcons.chef_hat, color: Colors.grey,),
                                      SizedBox(width: 5,),
                                      Text(
                                        skibbleUser.kitchen!.workExperienceList![index]['JobTitle'],
                                        style: TextStyle(
                                            fontFamily: 'Brand Regular',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: CurrentTheme(context).isDarkMode? kLightSecondaryColor : kDarkSecondaryColor
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8,),

                                  Row(
                                    children: [
                                      Icon(Iconsax.shop, color: Colors.grey,),
                                      SizedBox(width: 5,),
                                      Text(
                                        skibbleUser.kitchen!.workExperienceList![index]['Where'],
                                        style: TextStyle(
                                            fontFamily: 'Brand Regular',
                                            fontSize: 16,
                                            color: CurrentTheme(context).isDarkMode? kLightSecondaryColor : kDarkSecondaryColor
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8,),

                                  Row(
                                    children: [
                                      Icon(Iconsax.calendar_1, color: Colors.grey,),
                                      SizedBox(width: 5,),
                                      RichText(text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: skibbleUser.kitchen!.workExperienceList![index]['StartDate'],
                                              style: TextStyle(
                                                  fontFamily: 'Brand Regular',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                  color: Colors.grey
                                              ),
                                            ),

                                            TextSpan(
                                              text: ' - ',
                                              style: TextStyle(
                                                  fontFamily: 'Brand Regular',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Colors.grey
                                              ),
                                            ),

                                            TextSpan(
                                              text: skibbleUser.kitchen!.workExperienceList![index]['EndDate'],
                                              style: TextStyle(
                                                  fontFamily: 'Brand Regular',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Colors.grey
                                              ),
                                            )
                                          ]
                                      )),
                                    ],
                                  ),

                                  SizedBox(height: 10,),


                                ],
                              )),
                        ),
                            ],
                          ),

                        if(skibbleUser.kitchen!.workExperienceList!.isNotEmpty)
                          SizedBox(height: 15,),

                        if(skibbleUser.kitchen!.certificationsList!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 2,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(40)
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                'Certifications',
                                style: TextStyle(
                                    fontFamily: 'Brand Regular',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    // color: kPrimaryColor

                                ),
                              ),

                              SizedBox(height: 5),
                              Column(
                                children: List.generate(skibbleUser.kitchen!.certificationsList!.length, (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),
                                    Row(
                                      children: [
                                        Icon(Iconsax.document, color: Colors.green,),
                                        SizedBox(width: 5,),
                                        Text(
                                          skibbleUser.kitchen!.certificationsList![index]['Name'],
                                          style: TextStyle(
                                              fontFamily: 'Brand Regular',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: CurrentTheme(context).isDarkMode? kLightSecondaryColor : kDarkSecondaryColor
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),

                                    Row(
                                      children: [
                                        Icon(Iconsax.global, color: Colors.grey,),
                                        SizedBox(width: 5,),
                                        Text(
                                          skibbleUser.kitchen!.certificationsList![index]['CountryIssued'],
                                          style: TextStyle(
                                              fontFamily: 'Brand Regular',
                                              fontSize: 16,
                                              color: CurrentTheme(context).isDarkMode? kLightSecondaryColor : kDarkSecondaryColor
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 8,),

                                    Row(
                                      children: [
                                        Icon(Iconsax.calendar_1, color: Colors.grey,),
                                        SizedBox(width: 5,),
                                        Text(
                                          skibbleUser.kitchen!.certificationsList![index]['DateIssued'],
                                          style: TextStyle(
                                              fontFamily: 'Brand Regular',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: Colors.grey
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 10,),

                                  ],
                                )),
                              )
                            ],
                          )

                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
