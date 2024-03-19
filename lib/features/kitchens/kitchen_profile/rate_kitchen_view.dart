import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:skibble/utils/validators.dart';

import '../../../custom_icons/chef_icons_icons.dart';
import '../../../models/reviews_ratings.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/firebase/database/kitchens_database.dart';
import '../../../features/authentication/views/chef_auth/chef/chef_qualifications_details.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/custom_data.dart';


class RateKitchenView extends StatefulWidget {
  const RateKitchenView({Key? key, required this.user}) : super(key: key);
  final SkibbleUser user;

  @override
  State<RateKitchenView> createState() => _RateKitchenViewState();
}

class _RateKitchenViewState extends State<RateKitchenView> {

  late RatingAndReview ratingAndReview;
  late TextEditingController controller;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
    controller = TextEditingController();
    ratingAndReview = RatingAndReview(
      authorId: currentUser.userId,
      chefId: widget.user.userId,
      kitchenSkillsRating: CustomSharedData().kitchenSkillsRating(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,),
        title: Text('Rate Kitchen', style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
        actions: [
          TextButton(onPressed: () async{
            await rateKitchen();
          }, child: const Text('Done'))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(13)),
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: widget.user.userCustomColor,
                            image: widget.user.profileImageUrl != null ? DecorationImage(
                                image: CachedNetworkImageProvider(widget.user.profileImageUrl!),
                                fit: BoxFit.cover
                            ) : null
                        ),
                        //TODO: change to cachedImageProvider
                        child: widget.user.profileImageUrl == null ? const Center(
                            child: Icon(ChefIcons.chef_hat_dark_1, size: 24, color: kLightSecondaryColor,)) : null,
                      ),
                    ),

                    const SizedBox(width: 10,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.user.fullName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: CurrentTheme(context)
                                      .isDarkMode
                                      ? kLightSecondaryColor
                                      : kDarkSecondaryColor),),
                            const SizedBox(width: 5,),
                            const Icon(Iconsax.verify5, size: 15,
                              color: kPrimaryColor,)
                          ],
                        ),
                        const SizedBox(height: 3,),
                        Text('@${widget.user.userName!}',
                          style: const TextStyle(color: Colors
                              .grey, fontSize: 13),),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                const Text(
                  'Overall Rating',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),

                ),

                const SizedBox(height: 10,),


                Center(
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    unratedColor: Colors.grey.shade400,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star_rounded,
                      color: kPrimaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      ratingAndReview.overallRating = rating;
                    },
                  ),
                ),

                const SizedBox(height: 20,),


                const Text(
                  'Kitchen Ratings',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),

                ),
                const SizedBox(height: 10,),

                ProfileKitchenSkillsView(
                  skills: ratingAndReview.kitchenSkillsRating!,
                  ignoreGestures: false,
                  onRatingUpdate: (rating, index) {
                    ratingAndReview.kitchenSkillsRating![ratingAndReview.kitchenSkillsRating!.keys.toList()[index]] = rating;

                  },
                ),

                const SizedBox(height: 10,),

                const Text('Write a review', style: TextStyle(color: kPrimaryColor),),

                const SizedBox(height: 10,),


                TextFormField(
                  validator: (value) => Validator().validateText(value, 'Please enter a review to continue'),
                  maxLines: 5,
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: kPrimaryColor)
                    )
                  ),
                ),
                const SizedBox(height: 50,),

              ],
            ),
          ),
        ),
      ),
    );
  }

  rateKitchen() async{
    final form = _formKey.currentState;

    if(form!.validate()) {

      CustomDialog(context).showProgressDialog(context, 'Uploading your rating');
      int timePosted = DateTime.now().millisecondsSinceEpoch;
      ratingAndReview.reviewText = controller.text;
      ratingAndReview.timePosted = timePosted;

      var id = await KitchenDatabaseService().rateKitchen(ratingAndReview);

      if(id != null) {

        Navigator.pop(context);
        if(Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
      else {
        Navigator.pop(context);

        CustomDialog(context).showErrorDialog('Error', 'Unable to upload your rating');

      }
    }

    else {
    }
  }
}
