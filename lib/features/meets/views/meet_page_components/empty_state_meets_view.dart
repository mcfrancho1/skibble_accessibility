import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyStateMeetsView extends StatelessWidget {
  const EmptyStateMeetsView({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/custom_icons/empty_meets.svg',
          height: 200,
          width: 200,
        ),

        const SizedBox(height: 10,),

        Text(
          message,
          style: const TextStyle(color: Colors.grey),
        ),

      ],
    );
  }
}
