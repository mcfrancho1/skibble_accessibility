import 'package:flutter/material.dart';
import 'package:get/utils.dart';


class CustomExpandedText extends StatefulWidget {
  const CustomExpandedText({Key? key, required this.text, required this.onTapShowMore, required this.maxLength}) : super(key: key);
  final String text;
  final Function() onTapShowMore;
  final int maxLength;

  @override
  State<CustomExpandedText> createState() => _CustomExpandedTextState();
}

class _CustomExpandedTextState extends State<CustomExpandedText> {

   late final String firstHalf;
   late final String secondHalf;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.text.length > widget.maxLength) {
      firstHalf = widget.text.substring(0, 200);
      secondHalf = widget.text.substring(200, widget.text.length);
    }
    else {

    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.text.length > widget.maxLength ?
        Text(firstHalf, maxLines: widget.maxLength ~/ 40, overflow: TextOverflow.ellipsis,)
            :
        Text(widget.text),

        SizedBox(height: 10,),
        if(widget.text.length > widget.maxLength)
          GestureDetector(
            onTap: () => widget.onTapShowMore(),
            child: Text('Show more', style: TextStyle(decoration: TextDecoration.underline),))
      ],
    );
  }
}
