

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../custom_icons/chef_icons_icons.dart';
import '../../../models/skibble_user.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../utils/constants.dart';
import '../../../utils/currency_formatter.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/number_display.dart';

class NewDiscoverPageKitchenCard extends StatelessWidget {
  const NewDiscoverPageKitchenCard({Key? key, required this.kitchenUser}) : super(key: key);
  final SkibbleUser kitchenUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return GestureDetector(
      // onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommunityDiscussionRoomFuture(community: community,))),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  kitchenUser.profileImageUrl != null ? CachedNetworkImage(
                    imageUrl: kitchenUser.profileImageUrl!,
                    fit: BoxFit.cover,
                    memCacheWidth: 100,
                    memCacheHeight: 100,
                    // height: widget.height,
                    // width: widget.width,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(5),

                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    errorWidget: (context, s, m) {
                      return Image.asset('assets/images/dish.png', fit: BoxFit.cover,);
                    },

                    placeholder: (context, t) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300
                        ),
                      );
                    },
                  )
                      :
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: kitchenUser.userCustomColor,
                    ),
                    child: Center(
                        child: Icon(
                          ChefIcons.chef_hat_dark_1,
                          size: 120,
                          color: kLightSecondaryColor,)),
                  ),

                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),

                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            colors: [
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.0),
                              //Colors.black.withOpacity(0.0)
                            ]
                        ),
                      ),
                    ),
                  ),

                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),

                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.0),
                              //Colors.black.withOpacity(0.0)
                            ]
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 0,
                    top: 10,
                    // width: 4/5 * (size.width - 20) / 2 ,

                    child: Container(
                      // margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star_rounded, size: 14, color: kLightSecondaryColor,),

                                  Text(
                                    kitchenUser.kitchen!.averageRatings != null ? '${(kitchenUser.kitchen!.averageRatings!).toStringAsFixed(1)}' : '5.0',
                                    style: TextStyle(
                                        color: kLightSecondaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),),
                ],
              ),
            ),

            SizedBox(height: 5,),

            Text(
              '${kitchenUser.fullName}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor
              ),
            ),

            SizedBox(height: 5,),

            Text(
              kitchenUser.kitchen!.serviceLocation!.city!,
              style: TextStyle(
                  color: Colors.grey
              ),
            ),

            SizedBox(height: 5,),

            Row(
              children: [

                kitchenUser.kitchen!.receivePrivateMessages ? Icon(Iconsax.message, size: 20, color: Colors.grey,) : Container(),
                kitchenUser.kitchen!.receivePrivateMessages ? SizedBox(width: 5,) : Container(),

                Icon(Iconsax.calendar, size: 20, color: Colors.grey,),

                SizedBox(width: 10,),

                CircleAvatar(
                  radius: 2.5, backgroundColor: Colors.grey,),
                SizedBox(width: 5,),

                Text(
                  '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromCountryCode(kitchenUser.kitchen!.serviceLocation!.countryCode!)}${NumberDisplay(decimal: 2, length: 4).displayDelivery(kitchenUser.kitchen!.chargeRate)} ${kitchenUser.kitchen!.chargeRateType}',
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.grey
                  ),
                ),
              ],
            ),

            // Text(
            //   '${recipe.description}',
            //
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            //   style: TextStyle(
            //       fontSize: 13, color: Colors.grey ),
            // ),


          ],
        ),
      ),
    );

  }
}
