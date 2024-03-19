
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view_x/photo_view_x.dart';
import 'package:skibble/utils/constants.dart';


enum PhotoType {file, network, asset}

class GalleryImage {
  GalleryImage({
    required this.resource,
    required this.type,
    this.isSvg = false,
  });

  final String resource;
  final bool isSvg;
  final PhotoType type;
}

class CustomPhotoViewer extends StatefulWidget {
  final String curAssetUrl;
  final List<GalleryImage> photos;

  const CustomPhotoViewer(
      {Key? key,
        required this.curAssetUrl,
        required this.photos,
      })
      : super(key: key);

  @override
  State<CustomPhotoViewer> createState() => CustomPhotoViewerState();
}

class CustomPhotoViewerState extends State<CustomPhotoViewer> {
  final ValueNotifier<int> _initialPage = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    int initialPage = widget.photos.indexWhere((photo) => photo.resource == widget.curAssetUrl);
    // int initialPage = widget.photos.indexOf(widget.curAssetUrl);
    if (_initialPage.value != initialPage) {
      _initialPage.value = initialPage != -1 ? initialPage : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PhotoScaffold(
      body: Container(
        color: Colors.black87,
        child: Stack(
          children: [
            PhotoPageView(
              controller: SpacingPageController(
                  initialPage: _initialPage.value, pageSpacing: 30),
              itemBuilder: (context, idx) => _itemBuilder(context, idx),
              itemCount: widget.photos.length,
              onPageChanged: (int page) => {_initialPage.value = page},
            ),

            Positioned(
                top: 80,
                left: 10,
                child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close_rounded, color: kLightSecondaryColor,))),

          ],
        ),
      ),
      // bottomSheet: _buildBottomSheet(),
    );
  }
  
  Widget _itemBuilder(BuildContext context, int idx) {
    var sys = MediaQuery.of(context);
    var thumbnailView = sys.size.width * sys.devicePixelRatio;
    var asset = widget.photos[idx];
    return PhotoView(
      tapEnabled: true,
      child: Hero(
        tag: asset.resource,
        transitionOnUserGestures: true,
        child: Center(
          child: asset.type == PhotoType.network ?
          CachedNetworkImage(imageUrl: asset.resource, fit: BoxFit.cover, width: thumbnailView)
              :
          asset.type == PhotoType.file ? Image.file(File(asset.resource), fit: BoxFit.cover, width: thumbnailView)
              :
          Image.asset(asset.resource, fit: BoxFit.cover, width: thumbnailView)
          ,
        ),
      ),
    );
  }
}


