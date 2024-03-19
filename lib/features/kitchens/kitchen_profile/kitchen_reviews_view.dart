import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/reviews_ratings.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/shared/profile_future.dart';
import 'package:skibble/features/authentication/views/chef_auth/chef/chef_qualifications_details.dart';
import 'package:skibble/features/discover/chef_profile/rate_chef_view.dart';
import 'package:skibble/features/kitchens/kitchen_profile/rate_kitchen_view.dart';
import 'package:skibble/utils/helper_methods.dart';

import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/firebase/database/kitchens_database.dart';
import '../../../shared/rating_rod.dart';
import '../../../shared/read_more_text.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';

class KitchenReviewsView extends StatefulWidget {
  const KitchenReviewsView({Key? key, required this.user}) : super(key: key);
  final SkibbleUser user;

  @override
  State<KitchenReviewsView> createState() => _KitchenReviewsViewState();
}

class _KitchenReviewsViewState extends State<KitchenReviewsView> {

  Future? ratingsAndReviewsFuture;
  @override
  void initState() {
    // TODO: implement initState

    ratingsAndReviewsFuture = KitchenDatabaseService().getAllRatingsAndReviews(widget.user.userId!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var currentUser = Provider.of<AppData>(context).skibbleUser!;



    return  Builder(
        builder: (context) {
          return SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: FutureBuilder(
                    future: ratingsAndReviewsFuture,
                    builder: (context, snapshot) {
                      switch(snapshot.connectionState) {

                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          // TODO: Handle this case.
                          return Container();

                        case ConnectionState.active:
                        case ConnectionState.done:
                        var ratingsAndReviewsList = snapshot.data as List<RatingAndReview>;

                        return Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Rate this kitchen',
                                    style: TextStyle(
                                        fontFamily: 'Brand Regular',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18
                                    ),
                                  ),
                                  const SizedBox(height: 6,),
                                  const Text('See what other people are saying about this kitchen',
                                    style: TextStyle(
                                        fontFamily: 'Nunito Regular',
                                        fontSize: 13),),
                                  const SizedBox(height: 20,),

                                  Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RateKitchenView(user: widget.user,))),
                                        child: const Text('Rate Kitchen')),
                                  ),

                                  const Text(
                                    'Kitchen Ratings',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),

                                  ),
                                  const SizedBox(height: 10,),

                                  ProfileKitchenSkillsView(
                                    skills: widget.user.kitchen!.kitchenSkillsRating!,
                                    ignoreGestures: true,
                                    onRatingUpdate: (rating, index) {
                                      // widget.user.kitchen!.kitchenSkillsRating![widget.user.kitchen!.kitchenSkillsRating!.keys.toList()[index]] = rating;

                                    },
                                  ),

                                  const SizedBox(height: 10,),



                                  const SizedBox(height: 20,),
                                  const Text(
                                    'Overall Ratings',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18
                                    ),

                                  ),

