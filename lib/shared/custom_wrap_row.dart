import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skibble/utils/constants.dart';

class MenuBar extends StatelessWidget {
  MenuBar({
    required this.onItemPressed,
    required this.children,
    this.minItemWidth = 110,
    this.minMoreItemsWidth = 70,
    Key? key,
  }) : super(key: key);

  final ValueChanged<int> onItemPressed;
  final List<MenuBarItem> children;
  final double minItemWidth;
  final double minMoreItemsWidth;

  static int tmpStartIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CollapsibleMenuBar(
      onCollapseIndex: (int startIndex) {
        if (tmpStartIndex == startIndex) {
          return;
        }
        tmpStartIndex = startIndex;
      },
      minItemWidth: minItemWidth,
      minMoreItemsWidth: minMoreItemsWidth,
      children: [
        ...children,
        PopupMenuButton(
          offset: const Offset(0, 40),
          color: Colors.red,
          child: Container(
            height: 40,
              padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius
                  .circular(20),
              border: Border.all(
                  color: kPrimaryColor),
              // color: kPrimaryColor
            ),
            alignment: Alignment.center,
            child: Text("More",
              style: TextStyle(fontSize: 13,
                  color: kPrimaryColor),),

          ),
          itemBuilder: (_) => children
              .sublist(tmpStartIndex)
              .map((e) => PopupMenuItem(child: e))
              .toList(),
        ),
      ],
    );
  }
}

///
///
///
class MenuBarItem extends StatelessWidget {
  const MenuBarItem({
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius
              .circular(20),
          border: Border.all(
              color: kPrimaryColor),
          // color: kPrimaryColor
        ),
        child: Text(text,
          style: TextStyle(fontSize: 13,
              color: kPrimaryColor),)
    );
  }
}

///
///
///
class CollapsibleMenuBar extends MultiChildRenderObjectWidget {
  CollapsibleMenuBar({
    required this.onCollapseIndex,
    required List<Widget> children,
    required this.minItemWidth,
    required this.minMoreItemsWidth,
    Key? key,
  }) : super(key: key, children: children);

  final ValueChanged<int> onCollapseIndex;
  final double minItemWidth;
  final double minMoreItemsWidth;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCollapsibleMenuBar(
      onCollapseIndex,
      minItemWidth,
      minMoreItemsWidth,
    );
  }
}

///
///
///
class CollapsibleMenuBarParentData extends ContainerBoxParentData<RenderBox> {}

///
///
///
class RenderCollapsibleMenuBar extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CollapsibleMenuBarParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            CollapsibleMenuBarParentData> {
  RenderCollapsibleMenuBar(
      this.onCollapseIndex,
      this.minItemWidth,
      this.minMoreItemsWidth,
      );

  final ValueChanged<int> onCollapseIndex;
  final double minItemWidth;
  final double minMoreItemsWidth;

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CollapsibleMenuBarParentData) {
      child.parentData = CollapsibleMenuBarParentData();
    }
  }

  @override
  void performLayout() {
    // Make width of children equal.
    final double childWidth = max(
      constraints.maxWidth / (childCount - 1),
      minItemWidth,
    );

    double totalWidth = 0;
    double totalHeight = 0;

    RenderBox? child = firstChild;
    Offset childOffset = Offset(0, 0);

    int childIdx = 0;

    while (child != null && child != lastChild) {
      CollapsibleMenuBarParentData childParentData =
      child.parentData as CollapsibleMenuBarParentData;

      // Set child's dimension.
      child.layout(
        BoxConstraints(
          minWidth: childWidth,
          maxWidth: childWidth,
          maxHeight: constraints.maxHeight,
        ),
        parentUsesSize: true,
      );

      // If the total width exceeds the max screen width,
      // display "more" item.
      if (totalWidth + child.size.width > constraints.maxWidth) {
        // Set overflow item dimension to 0.
        child.layout(
          BoxConstraints(
            minWidth: 0,
            maxWidth: 0,
            maxHeight: constraints.maxHeight,
          ),
          parentUsesSize: true,
        );

        // Get popup menu item.
        child = lastChild!;
        childParentData = child.parentData as CollapsibleMenuBarParentData;
        // Set popup menu item's dimension. Will cover the remaining width.
        child.layout(
          BoxConstraints(
            minWidth: constraints.maxWidth - totalWidth,
            maxWidth: constraints.maxWidth - totalWidth,
            maxHeight: constraints.maxHeight,
          ),
          parentUsesSize: true,
        );
      }

      if (child == lastChild) {
        // If "more" item's width is below threshold, hide left item.
        if (child.size.width <= minMoreItemsWidth) {
          childIdx--;
          RenderBox nthChild = getChildrenAsList()[childIdx];

          // Hide left item of "more" item.
          totalWidth -= nthChild.size.width;
          childOffset -= Offset(nthChild.size.width, 0);
          nthChild.layout(
            BoxConstraints(
              minWidth: 0,
              maxWidth: 0,
              maxHeight: constraints.maxHeight,
            ),
            parentUsesSize: true,
          );

          // Resize "more" item.
          child.layout(
            BoxConstraints(
              minWidth: constraints.maxWidth - totalWidth,
              maxWidth: constraints.maxWidth - totalWidth,
              maxHeight: constraints.maxHeight,
            ),
            parentUsesSize: true,
          );
        }

        // Update the start index of children to be displayed
        // in "more" items.
        onCollapseIndex(childIdx);
      }

      totalWidth += child.size.width;
      totalHeight = max(totalHeight, child.size.height);

      childParentData.offset = Offset(childOffset.dx, 0);
      childOffset += Offset(child.size.width, 0);

      if (child != lastChild) {
        childIdx++;
      }
      child = childParentData.nextSibling;
    }

    // If all children is displayed except for "more" item.
    if (childIdx == childCount - 1) {
      // Set the layout of popup button to size 0.
      lastChild!.layout(BoxConstraints(
        minWidth: 0,
        maxWidth: 0,
        maxHeight: constraints.maxHeight,
      ));
    }

    size = Size(totalWidth, totalHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}