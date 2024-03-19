import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoContentView extends StatelessWidget {
  const NoContentView({Key? key, this.imagePath, required this.message}) : super(key: key);
  final String? imagePath;
  final String message;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 100),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  imagePath != null && imagePath!.isNotEmpty ? imagePath! : 'assets/images/coconut.svg',
                  width: 120,
                  height: 120,
                  color: Colors.grey,
                ),
                // Container(
                //   height: 120,
                //   width: 120,
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage(
                //         imagePath
                //       ),
                //       fit: BoxFit.cover
                //     )
                //   ),
                // ),
                SizedBox(height: 10,),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),),
              ],
            )),
      ),
    );
  }
}