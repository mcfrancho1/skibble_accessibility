import 'package:badges/badges.dart' as badge;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/feed_controller.dart';
import 'package:skibble/utils/constants.dart';
import '../services/change_data_notifiers/app_data.dart';


///This is a custom bottom tab bar with max. number of 4 items
///There must be a notch and floating action button at the center of the bar
class CurvedFlashyTabBar extends StatefulWidget {
  final int? selectedIndex;
  final double? height;

  final double? iconSize;
  final Color? backgroundColor;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final String? newMessagesCount;

  final NotchedShape? shape;
  final Clip? clipBehavior;
  final double? notchMargin;
  final double? elevation;

  final Color? color;



  final List<FlashyTabBarItem>? items;
  final ValueChanged<int>? onItemSelected;

  CurvedFlashyTabBar({Key? key,
    this.selectedIndex = 0,
    this.height = 50,
    this.iconSize = 20,
    this.newMessagesCount = '0',
    this.color,
    this.shape,
    this.clipBehavior = Clip.none,
    this.notchMargin = 4.0,
    this.elevation,

    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 170),
    this.animationCurve = Curves.linear,
    required this.items,
    required this.onItemSelected,
  }) :
    assert(elevation == null || elevation >= 0.0),
    assert(notchMargin != null),
    assert(clipBehavior != null),
    assert(items != null),
    assert(height! >= 50 && height <= 100),
    assert(items!.length == 5),
    assert(onItemSelected != null),
      super(key: key);


  @override
  State<CurvedFlashyTabBar> createState() => _CurvedFlashyTabBarState();
}

class _CurvedFlashyTabBarState extends State<CurvedFlashyTabBar> {

  late ValueListenable<ScaffoldGeometry> geometryListenable;
  final GlobalKey materialKey = GlobalKey();
  static const double _defaultElevation = 8.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geometryListenable = Scaffold.geometryOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final BottomAppBarTheme babTheme = BottomAppBarTheme.of(context);
    final NotchedShape? notchedShape = widget.shape ?? babTheme.shape;
    final CustomClipper<Path> clipper = notchedShape != null
        ? _FlashyTabBarClipper(
      geometry: geometryListenable,
      shape: notchedShape,
      materialKey: materialKey,
      notchMargin: widget.notchMargin!,
    )
        : const ShapeBorderClipper(shape: RoundedRectangleBorder());
    final double elevation = widget.elevation ?? babTheme.elevation ?? _defaultElevation;
    final Color color = widget.color ?? babTheme.color ?? Theme.of(context).bottomAppBarColor;
    final Color effectiveColor = ElevationOverlay.applyOverlay(context, color, elevation);
    final bg = (widget.backgroundColor == null)
        ? Theme.of(context).bottomAppBarColor
        : widget.backgroundColor;

    Size size = MediaQuery.of(context).size;

