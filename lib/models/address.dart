import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:skibble/models/business_models/yelp_business_details.dart';
import 'package:skibble/models/google_place_details.dart';

class Address {
  String? placeName;
  String? streetNumber;
  String? streetName;
  String? city;
  String? stateOrProvince;
  String? stateOrProvinceCode;
  String? country;
  String? countryCode;
  String? postalCode;
  double? latitude;
  double? longitude;
  String? googlePlaceId;
  String? yelpBusinessId;
  String? tripAdvisorId;
  String? skibblePlaceId;
  List? placeTypes;
  GeoFirePoint? addressGeoPoint;

  String? formattedAddress;


  Address({
    this.placeName,
    this.streetNumber,
    this.streetName,
    this.city,
    this.stateOrProvince,
    this.stateOrProvinceCode,
    this.country,
    this.countryCode,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.googlePlaceId,
    this.formattedAddress,
    this.skibblePlaceId,
    this.yelpBusinessId,
    this.tripAdvisorId,
    this.addressGeoPoint,
    this.placeTypes
  });

  factory Address.fromMap(Map<String, dynamic> data) {
    Address address =  Address(
      placeName: data['placeName'],
      streetNumber: data['streetNumber'] ?? null,
      streetName: data['streetName'],
      city: data['city'],
      stateOrProvince: data['stateOrProvince'],
      stateOrProvinceCode: data['stateOrProvinceCode'],
      country: data['country'],
      postalCode: data['postalCode'],
      countryCode: data['countryCode'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      placeTypes: data['placeTypes'],
      googlePlaceId: data['googlePlaceId'],
      skibblePlaceId: data['skibblePlaceId'],
      yelpBusinessId: data['yelpBusinessId'],
      tripAdvisorId: data['tripAdvisorId'],
      formattedAddress: data['formattedAddress'],
      addressGeoPoint: data['latitude'] != null ? GeoFlutterFire().point(latitude: data['latitude'], longitude: data['longitude']) : null
    );

    if(data['address_components'] != null) {
      for(var component in data['address_components']) {
        if((component['types'] as List).contains('street_number')) {
          address.streetNumber = component['long_name'];
        }

        else if((component['types'] as List).contains('route')) {
          address.streetName = component['long_name'];
        }

        else if((component['types'] as List).contains('locality')) {
          address.city = component['long_name'];
        }

        else if((component['types'] as List).contains('administrative_area_level_1')) {
          address.stateOrProvince = component['long_name'];
          address.stateOrProvinceCode = component['short_name'];

        }

        else if((component['types'] as List).contains('country')) {
          address.country = component['long_name'];
          address.countryCode = component['short_name'];

        }

        else if((component['types'] as List).contains('postal_code')) {
          address.postalCode = component['long_name'];
        }
      }

    }
    return address;
  }

  factory Address.fromGooglePlaceDetails(GooglePlaceDetails placeDetails) {
    return Address(
      placeName: placeDetails.name,
      googlePlaceId: placeDetails.googlePlaceId,
      latitude: placeDetails.latitude,
      longitude: placeDetails.longitude,
      placeTypes: placeDetails.types,
      streetNumber: placeDetails.streetNumber ?? null,
      streetName: placeDetails.streetName,
      city: placeDetails.city,
      stateOrProvince: placeDetails.stateOrProvince,
      stateOrProvinceCode: placeDetails.stateOrProvinceCode,
      country: placeDetails.country,
      postalCode: placeDetails.postalCode,
      countryCode: placeDetails.countryCode,
      formattedAddress: placeDetails.formattedAddressString,
      addressGeoPoint: GeoFlutterFire().point(latitude: placeDetails.latitude!, longitude: placeDetails.longitude!)
    );
  }

  factory Address.fromYelpBusinessDetails(YelpBusinessDetails yelpBusinessDetails) {
    return Address(
        placeName: yelpBusinessDetails.name,
        googlePlaceId: yelpBusinessDetails.yelpBusinessId,
        latitude: yelpBusinessDetails.latitude,
        longitude: yelpBusinessDetails.longitude,
        placeTypes: yelpBusinessDetails.types,
        streetNumber: yelpBusinessDetails.streetNumber ?? null,
        streetName: yelpBusinessDetails.streetName,
        city: yelpBusinessDetails.city,
        stateOrProvince: yelpBusinessDetails.stateOrProvince,
        stateOrProvinceCode: yelpBusinessDetails.stateOrProvinceCode,
        country: yelpBusinessDetails.country,
        postalCode: yelpBusinessDetails.postalCode,
        countryCode: yelpBusinessDetails.countryCode,
        formattedAddress: yelpBusinessDetails.formattedAddressString,
        addressGeoPoint: GeoFlutterFire().point(latitude: yelpBusinessDetails.latitude!, longitude: yelpBusinessDetails.longitude!)
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placeName': this.placeName,
      'streetNumber': this.streetNumber,
      'streetName': this.streetName,
      'city': this.city,
      'stateOrProvince': this.stateOrProvince,
      'stateOrProvinceCode': this.stateOrProvinceCode,
      'country': this.country,
      'postalCode': this.postalCode,
      'countryCode': this.countryCode,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'googlePlaceId': this.googlePlaceId,
      'skibblePlaceId': this.skibblePlaceId,
      'formattedAddress': this.formattedAddress,
      'addressGeoPoint': GeoFlutterFire().point(latitude: latitude!, longitude: longitude!).data
    };
  }
}