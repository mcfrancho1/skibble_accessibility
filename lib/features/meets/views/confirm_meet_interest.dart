import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/food_spot.dart';
import 'package:skibble/services/change_data_notifiers/food_spots_data/spots_data.dart';
import 'package:skibble/services/firebase/database/food_spots_database/meal_invites_database.dart';
import 'package:skibble/utils/constants.dart';

import '../../../services/change_data_notifiers/app_data.dart';


class ConfirmMeetInterestView extends StatefulWidget {
  const ConfirmMeetInterestView({Key? key, required this.spot}) : super(key: key);
  final FoodSpot spot;

  @override
  State<ConfirmMeetInterestView> createState() => _ConfirmMeetInterestViewState();
}

class _ConfirmMeetInterestViewState extends State<ConfirmMeetInterestView> {

  //used to track the button
  bool _isRequesting = false;
  String? status;
  late Future? interestedFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
    interestedFuture = MealInviteDatabase().getUserSpotStatus(widget.spot, currentUser).then((value) {
      status = value;
      return value;
    });

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: interestedFuture,
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {

            case ConnectionState.none:
            case ConnectionState.waiting:
              return SizedBox(
                height: 200,
                child: SpinKitCircle(
                  color: kDarkSecondaryColor,
                  size: 40,
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasData) {
                return SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0,),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Confirm Interest',
                          style: TextStyle(color: kDarkSecondaryColor,fontSize: 18, fontWeight: FontWeight.bold),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                          child: Text(
                            'Click the button below to confirm your interest in this meal invite',
                            style: TextStyle(color: kDarkSecondaryColor,fontSize: 14),
                          ),
                        ),

                        Divider(),
                        GestureDetector(
                          onTap: () => context.read<SpotsData>().showCurrentSpotInfo(context, item: widget.spot),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              DateFormat('MMM').format(DateTime.fromMillisecondsSinceEpoch(widget.spot.spotDateTime)).toUpperCase(),
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),

                                            Text(
                                              DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch(widget.spot.spotDateTime)),
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10,),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.spot.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                                        SizedBox(height: 4,),
                                        Text('By ${widget.spot.host.fullName}', style: TextStyle(fontSize: 13, color: Colors.grey),),
                                      ],
                                    ),
                                  ],
                                ),

                                // Icon(Icons.arrow_forward_ios_rounded, color: kPrimaryColor,)
                              ],
                            ),
                          ),
                        ),

                        Divider(),

                        ElevatedButton(
                          onPressed: status == 'null' ? () async{await showInterest();}
                              :
                          null,
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: !isAlreadyInterested ? kPrimaryColor : Colors.grey.shade300,
                              padding: status == 'null' ? null :  EdgeInsets.symmetric(horizontal: 20),
                              disabledBackgroundColor: status == 'interested' ? Colors.grey.shade300 : Colors.green.shade50
                          ),
                          child: _isRequesting ? SizedBox(
                            width: 130,
                            child: SpinKitFadingCircle(
                              color: kContentColorLightTheme,
                              size: 30,
                            ),
                          )
                              :
                          status == 'interested' ?
                          Text("Waiting for Host", style: TextStyle(color: Colors.grey),)
                              :
                          status == 'invited' ?
                          Text("You're Invited", style: TextStyle(color: kPrimaryColor),)
                              :
                          Text("Yes, I am interested"),
                        ),

                        SizedBox(height: 30,),

                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox(
                height: 200,
                child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Oops! Something went wrong', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        SizedBox(height: 4,),
                        Text('Try again later..')
                      ],
                    )),
              );
              }
          }
        });
  }


  showInterest() async{
    setState(() {
      _isRequesting = true;
    });
    var res = await MealInviteDatabase().showUserInterest(widget.spot, context.read<AppData>().skibbleUser!);

    if(res) {
      setState(() {
        _isRequesting = false;
        status = 'interested';
      });
    }
  }
}

class InterestButton extends StatefulWidget {
  const InterestButton({Key? key}) : super(key: key);

  @override
  State<InterestButton> createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

