import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:skibble/models/food_spot.dart';
import 'package:skibble/services/firebase/database/food_spots_database/meal_invites_database.dart';

import '../../../models/meal_invite.dart';

///
/// This is based on the new mapbox package for flutter. The code here will be reused in the future

// class ConnectData extends OnPointAnnotationClickListener with ChangeNotifier{
//   MapboxMap? _mapboxMap;
//   PointAnnotationManager? _pointAnnotationManager;
//   final _pageController = PageController();
//   PageController get pageController => _pageController;
//
//
//
//   int? activeMarkerIndex;
//   List<FoodSpot> spots = [];
//   var markers = <PointAnnotationOptions>[];
//
//   onCreateMap(MapboxMap mapboxMap) async{
//     _mapboxMap = mapboxMap;
//
//     _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));
//     _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
//     _mapboxMap?.gestures.updateSettings(GesturesSettings(
//         rotateEnabled: false,
//         scrollEnabled:  true,
//         scrollMode: ScrollMode.HORIZONTAL_AND_VERTICAL
//     ));
//    await createAnnotations();
//   }
//
//   MapboxMap get mapboxMap => _mapboxMap!;
//   PointAnnotationManager get pointAnnotationManager => _pointAnnotationManager!;
//
//
//   void updateActiveMarkerIndex(int newIndex) {
//     activeMarkerIndex = newIndex;
//     notifyListeners();
//   }
//
//   // void updateConnectMarker(int index, FoodSpot spot) {
//   //   connectMarkers[index] = spot;
//   //   notifyListeners();
//   // }
//
//   @override
//   void onPointAnnotationClick(PointAnnotation annotation) {
//     // TODO: implement onPointAnnotationClick
//     print("onAnnotationClick, id: ${annotation.id}");
//     var index = markers.indexWhere((element) => element.geometry == annotation.geometry);
//     _pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.bounceInOut,
//     );
//     notifyListeners();
//   }
//
//
//   createAnnotations() async{
//     spots = await MealInviteDatabase().getSpots();
//     final ByteData fire_bytes = await rootBundle.load('assets/icons/fire-station.png');
//     final Uint8List list = fire_bytes.buffer.asUint8List();
//     _mapboxMap?.annotations.createPointAnnotationManager().then((value) async {
//       _pointAnnotationManager = value;
//       // createOneAnnotation(list);
//
//       spots.forEach((spot) {markers.add(PointAnnotationOptions(
//         geometry: Point(coordinates: Position( spot.location.addressGeoPoint!.longitude, spot.location.addressGeoPoint!.latitude,)).toJson(),
//         image: list,
//         iconSize: 0.9,
//       ),);
//       });
//       // var options = <PointAnnotationOptions>[
//       //   PointAnnotationOptions(
//       //     geometry: Point(coordinates: Position( -63.138434, 46.245989,)).toJson(),
//       //     image: list,
//       //     iconSize: 0.9,
//       //   ),
//       //   PointAnnotationOptions(
//       //     geometry: Point(coordinates: Position( -63.127791, 46.236847,)).toJson(),
//       //     image: list,
//       //     iconSize: 0.9,
//       //   ),
//       //
//       //   PointAnnotationOptions(
//       //     geometry: Point(coordinates: Position( -63.138494, 46.245799,)).toJson(),
//       //     image: list,
//       //     iconSize: 0.9,
//       //   ),
//       // ];
//       _pointAnnotationManager!.createMulti(markers);
//       _pointAnnotationManager?.addOnPointAnnotationClickListener(this);
//     });
//   }
// }