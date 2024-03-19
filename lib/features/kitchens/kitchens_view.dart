import 'package:flutter/material.dart';

import 'kitchens_discover_view/kitchens_view.dart';


class KitchensView extends StatelessWidget {
  const KitchensView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DiscoverKitchensPreViewFuture();
  }
}
