

import 'dart:async';
import 'dart:typed_data';

import 'dart:ui' as ui;


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../models/food_spot.dart';
import '../../../utils/current_theme.dart';
import '../../firebase/database/food_spots_database/meal_invites_database.dart';
import '../../maps_services/geo_locator_service.dart';
import '../../maps_services/map_requests.dart';

class GMapConnectData with ChangeNotifier{

  GoogleMapsService mapsService = GoogleMapsService();
  GeoLocatorService geoService = GeoLocatorService();
  Completer<GoogleMapController> _controller  = Completer();
  final _pageController = PageController();
  PageController get pageController => _pageController;

  StreamController<FoodSpot> _foodSpotStreamController = StreamController();


  GoogleMapController? _newMapController;



  GoogleMapController? get controller => _newMapController;
  Set<Marker> get markers => _markers;


  final Set<Marker> _markers = {};
  var uuid = Uuid();
  List<FoodSpot> spots = [];



  void onMapCreated(GoogleMapController controller, context) async {
    try {
      var _darkMapStyle = await rootBundle.loadString(
          'assets/map_styles/dark_theme_mode.json');
      var _lightMapStyle = await rootBundle.loadString(
          'assets/map_styles/light_theme_mode.json');


      // locatePosition();

      _controller.complete(controller);
      _newMapController = controller;
      _newMapController!.setMapStyle(
          CurrentTheme(context).isDarkMode ? _darkMapStyle : _lightMapStyle);

      await setUpMarkers();

    }
    catch (e) {

    }
  }
  setUpMarkers() async{
    spots = await MealInviteDatabase().getSpots();
    // final ByteData fire_bytes = await rootBundle.load('assets/icons/fire-station.png');
    final Uint8List list = await getBytesFromAsset('assets/icons/fire-station.png', 70);

    int index = 0;
    spots.forEach((spot) {

      _markers.add(
          Marker(
            markerId: MarkerId(spot.spotId),
            position: LatLng(spot.location.latitude!, spot.location.longitude!),
            icon: BitmapDescriptor.fromBytes(list),
            onTap: () {
              print(index);
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          )
      );
      index += 1;
    });

    notifyListeners();
  }



  void dispose() {
    // TODO: implement dispose
    _newMapController!.dispose();
    super.dispose();
  }




  // void getUserLocation(Position position) async{
  //   //Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
  //   //_initialPosition = LatLng(position.latitude, position.longitude);
  //   locationController.text = placeMark[0].street!;
  // }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

}