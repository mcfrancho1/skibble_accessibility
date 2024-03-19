import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


import 'dart:convert';

import 'package:skibble/config.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/models/google_place_details.dart';
import 'package:skibble/models/place_suggestion.dart';
import 'package:skibble/models/skibble_place.dart';
import 'package:skibble/models/suggestion.dart';
import 'package:skibble/utils/api_url_manager.dart';

import '../http_request_service.dart';


//TODO: HIDE API KEY
class GoogleMapsService {

  String globalRadius = '50000';


  Future<String> getRouteCoordinates(LatLng startingLocation, LatLng endLocation) async{
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startingLocation.latitude},${startingLocation.longitude}&destination=${endLocation.latitude},${endLocation.longitude}&key=${APIKeys.googleAPIKey()}';

    var uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    Map values = jsonDecode(response.body);
    return values["routes"] [0] ["overview_polyline"] ["points"];
  }

  Future<List<Suggestion>> getPlaceSuggestions(String place, String session,
      {List<String>? type, Address? address}) async {
   try {
     var predictions = await GoogleMapsService().findPlaces(place, session, type ?? [], address: address);
     if(predictions != null ) {
       return (predictions as List).map((prediction) => PlaceSuggestion.fromJson(prediction)).toList();
     }

     return [];
   }
   catch(e) {
     return [];
   }
  }

  Future<dynamic> findPlaces(String placeName, String session, List<String> types, {Address? address}) async {

    try {
      if(placeName.length > 1) {

        //TODO: Change the limited location search
        String autoCompleteUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName${address != null ? '&locationrestriction=circle:$globalRadius@${address.latitude!},${address.longitude!}' : ''}${types.isNotEmpty ? '&types=${types.join("|")}' : ''}&key=${APIKeys.googleAPIKey()}&sessiontoken=$session';

        var response = await RequestService.getRequest(autoCompleteUrl);

        if(response['status'] == 'OK') {
          var predictions = response['predictions'];

          return predictions;
        }

        else {
            return null;
        }
      }
    }
    catch(e) {
      return null;
    }
  }



  Future<dynamic> findPlaceBusinesses(String placeName, String session, String type) async {

    if(placeName.length > 1) {

      String autoCompleteUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&types=establishment&location= 46.646951, -63.310391&radius=100000&strictbounds&key=${APIKeys.googleAPIKey()}&sessiontoken=$session&components=country:ca';

      var response = await RequestService.getRequest(autoCompleteUrl);

      if(response == 'Failed') {
        return;
      }

      if(response['status'] == 'OK') {
        var predictions = response['predictions'];

        return predictions;


      }
    }
  }

  static Future<Location> getLocationFromAddress(String address) async{
    var location =  await locationFromAddress(address);
    return location[0];
  }

  static Future<Placemark> placemarkFromLocation(Position position) async{
    var location =  await placemarkFromCoordinates(position.latitude, position.longitude);
    return location[0];
  }

  static Future<Address?> getAddressFromPosition(Position position, context) async {
    try {
      String placeAddress = '';
      String url = APIUrlManager().googleGeoCodeUrl(position, APIKeys.googleAPIKey());

      var response = await RequestService.getRequest(url);

      if(response != 'Failed') {
        // print(response);
        placeAddress = response['results'][0]['formatted_address'];

        //placeAddress = response['results'][0]['formatted_address'];

        return Address.fromGooglePlaceDetails(GooglePlaceDetails.fromJson(response['results'][0]));
      }
      else {
        return null;
      }
    }
    catch(e) {
      print(e);
      return null;
    }


  }


  // Future<String> getPhoto(String photoId) async{
  //   var response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=$photoId&key=${APIKeys.googleAPIKey()}'));
  //  print(response);
  //   // var json = convert.jsonDecode(response.body);
  //   // return json;
  //
  // }

  Future<GooglePlaceDetails?> getPlaceDetails(String placeId) async{
    try {
      var url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${APIKeys.googleAPIKey()}';

      var response = await RequestService.getRequest(url);

      if(response['status'] == 'OK') {
        var result = response['result'];
        return GooglePlaceDetails.fromJson(result);
      }

      else {
        return null;
      }
    }
    catch(e) {
      print(e);
      return null;
    }


  }

  Future<List<GooglePlaceDetails>?> getNearbyPlaces(String keyword, String radius, String type, Address address) async{
    try {

      var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$keyword&location=${address.latitude!}%2C${address.longitude!}&radius=$radius&type=$type&key=${APIKeys.googleAPIKey()}';

      var response = await RequestService.getRequest(url);

      if(response['status'] == 'OK') {
        var result = response['results'];

        List<GooglePlaceDetails> places = [];

        for(var res in result) {
          List? types = res['types'];

          if(types != null) {
            if(types.contains('food') || types.contains('restaurant') || types.contains('cafe') ||  types.contains('meal_delivery') || types.contains('bar') || types.contains('meal_takeaway')) {
              places.add(GooglePlaceDetails.fromJson(res));

            }
          }
        }
        return places;
      }

      else {
        return null;
      }
    }
    catch(e) {
      return null;

    }
  }

  Future<List<SkibbleFoodBusiness>?> getNearbyFoodBusinesses(String keyword, String radius, String type, Address address, ) async{
    try {
      var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=${address.stateOrProvince}&location=${address.latitude!}%2C${address.longitude!}&radius=$radius&type=$type&key=${APIKeys.googleAPIKey()}';

      var response = await RequestService.getRequest(url);

      if(response['status'] == 'OK') {
        var result = response['results'];

        List<SkibbleFoodBusiness> places = [];

        for(var res in result) {
          List? types = res['types'];

          if(types != null) {
            if(types.contains('food') || types.contains('restaurant') || types.contains('cafe') ||  types.contains('meal_delivery') || types.contains('bar') || types.contains('meal_takeaway')) {
              places.add(
                  SkibbleFoodBusiness(
                    address: Address.fromGooglePlaceDetails(GooglePlaceDetails.fromJson(res)),
                    skibbleBusinessType: SkibbleBusinessType.google,
                    googlePlaceDetails:  GooglePlaceDetails.fromJson(res),
                    nextPageGoogleToken: response['next_page_token']
                  )
              );

            }
          }
        }
        return places;
      }
      else {
        return null;
      }
    }
    catch(e) {
      print(e);
      return null;

    }
  }


  Future<List<SkibbleFoodBusiness>?> getMoreNearbyFoodBusinesses(String keyword, String radius, String type, Address address, {String? nextToken}) async{
    try {

      if(nextToken == null) return [];

      var url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=${address.stateOrProvince}&location=${address.latitude!}%2C${address.longitude!}&radius=$radius&type=$type&key=${APIKeys.googleAPIKey()}${nextToken == null ? '': '&pagetoken=$nextToken'}';

      var response = await RequestService.getRequest(url);

      if(response['status'] == 'OK') {
        var result = response['results'];

        List<SkibbleFoodBusiness> places = [];

        for(var res in result) {
          List? types = res['types'];

          if(types != null) {
            if(types.contains('food') || types.contains('restaurant') || types.contains('cafe') ||  types.contains('meal_delivery') || types.contains('bar') || types.contains('meal_takeaway')) {
              places.add(
                  SkibbleFoodBusiness(
                      address: Address.fromGooglePlaceDetails(GooglePlaceDetails.fromJson(res)),
                      skibbleBusinessType: SkibbleBusinessType.google,
                      googlePlaceDetails:  GooglePlaceDetails.fromJson(res),
                      nextPageGoogleToken: response['next_page_token']
                  )
              );

            }
          }
        }
        return places;
      }
      else {
        return null;
      }
    }
    catch(e) {
      print(e);
      return null;

    }
  }


  Future<List<GooglePlaceDetails>?> getAutoCompletePlaces(String query, Address address) async{
    try {

      var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&location=${address.latitude}%2C${address.longitude}&radius=500&types=restaurant|bar|cafe&key=${APIKeys.googleAPIKey()}';

      var response = await RequestService.getRequest(url);

      if(response['status'] == 'OK') {
        var result = response['predictions'];

        List<GooglePlaceDetails> places = [];

        for(var res in result) {
          if(res['types'] != null) {
            if((res['types'] as List).contains('restaurant') || (res['types'] as List).contains('cafe') || (res['types'] as List).contains('meal_delivery') || (res['types'] as List).contains('bar') || (res['types'] as List).contains('meal_takeaway')) {
              places.add(GooglePlaceDetails.fromJson({}, predictionJson: res));

            }
          }
        }
        return places;
      }

      else {
        return null;
      }
    }
    catch(e) {
      return null;

    }
  }

  Future<List<GooglePlaceDetails>?> getPlacesWithTextSearch(String query, Address address) async{
    try {

      var url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=${APIKeys.googleAPIKey()}';

      var response = await RequestService.getRequest(url);

      if(response['status'] == 'OK') {
        var result = response['results'];

        List<GooglePlaceDetails> places = [];

        for(var res in result) {
          List? types = res['types'];

          if(types != null) {
            // if(types.contains('restaurant') || types.contains('cafe') || types.contains('meal_delivery') || types.contains('bar') || types.contains('meal_takeaway')) {
              places.add(GooglePlaceDetails.fromJson(res));

            // }
          }
        }
        return places;
      }

      else {
        return null;
      }
    }
    catch(e) {
      print(e);
      return null;

    }
  }


// String parseHtmlString(String htmlString) {
  //   final document = parse(htmlString);
  //   final String parsedString = parse(document.body.text).documentElement.text;
  //
  //   return parsedString;
  // }
}