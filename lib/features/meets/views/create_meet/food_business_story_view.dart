import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/models/skibble_place.dart';
// import 'package:skibble/utils/story_page_view/story_page_view.dart';
import 'package:story/story_image.dart';
import 'package:story/story_page_view.dart';

class FoodBusinessStoryView extends StatefulWidget {
  const FoodBusinessStoryView({Key? key, required this.business}) : super(key: key);
  final SkibbleFoodBusiness business;

  @override
  State<FoodBusinessStoryView> createState() => _FoodBusinessStoryViewState();
}

class _FoodBusinessStoryViewState extends State<FoodBusinessStoryView> {

  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      child: widget.business.googlePlaceDetails!.placeImages!.isEmpty ?
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300
            ),
            child: Center(
                child: Icon(Iconsax.reserve, size: MediaQuery.of(context).size.height / 5, color: Colors.grey,)),
          ),

          Positioned(
              top: 40,
              left: 10,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close_rounded))
          )
        ],
      )
          :
      StoryPageView(
        indicatorAnimationController: indicatorAnimationController,
        showShadow: true,
        itemBuilder: (context, pageIndex, storyIndex) {
          // final user = sampleUsers[pageIndex];
          final story = widget.business.googlePlaceDetails!.placeImages![storyIndex];
          return Stack(
            children: [
              // Positioned.fill(
              //   child: Container(color: Colors.black),
              // ),
              Positioned.fill(
                  child: StoryImage(
                    /// key is required
                    key: ValueKey(story),
                    imageProvider: CachedNetworkImageProvider(
                      story,
                    ),
                    fit: BoxFit.cover,
                  )
              ),
            ],
          );
        },
        gestureItemBuilder: (context, pageIndex, storyIndex) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    icon: Icon(indicatorAnimationController.value == IndicatorAnimationCommand.pause ? Icons.play_arrow_rounded : Icons.pause_rounded ),
                    onPressed: () {
                      // Navigator.pop(context);
                      if(indicatorAnimationController.value == IndicatorAnimationCommand.pause) {
                        indicatorAnimationController.value = IndicatorAnimationCommand.resume;

                      }
                      else {
                        indicatorAnimationController.value = IndicatorAnimationCommand.pause;
                      }
                      setState(() {

                      });
                      // indicatorAnimationController.notifyListeners();
                    },
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 38),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    icon: Icon(Icons.close_rounded ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          );
        },
        pageLength: 1,
        // onAnimationControllerChanged: (controller) {},
        indicatorDuration: Duration(seconds: 8),
        storyLength: (int pageIndex) {
          return widget.business.googlePlaceDetails!.placeImages!.length;
        },
        onPageLimitReached: () {
          // Navigator.pop(context);
        },
        // durations: [List.generate(widget.business.googlePlaceDetails!.placeImages!.length, (index) => 8)],
      ),
    );
  }
}
