import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_mail_app/open_mail_app.dart';

import '../../../../utils/constants.dart';

class ConfirmEmailView extends StatefulWidget {
  final String? email;

  ConfirmEmailView({this.email});

  @override
  _ConfirmEmailViewState createState() => _ConfirmEmailViewState();
}

class _ConfirmEmailViewState extends State<ConfirmEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
              margin: EdgeInsets.only(top: 80, left: 80, right: 80, bottom: 30),
              child: Image.asset('assets/images/email-2.png')
          ),
          Center(child: Text('Check your Email', style: TextStyle(fontSize: 30),)),

          SizedBox(height: 20,),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'We have sent a password recovery instructions to your email ${widget.email == null ? '': widget.email}. Please click on the link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                backgroundColor: kPrimaryColor,
                textStyle: TextStyle(color: Colors.white,),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                        width: 1,
                        color: Colors.redAccent
                    )
                ),
              ),

              onPressed: () async{

                var result = await OpenMailApp.openMailApp();

                //show error if no mail apps found on device.
                if (!result.didOpen && !result.canOpen) {
                  showNoMailAppsDialog(context);


                } else if (!result.didOpen && result.canOpen) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return MailAppPickerDialog(
                        mailApps: result.options,
                      );
                    },
                  );
                }

              },
              child: Text('Open Email App', style: TextStyle(fontSize: 20 ),),
            ),
          ),
          SizedBox(height: 80,),
          Center(
            child: Text('Did not receive the email? Check your spam filter', style: TextStyle(color: Colors.grey),),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('or', style: TextStyle(color: Colors.grey),),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('try another email address.'))
            ],
          )
        ],
      ),
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