// class CustomMultiPhotoViewer extends StatefulWidget {
//   final LoadingBuilder? loadingBuilder;
//   final BoxDecoration? backgroundDecoration;
//   final dynamic minScale;
//   final dynamic maxScale;
//   final int initialIndex;
//   final PageController pageController;
//   final List<GalleryImage> galleryItems;
//   final Axis scrollDirection;
//
//   CustomMultiPhotoViewer({
//     this.loadingBuilder,
//     this.backgroundDecoration,
//     this.minScale,
//     this.maxScale,
//     this.initialIndex = 0,
//     required this.galleryItems,
//     this.scrollDirection = Axis.horizontal,
//   }) : pageController = PageController(initialPage: initialIndex);
//   @override
//   _CustomMultiPhotoViewerState createState() => _CustomMultiPhotoViewerState();
// }
//
// class _CustomMultiPhotoViewerState extends State<CustomMultiPhotoViewer> with TickerProviderStateMixin{
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   late int currentIndex = widget.initialIndex;
//
//   void onPageChanged(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }
//   // @override
//   // void initState() {
//   //   currentIndex = 0
//   //   super.initState();
//   // }
//   //
//   // void onPageChanged(int index) {
//   //   setState(() {
//   //     currentIndex = index;
//   //   });
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Container(
//           child: Stack(
//             children: [
//               PhotoViewGallery.builder(
//                 // scrollPhysics: const BouncingScrollPhysics(),
//                 // builder: (BuildContext context, int index) {
//                 //   return PhotoViewGalleryPageOptions(
//                 //     imageProvider: widget.galleryItems[index].galleryImage.resource,
//                 //     initialScale: PhotoViewComputedScale.contained * 1,
//                 //     heroAttributes: PhotoViewHeroAttributes(tag: 'comm-image'),
//                 //   );
//                 // },
//                 // itemCount: widget.galleryItems.length,
//                 // loadingBuilder: (context, event) => Center(
//                 //   child: Container(
//                 //     width: 20.0,
//                 //     height: 20.0,
//                 //     child: CircularProgressIndicator(
//                 //       value: event == null
//                 //           ? 0
//                 //           : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
//                 //     ),
//                 //   ),
//                 // ),
//
//                 scrollPhysics: const BouncingScrollPhysics(),
//                 builder: _buildItem,
//                 itemCount: widget.galleryItems.length,
//                 loadingBuilder: widget.loadingBuilder,
//                 backgroundDecoration: widget.backgroundDecoration ?? const BoxDecoration(
//                   color: Colors.black,
//                 ),
//                 pageController: widget.pageController,
//                 onPageChanged: onPageChanged,
//                 scrollDirection: widget.scrollDirection,
//                 // backgroundDecoration: widget.backgroundDecoration,
//                 // pageController: widget.pageController,
//                 // onPageChanged: onPageChanged,
//               ),
//
//               Positioned(
//                 top: 80,
//                 left: 10,
//                 child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close_rounded, color: kLightSecondaryColor,))),
//
//             ],
//           )
//       ),
//     );
//   }
//
//
//   PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
//     final GalleryImage item = widget.galleryItems[index];
//     print(item.id);
//     return item.isSvg
//         ? PhotoViewGalleryPageOptions.customChild(
//       child: Container(
//         width: 300,
//         height: 300,
//         child: SvgPicture.asset(
//           item.id,
//           height: 200.0,
//         ),
//       ),
//       childSize: const Size(300, 300),
//       initialScale: PhotoViewComputedScale.contained,
//       minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
//       maxScale: PhotoViewComputedScale.covered * 4.1,
//       heroAttributes: PhotoViewHeroAttributes(tag: item.id),
//     )
//         : PhotoViewGalleryPageOptions(
//       imageProvider: item.resource,
//       initialScale: PhotoViewComputedScale.contained,
//       minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
//       maxScale: PhotoViewComputedScale.covered * 4.1,
//       heroAttributes: PhotoViewHeroAttributes(tag: item.id),
//     );
//   }
// }
//


// class CustomPhotoViewer extends StatefulWidget {
//   final ImageProvider imageProvider;
//
//   CustomPhotoViewer({required this.imageProvider});
//   @override
//   _CustomPhotoViewerState createState() => _CustomPhotoViewerState();
// }
//
// class _CustomPhotoViewerState extends State<CustomPhotoViewer> with TickerProviderStateMixin{
//
//   int? currentIndex;
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//   // @override
//   // void initState() {
//   //   currentIndex = 0
//   //   super.initState();
//   // }
//   //
//   // void onPageChanged(int index) {
//   //   setState(() {
//   //     currentIndex = index;
//   //   });
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       body: Container(
//           child: Stack(
//             children: [
//
//               PhotoView(
//                 imageProvider: widget.imageProvider,
//                 // backgroundDecoration: backgroundDecoration,
//                 // minScale: minScale,
//                 // maxScale: maxScale,
//                 initialScale: PhotoViewComputedScale.contained * 1,
//
//                 heroAttributes: const PhotoViewHeroAttributes(tag: "comm-image"),
//               ),
//               Positioned(
//                   top: 80,
//                   left: 10,
//                   child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close_rounded, color: kLightSecondaryColor,))),

//             ],
//           )
//       ),
//     );
//   }
// }


// class HeroPhotoViewRouteWrapper extends StatelessWidget {
//   const HeroPhotoViewRouteWrapper({
//     required this.imageProvider,
//     this.backgroundDecoration,
//     this.minScale,
//     this.maxScale,
//   });
//
//   final ImageProvider imageProvider;
//   final BoxDecoration? backgroundDecoration;
//   final dynamic minScale;
//   final dynamic maxScale;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints.expand(
//         height: MediaQuery.of(context).size.height,
//       ),
//       child: PhotoView(
//         imageProvider: imageProvider,
//         backgroundDecoration: backgroundDecoration,
//         minScale: minScale,
//         maxScale: maxScale,
//         heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
//       ),
//     );
//   }
// }