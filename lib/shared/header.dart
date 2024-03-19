import 'package:animate_do/animate_do.dart';
import 'package:badges/badges.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/search_bar.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/number_display.dart';

import '../services/change_data_notifiers/app_data.dart';
import '../services/change_data_notifiers/cart_data.dart';


class Header extends StatefulWidget {
  final String hintText;
  const Header({Key? key, required this.hintText, required this.onTabChanged}) : super(key: key);
  final ValueChanged<int> onTabChanged;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin{

  late TabController _tabController;


  @override
  void initState() {
    // TODO: implement initState
    // widget.onTabChanged(0);

    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartData>(context).userCart;

    var user = Provider.of<AppData>(context).skibbleUser!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme
      ),
      child: FadeInDown(
        duration: Duration(milliseconds: 500),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Find Chefs',
                  style: TextStyle(fontSize: 28.0, height: 1, ),
                ),
                // InkWell(
                //     onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartView())),
                //     customBorder: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20)
                //     ),
                //     child: Container(
                //         padding: EdgeInsets.all(8.0),
                //         alignment: Alignment.bottomCenter,
                //         child: Badge(
                //             badgeContent: Text('${NumberDisplay(decimal: 0, length: 3).displayDelivery(cart.totalItems)}', style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kLightSecondaryColor,),),
                //             badgeColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kPrimaryColor,
                //             child: Icon(
                //               Iconsax.shopping_cart,
                //               color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                //               size: 28,))
                //
                //     )
                // ),
              ],
            ),

            SizedBox(height: 20,),

            CustomSearchBar(
              hintText: widget.hintText,
                onChanged: (value) {},),

            SizedBox(height: 20,),

            ButtonsTabBar(
                controller: _tabController,
                contentPadding: EdgeInsets.symmetric(horizontal: 18),
                backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kPrimaryColor,
                center: false,
                borderColor: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
                unselectedBackgroundColor: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
                labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
                borderWidth: 1,
                unselectedBorderColor: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kPrimaryColor,
                radius: 10,
                onTap: (index) {
                  widget.onTabChanged(index);
                },
                tabs: [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Nearby',
                  ),
                  Tab(
                    text: 'Top Rated',
                  ),

                  Tab(
                    text: 'Affordable',
                  ),

                ]
            ),
          ],
        ),
      ),
    );
  }
}
