import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/feed/views/skibble_feed_view.dart';

import '../controllers/skibble_feed_controller.dart';
import '../models/feed_component.dart';


class SkibbleFeedParent extends StatelessWidget {
  const SkibbleFeedParent({super.key, required this.feedComponents});
  final List<FeedComponent> feedComponents;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => SkibbleFeedController(),
        child: SkibbleFeedView(feedComponents: feedComponents));
  }
}
