import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/shared/dialogs.dart';

import '../change_data_notifiers/app_data.dart';
import 'map_requests.dart';

class GeoLocatorService {


  // Stream<Position> get currentLocation {
  //   return Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high, distanceFilter: 10);
  // }

  // Future<Position?> getCurrentPosition() async{
  //   try {
  //     var position = await _determinePosition();
  //     return position;
  //   }
  //   catch(e) {
  //     print(e);
  //     return null;
  //   }
  // }

  /**
   * Helps us get the current user address
   */
  Future<Address?> getCurrentPositionAddress(context) async {
    try{
      var position = await _determinePosition(context);
      //TODO: DELETE POSITION PRINTING


      if(position != null) {
        Address? address = await GoogleMapsService.getAddressFromPosition(position, context);
        Provider.of<AppData>(context, listen: false).updateUserCurrentLocation(address);
        return address;
      }
      else {
        return null;
      }

    }
    catch(e) {
      return null;
    }

  }

  Future<Address?> getCurrentPositionAddressUsingPlacemark(context) async {
    try{
      var position = await _determinePosition(context);
      Placemark? placemark = await GoogleMapsService.placemarkFromLocation(position!);
      Address address = Address(
        placeName: placemark.street,
        countryCode: placemark.isoCountryCode,
        city: placemark.locality,
        country: placemark.country,
        postalCode: placemark.postalCode,
        stateOrProvince: placemark.administrativeArea,
        streetName: placemark.thoroughfare,
        streetNumber: placemark.subThoroughfare,
        latitude: position.latitude,
        longitude: position.longitude
        // stateOrProvinceCode: placemark.administrativeArea![0] + placemark.administrativeArea.split(pattern)
      );

      Provider.of<AppData>(context, listen: false).updateUserCurrentLocation(address);

      return address;
    }
    catch(e) {
      return null;
    }

  }



  double getDistance(double startLat, double startLng, double endLat, double endLng) {

    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position?> _determinePosition(context) async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        await UserDatabaseService().updateUserIsLocationServiceEnabled(Provider.of<AppData>(context, listen: false).skibbleUser!.userId!, false);
        CustomDialog(context).showErrorDialog('Enable Location', 'Please enable location services to continue');
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          await UserDatabaseService().updateUserIsLocationPermissionEnabled(Provider.of<AppData>(context, listen: false).skibbleUser!.userId!, false);

          CustomDialog(context).showErrorDialog('Permissions denied', 'Please grant us permission to access your location in order to continue.');

          return Future.error('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.

        // CustomDialog(context).showOpenSettingsDialog('Permissions Denied', "You may not have access to some features because Skibble does not have access to your location.\n\nClick the button below to grant Skibble access to your location.", onConfirm: () async{
        //   await openAppSettings();
        //
        // });
        await UserDatabaseService().updateUserIsLocationPermissionEnabled(Provider.of<AppData>(context, listen: false).skibbleUser!.userId!, false);

        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      await UserDatabaseService().updateUserIsLocationServiceEnabled(Provider.of<AppData>(context, listen: false).skibbleUser!.userId!, true);
      await UserDatabaseService().updateUserIsLocationPermissionEnabled(Provider.of<AppData>(context, listen: false).skibbleUser!.userId!, true);

      return await Geolocator.getCurrentPosition();
    }
    catch(e) {
      return null;
    }
  }

  // Future<UserGeoDetails> getUserGeoDetails(MyPEIUser user, context) async {
  //   try {
  //     UserGeoDetails userGeoDetails = UserGeoDetails();
  //     MyPEIUser userForAddress = MyPEIUser();
  //
  //     userGeoDetails.initialPosition = await getCurrentPosition();
  //     userGeoDetails.initialPositionAddress = await updateAddress(userGeoDetails.initialPosition, context);
  //     userForAddress = await DatabaseService(userId: user.uid).getUserAddress();
  //     userGeoDetails.userHomeAddress = userForAddress.homeAddress;
  //     userGeoDetails.userWorkAddress = userForAddress.workAddress;
  //     return userGeoDetails;
  //   }
  //   catch(e) {return null;}
  // }

  // Future<Address> updateAddress(Position position, context) async {
  //   var address = await GoogleMapsService.getAddress(position, context);
  //   // Provider.of<AppData>(context, listen: false).updateCurrentLocationAddress(address);
  //   //print(address.placeName);
  //   return address;
  // }
  //
  // Future<Address> getAddressForPlaces(context) async {
  //   var position = await getCurrentPosition();
  //   var address;
  //   if(position != null) {
  //     address = await GoogleMapsService.getAddress(position, context);
  //   }
  //   //print(address.placeName);
  //   return address;
  // }
}