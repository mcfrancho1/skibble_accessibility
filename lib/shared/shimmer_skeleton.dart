import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({Key? key, this.width, this.height}) : super(key: key);

  final double? width;
  final double? height;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.04)
      ),
    );
  }
}
