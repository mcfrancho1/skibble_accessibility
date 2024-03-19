import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/loading_spinner.dart';
import 'package:skibble/features/meets/controllers/create_edit_meets_controller.dart';

import '../../../../utils/constants.dart';

class MeetPickImageView extends StatefulWidget {
  const MeetPickImageView({Key? key}) : super(key: key);

  @override
  State<MeetPickImageView> createState() => _MeetPickImageViewState();
}

class _MeetPickImageViewState extends State<MeetPickImageView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(context.read<CreateEditMeetsController>().imagesList.isEmpty) {
      context.read<CreateEditMeetsController>().fetchMeetImages();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose an image',
            style: TextStyle(
                color: kDarkSecondaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height: 15,),

          Text(
            'Choose the image that describes your meet.',
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13
            ),
          ),

          const SizedBox(height: 15,),

          Consumer<CreateEditMeetsController>(
            builder: (context, data, child) {
              var images = data.imagesList;
              if(images.isEmpty) {
                return const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Fetching images...', style: TextStyle(fontSize: 15),),
                          SizedBox(height: 10,),
                          LoadingFallingDot(
                            color: kDarkSecondaryColor,
                            size: 40,
                          ),
                        ],
                      ),
                    )
                );
              }
              return Expanded(
                child: GridView.builder(
                  gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      repeatPattern: QuiltedGridRepeatPattern.same,
                      pattern: [const QuiltedGridTile(1, 1), const QuiltedGridTile(1, 1), const QuiltedGridTile(1, 1),]
                  ),
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async{
                        data.chooseImage(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              images[index],
                            ),
                            fit: BoxFit.cover
                          )
                        ),
                        child: data.meetImageIndex == index ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(Icons.check_circle_rounded, color: kPrimaryColor,)),
                        ) : null,
                      ),
                    );
                  },

                ),
              );
            }
          )
        ],
      ),
    );
  }
}