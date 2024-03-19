import 'package:flutter/material.dart';


enum CustomUnderlineIndicatorSize {
  tiny,
  normal,
  full,
}

class CustomUnderlineIndicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final CustomUnderlineIndicatorSize indicatorSize;

  const CustomUnderlineIndicator(
      {required this.indicatorHeight,
        required this.indicatorColor,
        required this.indicatorSize});

  @override
  _MD2Painter createBoxPainter([VoidCallback? onChanged]) {
    return new _MD2Painter(this, onChanged!);
  }
}

class _MD2Painter extends BoxPainter {
  final CustomUnderlineIndicator? decoration;

  _MD2Painter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration ? configuration) {
    assert(configuration != null);
    assert(configuration!.size != null);

    Rect? rect;
    if (decoration!.indicatorSize == CustomUnderlineIndicatorSize.full) {
      rect = Offset(offset.dx,
          (configuration!.size!.height - decoration!.indicatorHeight)) &
      Size(configuration.size!.width, decoration!.indicatorHeight);
    }
    else if (decoration!.indicatorSize == CustomUnderlineIndicatorSize.normal) {
      rect = Offset(offset.dx + 6,
          (configuration!.size!.height - decoration!.indicatorHeight)) &
      Size(configuration.size!.width - 12, decoration!.indicatorHeight);
    }

    else if (decoration!.indicatorSize == CustomUnderlineIndicatorSize.tiny) {
      rect = Offset(offset.dx + configuration!.size!.width / 2 - 8,
          (configuration.size!.height - decoration!.indicatorHeight)) &
      Size(16, decoration!.indicatorHeight);
    }

    final Paint paint = Paint();
    paint.color = decoration!.indicatorColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect!,
            topRight: Radius.circular(8), topLeft: Radius.circular(8)),
        paint);
  }
}
