import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailImageFromVideo extends StatefulWidget {
  const ThumbnailImageFromVideo({Key? key, required this.videoUrl, this.identifierWidget}) : super(key: key);
  final String videoUrl;
  final Widget? identifierWidget;

  @override
  State<ThumbnailImageFromVideo> createState() => _ThumbnailImageFromVideoState();
}

class _ThumbnailImageFromVideoState extends State<ThumbnailImageFromVideo> {

  Future? future;


  @override
  void initState() {
    // TODO: implement initState
    future = getThumbnail();
    super.initState();
  }

  Future<String?> getThumbnail() async{

    try {
      String path = (await getTemporaryDirectory()).path;
      return VideoThumbnail.thumbnailFile(
        video: widget.videoUrl,
        thumbnailPath: path,
        imageFormat: ImageFormat.WEBP,
        maxWidth: 0,
        maxHeight: 0, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
    }
    catch(e) {
      return null;
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(child: Center(child: CircularProgressIndicator()),);
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.data != null) {
              dynamic file = snapshot.data;
              return Container(
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(file),
                    ),
                    fit: BoxFit.cover,
                  )
                ),
                child: widget.identifierWidget,
              );

            }
            else {
              return Container(child: Text('Error'),);
            }

            // TODO: Handle this case.
        }
    });
  }
}
