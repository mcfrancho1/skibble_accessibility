import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_user.dart';

import 'change_data_notifiers/app_data.dart';
import 'firebase/database/user_database.dart';

class LocationServiceController {
  late final Location location;

  static final LocationServiceController _instance = LocationServiceController._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory LocationServiceController() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  LocationServiceController._internal() {
    // initialization logic
    location = new Location();
  }

  requestLocationService(BuildContext context) async{
    bool _serviceEnabled;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
      if (!_serviceEnabled) {
        await UserDatabaseService().updateUserIsLocationServiceEnabled(currentUser.userId!, false);
        return;
      }
      else {
        await UserDatabaseService().updateUserIsLocationServiceEnabled(currentUser.userId!, true);

      }
    }
  }

  requestLocationPermission(BuildContext context) async{
    PermissionStatus _permissionGranted;

    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if(_permissionGranted == PermissionStatus.deniedForever) {
        await perm_handler.openAppSettings();
      }
      _permissionGranted = await location.hasPermission();

      if (_permissionGranted != PermissionStatus.granted) {
       await UserDatabaseService().updateUserIsLocationPermissionEnabled(Provider.of<AppData>(context, listen: false).skibbleUser!.userId!, false);
        return;
      }
      else {
        await UserDatabaseService().updateUserIsLocationPermissionEnabled(Provider.of<AppData>(context, listen: false).skibbleUser!.userId!, true);
      }
    }
  }

  init() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // _locationData = await location.getLocation();
  }

  enableBackgroundMode() {
    location.enableBackgroundMode(enable: true);
  }

  listenForLocationChanges() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
    });
  }
}