                                  const SizedBox(height: 20,),

                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${(widget.user.kitchen!.averageRatings!).toStringAsFixed(1)}',
                                              style: const TextStyle(fontSize: 45),),
                                            RatingBarIndicator(
                                              rating: widget.user.kitchen!.averageRatings!.toDouble(),
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    color: kPrimaryColor,),
                                              itemCount: 5,
                                              itemSize: 20.0,
                                              direction: Axis.horizontal,
                                            ),

                                            Text('(${widget.user.kitchen!.totalRatings})',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'Brand Regular'
                                              ),)
                                          ],
                                        ),


                                        Column(
                                          children: [
                                            RatingRod(
                                              ratingNumber: '5',
                                              totalNumberOfRatings: widget.user.kitchen!.totalRatings!,
                                              totalGroupRating: widget.user.kitchen!.ratingGroup!['5']!.toInt(),
                                            ),

                                            RatingRod(
                                              ratingNumber: '4',
                                              totalNumberOfRatings: widget.user.kitchen!.totalRatings!,
                                              totalGroupRating: widget.user.kitchen!.ratingGroup!['4']!.toInt(),
                                            ),

                                            RatingRod(
                                              ratingNumber: '3',
                                              totalNumberOfRatings: widget.user.kitchen!.totalRatings!,
                                              totalGroupRating: widget.user.kitchen!.ratingGroup!['3']!.toInt(),
                                            ),

                                            RatingRod(
                                              ratingNumber: '2',
                                              totalNumberOfRatings: widget.user.kitchen!.totalRatings!,
                                              totalGroupRating: widget.user.kitchen!.ratingGroup!['2']!.toInt(),
                                            ),

                                            RatingRod(
                                              ratingNumber: '1',
                                              totalNumberOfRatings: widget.user.kitchen!.totalRatings!,
                                              totalGroupRating: widget.user.kitchen!.ratingGroup!['1']!.toInt(),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 40,),

                                  ratingsAndReviewsList.isNotEmpty ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Customer Reviews',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18
                                        ),

                                      ),

                                      const SizedBox(height: 20,),


                                      //a review and rating
                                      if(ratingsAndReviewsList.isNotEmpty)
                                        Column(
                                            children: List.generate(ratingsAndReviewsList.length, (index) => Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [

                                                // Row(
                                                //   children: [
                                                //     CircleAvatar(
                                                //       child: Icon(Icons.person,
                                                //         color: Colors.white,),
                                                //       backgroundColor: Colors.grey.withOpacity(0.3),
                                                //     ),
                                                //     SizedBox(width: 10,),
                                                //     Text(
                                                //       'Mbonu, Chinemerem Francis',
                                                //       style: TextStyle(
                                                //           fontFamily: 'Brand Regular'),)
                                                //   ],
                                                // ),

                                                UserProfileFuture(
                                                  userId: ratingsAndReviewsList[index].authorId!,
                                                  hasFuture: false,
                                                  showName: true,
                                                  isDoubleLine: false,
                                                  user: ratingsAndReviewsList[index].authorId! == currentUser.userId? currentUser : null,

                                                ),

                                                const SizedBox(height: 10,),

                                                Row(
                                                  children: [
                                                    RatingBarIndicator(
                                                      rating: ratingsAndReviewsList[index].overallRating!.toDouble(),
                                                      itemBuilder: (context,
                                                          index) =>
                                                          const Icon(
                                                            Icons.star_rounded,
                                                            color: kPrimaryColor,),
                                                      itemCount: 5,
                                                      itemSize: 15.0,
                                                      direction: Axis.horizontal,
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    //DateFormat('M/d/y')
                                                    Text(
                                                      '${HelperMethods().formatFeedTimeStamp(ratingsAndReviewsList[index].timePosted!)}',
                                                      style: const TextStyle(
                                                          fontFamily: 'Brand Regular',
                                                          color: Colors.grey
                                                      ),),


                                                  ],
                                                ),

                                                const SizedBox(height: 10,),
                                                ExpandableText(
                                                  '${ratingsAndReviewsList[index].reviewText}',
                                                  expandText: 'show more',
                                                  collapseText: 'show less',
                                                  maxLines: 3,

                                                  linkColor: kPrimaryColor,
                                                  animation: true,
                                                  collapseOnTextTap: true,
                                                  style: TextStyle(fontSize: 15, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
                                                  // prefixText: '${widget.skibAuthor!.userName == null ? '' : widget.skibAuthor!.userName}',
                                                  // onPrefixTap: () => showProfile(username),
                                                  prefixStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
                                                  // onHashtagTap: (name) => showHashtag(name),
                                                  // hashtagStyle: TextStyle(
                                                  //   color: Color(0xFF30B6F9),
                                                  // ),
                                                  // onMentionTap: (username) => showProfile(username),
                                                  // mentionStyle: TextStyle(
                                                  //   fontWeight: FontWeight.w600,
                                                  // ),
                                                  //onUrlTap: (url) => launchUrl(url),
                                                  // urlStyle: TextStyle(
                                                  //   decoration: TextDecoration.underline,
                                                  // ),
                                                ),

                                                const SizedBox(height: 20,)
                                              ],
                                            ))
                                        )
                                    ],
                                  ) : Container()
                                ],
                              ),
                            ));
                      }

                    }
                  ),
                ),
                ],
            ),
          );
          }
      );
    }
  }
