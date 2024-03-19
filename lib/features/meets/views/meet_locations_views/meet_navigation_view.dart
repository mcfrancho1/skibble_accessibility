import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_navigation_controller.dart';


class MeetNavigationView extends StatelessWidget {
  const MeetNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MeetsNavigationController>(
        builder: (context, data, child) {
          return MapBoxNavigationView(
            options: data.navigationOption,
            onRouteEvent: data.onEmbeddedRouteEvent,
            onCreated: (MapBoxNavigationViewController initController) async {
              data.controller = initController;

              data.controller?.initialize();
            });
        }
      ),
    );
  }
}
