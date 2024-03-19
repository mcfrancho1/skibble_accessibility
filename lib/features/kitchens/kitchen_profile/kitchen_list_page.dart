import 'package:flutter/material.dart';
import 'package:skibble/shared/header.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:get/get.dart';


class AllKitchenListPageView extends StatelessWidget {
  const AllKitchenListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // brightness: Brightness.light,
            elevation: 0.0,
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 180,
            // floating: true,
            // automaticallyImplyLeading: false,
            backgroundColor: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
            centerTitle: false,
            // title: _showTitle ? Header() : null,
            expandedHeight: 180,
            flexibleSpace: SafeArea(child: Header(hintText: 'searchCooks'.tr, onTabChanged: (int value) {  },)),
          ),
        ],
      ),
    );
  }
}
