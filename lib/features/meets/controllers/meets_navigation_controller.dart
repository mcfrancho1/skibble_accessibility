import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../models/address.dart';

class MeetsNavigationController with ChangeNotifier{
  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;

  late MapBoxOptions navigationOption;

  String? _platformVersion;
  String? _instruction;



  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initMeetNavigationView(Address startLocation, Address destination) async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    // navigationOption.simulateRoute = false;

    MapBoxNavigation.instance.registerRouteEventListener(onEmbeddedRouteEvent);
    navigationOption = MapBoxOptions(
        initialLatitude: startLocation.latitude,
        initialLongitude: startLocation.longitude,
        zoom: 13.0,
        tilt: 0.0,
        bearing: 0.0,
        enableRefresh: false,
        alternatives: true,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        allowsUTurnAtWayPoints: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        mapStyleUrlDay: MapboxStyles.MAPBOX_STREETS,
        // mapStyleUrlNight: "https://url_to_night_style",
        units: VoiceUnits.imperial,
        simulateRoute: false,
        language: "en");


    MapBoxNavigation.instance.setDefaultOptions(navigationOption);

    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    _platformVersion = platformVersion;


    final _origin = WayPoint(
        name: "Way Point 1",
        latitude: startLocation.latitude,
        longitude: startLocation.longitude,
        isSilent: true);
    final _destination = WayPoint(
        name: "Way Point 2",
        latitude: destination.latitude,
        longitude: destination.longitude,
        isSilent: true);

    var wayPoints = <WayPoint>[];
    wayPoints.add(_origin);
    wayPoints.add(_destination);

    await MapBoxNavigation.instance
        .startNavigation(wayPoints: wayPoints);

  }


  Future<void> onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
          _routeBuilt = true;
          notifyListeners();

          break;
      case MapBoxEvent.route_build_failed:
          _routeBuilt = false;
          notifyListeners();
        break;
      case MapBoxEvent.navigation_running:
          _isNavigating = true;
          notifyListeners();

          break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
          _routeBuilt = false;
          _isNavigating = false;
          notifyListeners();

          break;
      default:
        break;
    }
    notifyListeners();
  }

}