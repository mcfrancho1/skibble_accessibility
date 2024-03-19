import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/services/firebase/database/chef_database.dart';

import '../../../custom_icons/chef_icons_icons.dart';
import '../../../models/skibble_user.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/firebase/database/kitchens_database.dart';
import '../../../utils/constants.dart';
import '../../../utils/currency_formatter.dart';
import '../../../utils/number_display.dart';
import '../kitchen_profile/kitchen_profile_page.dart';


class DiscoverPageKitchenFuture extends StatefulWidget {
  const DiscoverPageKitchenFuture({Key? key, required this.address, required this.type}) : super(key: key);
  final Address address;
  final String type;

  @override
  _DiscoverPageKitchenFutureState createState() => _DiscoverPageKitchenFutureState();
}

class _DiscoverPageKitchenFutureState extends State<DiscoverPageKitchenFuture> {

  Future? _future;
  List<SkibbleUser>? kitchensList;
  String headerTitle = '';

  @override
  void initState() {
    // TODO: implement initState

    var model = Provider.of<AppData>(context, listen: false).discoverPageModel;

    switch(widget.type) {
      case 'topRated':
        headerTitle = 'Top Rated';
        if(model.topRatedKitchensList != null) {
          kitchensList = model.topRatedKitchensList;
          _future = Future.value(model.topRatedKitchensList);
        }
        else {
          _future = KitchenDatabaseService().getTopRatedKitchensList(context, widget.address);
        }
        break;

      case 'nearby':
        headerTitle = 'Nearby';
        if(model.nearbyKitchensList != null) {
          kitchensList = model.nearbyKitchensList;
          _future = Future.value(model.nearbyKitchensList);
        }
        else {
          _future = KitchenDatabaseService().getNearbyKitchensList(context, widget.address);
        }
        break;

      default:
        _future = Future.value([]);
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppData>(context, listen: false).discoverPageModel;

    return kitchensList != null ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              headerTitle,
              style: TextStyle(fontSize: 28.0, height: 1,),
            ),
          ],
        ),

        SizedBox(height: 10,),
        DiscoverPageHorizontalListView(skibbleKitchensList: kitchensList!),
      ],
    )
        :
      FutureBuilder(
          future: _future,
          initialData: widget.type == 'topRated' ? model.topRatedKitchensList : model.nearbyKitchensList,
          builder: (context, snapshot) {
            switch(snapshot.connectionState) {

              case ConnectionState.none:
              case ConnectionState.waiting:
                return DiscoverPageListViewShimmer();
              case ConnectionState.active:
              case ConnectionState.done:
                List<SkibbleUser> users = [];
                String headerTitle = '';
                switch(widget.type) {
                  case 'topRated':
                    users = model.topRatedKitchensList ?? [];
                    break;

                  case 'nearby':
                    users = model.nearbyKitchensList ?? [];
                    break;

                  default:
                    users = [];
                    break;
                }


                return users.isNotEmpty ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          headerTitle,
                          style: TextStyle(fontSize: 28.0, height: 1,),
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),
                    DiscoverPageHorizontalListView(skibbleKitchensList: users),
                  ],
                ) : Container();

            }
          });
  }
}


class DiscoverPageListViewShimmer extends StatelessWidget {
  const DiscoverPageListViewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 100,
            height: 20,
            margin: EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
          ),

          SizedBox(height: 15,),


          SizedBox(
            height: 800,
            child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: size.width > 600 ? 1 / (0.6) :  1 / (1.4),
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                physics: NeverScrollableScrollPhysics(),
                // Generate 5 widgets that display their index in the List.
                children: List.generate( 6, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                      width: 250,
                      height: 150,
                      margin: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade300,
                        ),
                      ),

                      SizedBox(height: 8,),
                      Container(
                        width: 80,
                        height: 20,
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      SizedBox(height: 4,),
                      Container(
                        width: 40,
                        height: 20,
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  );
                }
                )
            ),
          ),
        ],
      ),
    );

      // ListView.builder(
      //   itemCount: 5,
      //   scrollDirection: Axis.horizontal,
      //   itemBuilder: (context, index) {
      //     return ;
      // }));
  }
}


class DiscoverPageHorizontalListView extends StatelessWidget {
  final List<SkibbleUser> skibbleKitchensList;

  const DiscoverPageHorizontalListView({Key? key, required this.skibbleKitchensList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: skibbleKitchensList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return DiscoverPageKitchenCard(user: skibbleKitchensList[index]);
          }),
    );
  }
}

class DiscoverPageKitchenCard extends StatelessWidget {
  const DiscoverPageKitchenCard({Key? key, required this.user}) : super(key: key);
  final SkibbleUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  KitchenProfilePage(
                      skibbleUser: user))),
      child: Container(
        width: 250,
        height: 150,
        margin: EdgeInsets.only(
            right: 20, top: 10, bottom: 10, left: 3),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image:user.profileImageUrl != null ? DecorationImage(
                    //TODO: change to NetworkImage later
                    image: CachedNetworkImageProvider(
                        user.profileImageUrl!
                    ),
                    fit: BoxFit.cover,
                  ) : null,
                  color: user.userCustomColor,

                ),
                child: user.profileImageUrl == null ? Center(
                    child: Icon(
                      ChefIcons.chef_hat_dark_1,
                      size: 120,
                      color: kLightSecondaryColor,)) : null,
              ),
            ),

            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8),
                child: Text(
                  user.fullName!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight
                      .w600),
                ),
              ),
              isThreeLine: true,
              subtitle: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userAddress!.city!,
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(height: 8,),

                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(
                            user.kitchen!.averageRatings != null ? '${(user.kitchen!.averageRatings!).toStringAsFixed(1)}' : '5.0',
                            style: TextStyle(
                                color: kLightSecondaryColor
                            ),
                          ),
                        ),

                        SizedBox(width: 10,),

                        user.kitchen!.receivePrivateMessages ? Icon(Iconsax.message, size: 20, color: Colors.grey,) : Container(),
                        user.kitchen!.receivePrivateMessages ? SizedBox(width: 5,) : Container(),

                        Icon(Iconsax.calendar, size: 20, color: Colors.grey,),

                        SizedBox(width: 10,),

                        CircleAvatar(
                          radius: 2.5, backgroundColor: Colors.grey,),
                        SizedBox(width: 5,),

                        Text(
                          '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromCountryCode(user.userAddress!.countryCode!)}${NumberDisplay(decimal: 2, length: 4).displayDelivery(user.kitchen!.chargeRate)} ${user.kitchen!.chargeRateType}',
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

