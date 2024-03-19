import 'package:flutter/material.dart';

class LocationIssuesView extends StatelessWidget {
  final String message;

  LocationIssuesView({required this.message});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // color: Colors.white,
        child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //TODO: Add Image
                Center(child: Icon(Icons.location_disabled, size: 50,),),
                SizedBox(height: 20,),
                Center(
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)),

              ],
            )
        ),
      ),
    );
  }
}
