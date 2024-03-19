import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skibble/utils/current_theme.dart';

class ShimmerEffect extends StatefulWidget {
  final Widget child;

  ShimmerEffect({required this.child});

  @override
  _ShimmerEffectState createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CurrentTheme(context).isDarkMode ? Colors.white.withOpacity(0.04)  : Colors.black.withOpacity(0.04),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: widget.child,

    );
  }
}
