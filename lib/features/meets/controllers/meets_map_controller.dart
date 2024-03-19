
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';
import 'package:skibble/features/meets/services/database/meets_database.dart';

import '../../../services/firebase/database/food_spots_database/meal_invites_database.dart';

class MeetsMapController extends OnPointAnnotationClickListener with ChangeNotifier {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  final _pageController = PageController();
  PageController get pageController => _pageController;

  String styleURI = 'mapbox://styles/cfmbonu/cldy65g20000o01qtuy436ier';

  int? activeMarkerIndex;
  List<SkibbleMeet> _meetsOnMap = [];

  List<SkibbleMeet> get meetsOnMap => _meetsOnMap;


  var markers = <PointAnnotationOptions>[];

  void setMeetsOnMap(List<SkibbleMeet> meets) async{
    _meetsOnMap = meets;
    await createAnnotations();
    notifyListeners();
  }


  onCreateMap(SkibbleUser currentUser, MapboxMap mapboxMap) async{
    _mapboxMap = mapboxMap;

    // print(currentUser.mapImageUrl);
    _mapboxMap?.loadStyleURI(MapboxStyles.MAPBOX_STREETS);
    // mapboxMap.location.updateSettings(LocationComponentSettings(
    //     locationPuck: LocationPuck(
    //         locationPuck3D: LocationPuck3D(
    //           modelUri:
    //           currentUser.mapImageUrl,))));

    _mapboxMap?.compass.updateSettings(CompassSettings(enabled: false));
    _mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    _mapboxMap?.gestures.updateSettings(GesturesSettings(
        rotateEnabled: false,
        scrollEnabled:  true,
        scrollMode: ScrollMode.HORIZONTAL_AND_VERTICAL
    ));
    await createAnnotations();
  }

  MapboxMap get mapboxMap => _mapboxMap!;
  PointAnnotationManager get pointAnnotationManager => _pointAnnotationManager!;


  void updateActiveMarkerIndex(int newIndex) {
    activeMarkerIndex = newIndex;
    notifyListeners();
  }

  // void updateConnectMarker(int index, FoodSpot spot) {
  //   connectMarkers[index] = spot;
  //   notifyListeners();
  // }

  void onPointAnnotationClick(PointAnnotation annotation) {
    // TODO: implement onPointAnnotationClick
    print("onAnnotationClick, id: ${annotation.id}");
    var index = markers.indexWhere((element) => element.geometry == annotation.geometry);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
    );
    notifyListeners();
  }


  createAnnotations() async{
    final ByteData fire_bytes = await rootBundle.load('assets/icons/fire-station.png');
    final Uint8List list = fire_bytes.buffer.asUint8List();
    _mapboxMap?.annotations.createPointAnnotationManager().then((value) async {
      _pointAnnotationManager = value;
      // createOneAnnotation(list);

      _meetsOnMap.forEach((meet) {markers.add(PointAnnotationOptions(
        geometry: Point(coordinates: Position( meet.meetLocation!.address.addressGeoPoint!.longitude, meet.meetLocation!.address.addressGeoPoint!.latitude,)).toJson(),
        image: list,
        iconSize: 0.9,
      ),);
      });

      // var options = <PointAnnotationOptions>[
      //   PointAnnotationOptions(
      //     geometry: Point(coordinates: Position( -63.138434, 46.245989,)).toJson(),
      //     image: list,
      //     iconSize: 0.9,
      //   ),
      //   PointAnnotationOptions(
      //     geometry: Point(coordinates: Position( -63.127791, 46.236847,)).toJson(),
      //     image: list,
      //     iconSize: 0.9,
      //   ),
      //
      //   PointAnnotationOptions(
      //     geometry: Point(coordinates: Position( -63.138494, 46.245799,)).toJson(),
      //     image: list,
      //     iconSize: 0.9,
      //   ),
      // ];
      _pointAnnotationManager!.createMulti(markers);
      _pointAnnotationManager?.addOnPointAnnotationClickListener(this);
    });
  }
}