    return PhysicalShape(
      clipper: clipper,
      elevation: elevation,
      color: effectiveColor,
      clipBehavior: widget.clipBehavior!,
      child: Material(
        key: materialKey,
        type: MaterialType.transparency,
        child: SafeArea(
          child: Container(
            width: size.width,
            height: widget.height,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onItemSelected!(0);
                    if(0 == widget.selectedIndex)
                      context.read<FeedController>().scrollToTop();
                  },
                  child:
                  _FlashTabBarItem(
                    item: widget.items![0],
                    tabBarHeight: widget.height!,
                    iconSize: widget.iconSize!,
                    isSelected: 0 == widget.selectedIndex,
                    backgroundColor: bg!,
                    animationDuration: widget.animationDuration!,
                    animationCurve: widget.animationCurve!,
                  ),
                ),


                GestureDetector(
                  onTap: () => widget.onItemSelected!(1),
                  child:
                  _FlashTabBarItem(
                    item: widget.items![1],
                    tabBarHeight: widget.height!,
                    newMessagesCount: widget.newMessagesCount,
                    iconSize: widget.iconSize!,
                    isSelected: 1 == widget.selectedIndex,
                    backgroundColor: bg,
                    animationDuration: widget.animationDuration!,
                    animationCurve: widget.animationCurve!,
                  )
                ),
                GestureDetector(
                  onTap: () => widget.onItemSelected!(2),
                  child: _FlashTabBarItem(
                    item: widget.items![2],
                    tabBarHeight: widget.height!,
                    iconSize: widget.iconSize!,
                    isSelected:  2 == widget.selectedIndex,
                    backgroundColor: bg,
                    animationDuration: widget.animationDuration!,
                    animationCurve: widget.animationCurve!,
                  ),
                ),

                GestureDetector(
                  onTap: () => widget.onItemSelected!(3),
                  child:
                  _FlashTabBarItem(
                    item: widget.items![3],
                    tabBarHeight: widget.height!,
                    iconSize: widget.iconSize!,
                    isSelected: 3 == widget.selectedIndex,
                    backgroundColor: bg,
                    animationDuration: widget.animationDuration!,
                    animationCurve: widget.animationCurve!,
                  ),
                ),

                GestureDetector(
                  onTap: () => widget.onItemSelected!(4),
                  child:
                  _FlashTabBarItem(
                    item: widget.items![4],
                    tabBarHeight: widget.height!,
                    iconSize: widget.iconSize!,
                    isSelected: 4 == widget.selectedIndex,
                    backgroundColor: bg,
                    animationDuration: widget.animationDuration!,
                    animationCurve: widget.animationCurve!,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlashyTabBarItem {
  final Icon? icon;
  final Text? title;
  // final int index;
  final String? avatarImage;
  Color activeColor;
  Color inactiveColor;

  FlashyTabBarItem({
    this.icon,
    this.avatarImage,
    required this.title,
    //required this.index,
    this.activeColor = kPrimaryColor,
    this.inactiveColor = const Color(0xff9496c1),
  }) {
    // assert(icon != null);
    assert(title != null);
  }
}

class _FlashTabBarItem extends StatelessWidget {
  final double? tabBarHeight;
  final double? iconSize;

  final FlashyTabBarItem? item;
  final String? newMessagesCount;

  final bool? isSelected;
  final Color? backgroundColor;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const _FlashTabBarItem(
      {Key? key,
        required this.item,
        required this.isSelected,
        required this.tabBarHeight,
        required this.backgroundColor,
        required this.animationDuration,
        required this.animationCurve,
        this.newMessagesCount = '0',
        required this.iconSize})
      : assert(isSelected != null),
        assert(item != null),
        assert(backgroundColor != null),
        assert(animationDuration != null),
        assert(animationCurve != null),
        assert(iconSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AppData>(context).skibbleUser!;
    return Container(
        color: backgroundColor,
        height: double.maxFinite,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedAlign(
              duration: animationDuration!,
              child: AnimatedOpacity(
                  opacity: isSelected! ? 0.0 : 1.0,
                  duration: animationDuration!,
                  child: item!.icon != null ? IconTheme(
                    data: IconThemeData(
                        size: iconSize,
                        color: isSelected!
                            ? item!.activeColor.withOpacity(1)
                            : item!.inactiveColor ),
                    child: newMessagesCount == "0" ? item!.icon!
                        :
                    Badge(
                      label: Text(
                        '$newMessagesCount',
                        style: TextStyle(
                          fontSize: 10.7,
                          color: kLightSecondaryColor
                        ),),
                      backgroundColor: kPrimaryColor,
                      child: item!.icon!,),
                  )
                      :
                      user.profileImageUrl != null ?

                      Container(
                        width: 23.5,
                        height: 23.5,
                        child: ExtendedImage.network(
                          user.profileImageUrl!,
                          width: 23.5,
                          height: 23.5,
                          fit: BoxFit.cover,
                          cache: true,

                          border: Border.all(
                              color: user.userCustomColor!, width: 1.0),
                          shape: BoxShape.circle,
                          loadStateChanged: (ExtendedImageState state) {
                            switch (state.extendedImageLoadState) {
                              case LoadState.loading:
                                // _controller.reset();
                                return Container(
                                  width: 23.5,
                                  height: 23.5,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: user.userCustomColor,
                                      border: Border.all(color: kPrimaryColor)
                                  ),
                                );

                            ///if you don't want override completed widget
                            ///please return null or state.completedWidget
                            //return null;
                            //return state.completedWidget;
                              case LoadState.completed:
                                // _controller.forward();
                                return state.completedWidget;
                                //   ExtendedRawImage(
                                //   image: state.extendedImageInfo?.image,
                                // );
                                // break;
                              case LoadState.failed:
                                // _controller.reset();
                                return GestureDetector(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/failed.jpg",
                                        fit: BoxFit.fill,
                                      ),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Text(
                                          "",
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    state.reLoadImage();
                                  },
                                );
                            }
                          },
                          // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          //cancelToken: cancellationToken,
                        )
                        ///
                        // CachedNetworkImage(
                        //   imageUrl: user.profileImageUrl!,
                        //   memCacheWidth: 76,
                        //   memCacheHeight: 76,
                        //   // width: 25,
                        //   // height: 25,
                        //   imageBuilder: (context, imageProvider) {
                        //     return Container(
                        //       width: 25,
                        //       height: 25,
                        //       decoration: BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           image: DecorationImage(
                        //               image: imageProvider,
                        //             fit: BoxFit.cover
                        //           )
                        //       ),
                        //     );
                        //   },
                        // ),

                        ///
                        // Container(
                        //   width: 25,
                        //   height: 25,
                        //   decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //
                        //       image: DecorationImage(
                        //           image: CachedNetworkImageProvider(user.profileImageUrl!),
                        //         fit: BoxFit.cover
                        //       )
                        //   ),
                        // ),
                        // decoration: BoxDecoration(
                        //   shape: BoxShape.circle,
                        //   color: user.userCustomColor != null ? user.userCustomColor : kPrimaryColor,
                        //   border: Border.all(color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kPrimaryColor)
                        // ),
                      )
                          :
                      Container(
                        width: 23.5,
                        height: 23.5,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade300,
                            // border: Border.all(color: kPrimaryColor)
                        ),

                        child: Center(
                          child: Container(
                            width: 25,
                            height: 25,
                            alignment: Alignment.center,
                            // padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Icon(CupertinoIcons.person_solid, size: 14, color: kPrimaryColor,)),
                          ),
                        ),
                      )

                  // CircleAvatar(
                  //   radius: 15,
                  //   backgroundImage: AssetImage('assets/images/avatar_1.png'),
                  // )
              ),
              alignment: isSelected! ? Alignment.topCenter : Alignment.center,
            ),
            AnimatedPositioned(
              curve: animationCurve!,
              duration: animationDuration!,

              top: isSelected! ? -2 * iconSize! : tabBarHeight! / 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: iconSize,
                    height: iconSize,
                  ),
                  CustomPaint(
                    child: SizedBox(
                      width: 80,
                      height: iconSize,
                    ),
                    painter: _CustomPath(backgroundColor!),
                  )
                ],
              ),
            ),
            AnimatedAlign(
                alignment: isSelected! ? Alignment.center : Alignment.bottomCenter,
                duration: animationDuration!,
                curve: animationCurve!,
                child: AnimatedOpacity(
                    opacity: isSelected! ? 1.0 : 0.0,
                    duration: animationDuration!,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        color: item!.activeColor,
                        fontWeight: FontWeight.bold,
                      ),
                      child: item!.title!,
                    ))),
            Positioned(
                bottom: 0,
                child: CustomPaint(
                  child: SizedBox(
                    width: 90,
                    height: iconSize,
                  ),
                  painter: _CustomPath(backgroundColor!),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                  duration: animationDuration!,
                  opacity: isSelected! ? 1.0 : 0.0,
                  child: Container(
                    width: 5,
                    height: 5,
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: item!.activeColor,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  )),
            )
          ],
        )
    );
  }
}

