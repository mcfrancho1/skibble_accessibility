// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:provider/provider.dart';
// // import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:skibble/models/food_spot.dart';
// import 'package:skibble/services/firebase/database/food_spots_database/meal_invites_database.dart';
//
// import '../../../models/map_models/map_marker.dart';
// import '../../../models/meal_invite.dart';
//
// ///
// /// This is based on the new mapbox package for flutter. The code here will be reused in the future
//
// class MapboxConnectData  with ChangeNotifier{
//   // MapboxMap? _mapboxMap;
//   MapboxMapController? _mapboxMapController;
//   final _pageController = PageController(keepPage: false);
//   PageController get pageController => _pageController;
//   List<MapMarker> get spotsMarkers => _spotsMarkers;
//   Symbol? get selectedSymbol => _selectedSymbol;
//
//   MapMarker? _selectedSpotMarker;
//
//
//   int _symbolCount = 0;
//   static const double normalSymbolSize = 2;
//   static const double tappedSymbolSize = 2.5;
//   Symbol? _selectedSymbol;
//   int _selectedIndex = 0;
//   int _selectedIndexTracker = 0;
//
//   bool _iconAllowOverlap = false;
//
//   late final StreamController<FoodSpot> streamController;
//   StreamProvider<List<FoodSpot>>? streamProvider;
//   late final StreamSubscription<List<FoodSpot>> streamSubscription;
//
//   int? activeMarkerIndex;
//   List<MapMarker> _spotsMarkers = [];
//
//
//
//   onCreateMap(MapboxMapController controller) async{
//     _mapboxMapController = controller;
//     _mapboxMapController?.onSymbolTapped.add(_onSymbolTapped);
//     // List<FoodSpot> spots = await MealInviteDatabase().getSpots();
//
//     // _spotsMarkers = spots.map((spot) => MapMarker(spot: spot)).toList();
//     // await _addAll(_spotsMarkers);
//     await setUpStream();
//   }
//
//   setUpStream() async{
//     // streamProvider = StreamProvider(create: , initialData: [])
//
//     streamSubscription = MealInviteDatabase().streamSpots().listen((spots) async{
//       _selectedIndexTracker = _selectedIndex;
//       _selectedSpotMarker = _spotsMarkers.isNotEmpty ?  _spotsMarkers[_selectedIndexTracker] : null;
//
//       _removeAll();
//       _spotsMarkers = spots.map((spot) => MapMarker(spot: spot)).toList();
//       await _addAll(_spotsMarkers);
//
//       ///If there is a change while the user is using the spots feature, do this
//       if(_selectedIndexTracker < _spotsMarkers.length - 1 && _selectedSpotMarker != null) {
//         try {
//           _selectedSymbol = _mapboxMapController!.symbols.firstWhere((element) => element.data!['spotId'] == _selectedSpotMarker!.spot.spotId);
//           int index = _spotsMarkers.indexWhere((element) => element.spot.spotId == _selectedSymbol!.data!['spotId']);
//           _selectedIndex = index;
//           if(_pageController.page != _selectedIndex && index != -1) {
//             _pageController.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
//           }
//
//           if(_selectedSymbol!.options.iconSize != tappedSymbolSize) {
//             _updateSelectedSymbol(
//               SymbolOptions(
//                 iconSize:tappedSymbolSize,
//               ),
//             );
//           }
//         }
//         on StateError {
//
//         }
//         catch(e) {
//
//         }
//         _selectedIndex = _selectedIndexTracker;
//
//       }
//
//       ///Runs once the spots is launched for the first time
//       else {
//         if(_spotsMarkers.isNotEmpty) {
//           _selectedSymbol = _mapboxMapController?.symbols.first;
//
//           _mapboxMapController?.animateCamera(CameraUpdate.newLatLng(LatLng(_selectedSymbol!.options.geometry!.latitude, _selectedSymbol!.options.geometry!.longitude)));
//           _updateSelectedSymbol(
//             SymbolOptions(
//               iconSize:tappedSymbolSize,
//             ),
//           );
//         }
//       }
//
//     });
//
//   }
//
//   MapboxMapController get mapboxMapController => _mapboxMapController!;
//
//
//   void updateActiveMarkerIndex(int newIndex) {
//     activeMarkerIndex = newIndex;
//     notifyListeners();
//   }
//
//   void onCardSwiped(FoodSpot spot, int index) {
//     Symbol? symbol;
//     try {
//       symbol = _mapboxMapController?.symbols.firstWhere((element) => element.data!['spotId'] == spot.spotId);
//
//     } on StateError {
//       symbol = null;
//     }
//     catch(e) {
//       symbol = null;
//     }
//
//     if(symbol != null) {
//       if (_selectedSymbol != null) {
//         _updateSelectedSymbol(
//           const SymbolOptions(iconSize: normalSymbolSize),
//         );
//       }
//       _selectedSymbol = symbol;
//
//       _selectedIndex = index;
//       _mapboxMapController?.animateCamera(CameraUpdate.newLatLng(LatLng(_selectedSymbol!.options.geometry!.latitude, _selectedSymbol!.options.geometry!.longitude)));
//
//       _updateSelectedSymbol(
//         SymbolOptions(
//           iconSize:tappedSymbolSize,
//         ),
//       );
//
//       notifyListeners();
//     }
//   }
//
//
//   void _onSymbolTapped(Symbol symbol) {
//     HapticFeedback.lightImpact();
//     if (_selectedSymbol != null) {
//       _updateSelectedSymbol(
//         const SymbolOptions(iconSize: normalSymbolSize),
//       );
//     }
//     _selectedSymbol = symbol;
//     _mapboxMapController?.animateCamera(CameraUpdate.newLatLng(LatLng(_selectedSymbol!.options.geometry!.latitude, _selectedSymbol!.options.geometry!.longitude)));
//
//
//     _updateSelectedSymbol(
//       SymbolOptions(
//         iconSize:tappedSymbolSize,
//       ),
//     );
//
//     int index = _spotsMarkers.indexWhere((element) => element.spot.spotId == _selectedSymbol!.data!['spotId']);
//     _selectedIndex = index;
//     if(index != -1) {
//       _pageController.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
//     }
//
//     notifyListeners();
//   }
//
//   void _updateSelectedSymbol(SymbolOptions changes) async {
//     await _mapboxMapController!.updateSymbol(_selectedSymbol!, changes);
//   }
//
//   void _add(MapMarker mapMarker) {
//       _mapboxMapController!.addSymbol(_getSymbolOptions(mapMarker), mapMarker.spot.toMap());
//       _symbolCount += 1;
//       notifyListeners();
//   }
//
//   Future<void> _addAll(List<MapMarker> mapMarkers) async {
//     // _mapboxMapController!.symbols.forEach(
//     //         (s) => symbolsToAddNumbers.removeWhere((i) => i == s.data!['count']));
//
//     if (mapMarkers.isNotEmpty) {
//       final List<SymbolOptions> symbolOptionsList = mapMarkers
//           .map((marker) => _getSymbolOptions(marker))
//           .toList();
//      await _mapboxMapController!.addSymbols(symbolOptionsList, mapMarkers.map((marker) => marker.spot.toMap()).toList());
//
//         _symbolCount = mapMarkers.length;
//     }
//     notifyListeners();
//   }
//
//   void _remove() {
//     _mapboxMapController!.removeSymbol(_selectedSymbol!);
//       _selectedSymbol = null;
//       _symbolCount -= 1;
//       notifyListeners();
//   }
//
//   void _removeAll() {
//     _mapboxMapController!.removeSymbols(_mapboxMapController!.symbols);
//       _selectedSymbol = null;
//       _symbolCount = 0;
//     notifyListeners();
//
//   }
//
//   SymbolOptions _getSymbolOptions(MapMarker mapMarker) {
//     LatLng geometry = LatLng(
//       mapMarker.spot.location.latitude!,
//       mapMarker.spot.location.longitude!,
//     );
//     return SymbolOptions(
//       geometry: geometry,
//
//       //TODO: change the icon image later
//       iconImage: mapMarker.image,
//       iconSize: normalSymbolSize,
//       iconOpacity: mapMarker.spot.isHostLocationPublic? 1: 0,
//       // fontNames: ['DIN Offc Pro Bold', 'Arial Unicode MS Regular'],
//       // textField: 'Airport',
//       // textSize: 12.5,
//       // textOffset: Offset(0, 0.8),
//       textAnchor: 'top',
//       textColor: '#000000',
//       textHaloBlur: 1,
//       textHaloColor: '#ffffff',
//       textHaloWidth: 0.8,
//     );
//   }
//
//   Future<void> addImageFromUrl(String name, Uri uri) async {
//     var response = await http.get(uri);
//     return _mapboxMapController!.addImage(name, response.bodyBytes);
//   }
//
//
//
// }