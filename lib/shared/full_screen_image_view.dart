import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  FullScreenImageView({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(imageUrl),
        heroAttributes:  PhotoViewHeroAttributes(
          tag: imageUrl,
          transitionOnUserGestures: true,
        ),
      ),
    );
  }
}