class _CustomPath extends CustomPainter {
  final Color? backgroundColor;

  _CustomPath(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, 0);
    path.lineTo(0, 2.0 * size.height);
    path.lineTo(1.0 * size.width, 2.0 * size.height);
    path.lineTo(1.0 * size.width, 1.0 * size.height);
    path.lineTo(0, 0);
    path.close();

    paint.color = backgroundColor!;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class _FlashyTabBarClipper extends CustomClipper<Path> {
  const _FlashyTabBarClipper({
    required this.geometry,
    required this.shape,
    required this.materialKey,
    required this.notchMargin,
  }) : assert(geometry != null),
        assert(shape != null),
        assert(notchMargin != null),
        super(reclip: geometry);

  final ValueListenable<ScaffoldGeometry>? geometry;
  final NotchedShape? shape;
  final GlobalKey? materialKey;
  final double? notchMargin;

  // Returns the top of the BottomAppBar in global coordinates.
  double get bottomNavigationBarTop {
    final RenderBox? box = materialKey!.currentContext ?.findRenderObject() as RenderBox?;
    return box?.localToGlobal(Offset.zero).dy ?? 0;
  }

  @override
  Path getClip(Size size) {
    // button is the floating action button's bounding rectangle in the
    // coordinate system whose origin is at the appBar's top left corner,
    // or null if there is no floating action button.
    final Rect? button = geometry!.value.floatingActionButtonArea?.translate(0.0, bottomNavigationBarTop * -1.0);
    return shape!.getOuterPath(Offset.zero & size, button?.inflate(notchMargin!));
  }

  @override
  bool shouldReclip(_FlashyTabBarClipper oldClipper) {
    return oldClipper.geometry != geometry
        || oldClipper.shape != shape
        || oldClipper.notchMargin != notchMargin;
  }
}
