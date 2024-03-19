import 'package:flutter/material.dart';

import '../../../models/feed_post.dart';

class FeedComponent {

  final Future<List<FeedPost>> Function(String? lastDocId) onFetchFeedList;

  final FeedPostType feedPostType;

  ///The widget for a single child of this component
  final Widget singleComponentWidget;

  ///how many of this component should be displayed before the next component
  final int displayLength;

  final String? componentHeader;
  final String? componentSubTitle;

  final Axis scrollDirection;

  FeedComponent({
    required this.onFetchFeedList,
    required this.singleComponentWidget,
    required this.displayLength,
    required this.feedPostType,
    this.componentHeader,
    this.componentSubTitle,
    this.scrollDirection = Axis.vertical
  });


  Future<List<FeedPost>> callFetchFeedFunction(String? lastDocId) {
    return onFetchFeedList(lastDocId);
  }

}