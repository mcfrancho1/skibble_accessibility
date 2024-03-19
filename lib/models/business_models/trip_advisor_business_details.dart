
import 'package:equatable/equatable.dart';
import 'package:skibble/config.dart';
import 'package:skibble/models/reviews_ratings.dart';

class TripAdvisorBusinessDetails {
  final String? name;
  final double? rating;
  final String? googlePlaceId;
  final int? userRatingCount;
  final String? formattedAddressString;
  final String? secondaryText;
  final String? tripAdvisorBusinessId;
  final String? vicinity;
  String? country;
  String? city;
  String? stateOrProvince;
  String? stateOrProvinceCode;
  String? streetNumber;
  String? streetName;
  String? postalCode;
  String? countryCode;
  double? latitude;
  double? longitude;

  String? phoneNumber;
  List? placeImages;
  String? description;
  String? averagePrice;
  String? address;
  String? websiteAddress;
  bool? isOpenNow;
  List? imageRefList;
  List? types;
  int? priceLevel;
  List? openingHoursWeekDayText;
  String? openOrCloseText;
  List<RatingAndReview> ? ratingsAndReviewsList;

  TripAdvisorBusinessDetails({
    this.name,
    this.rating,
    this.tripAdvisorBusinessId,
    this.userRatingCount,
    this.vicinity,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.googlePlaceId,
    this.address,
    this.types,
    this.description,
    this.websiteAddress,
    this.placeImages,
    this.imageRefList,
    this.averagePrice,
    this.streetNumber,
    this.streetName,
    this.city,
    this.stateOrProvince,
    this.country,
    this.postalCode,
    this.stateOrProvinceCode,
    this.countryCode,
    this.openingHoursWeekDayText,
    this.openOrCloseText, this.isOpenNow, this.formattedAddressString, this.secondaryText
  });

  factory TripAdvisorBusinessDetails.fromJson(Map<dynamic, dynamic> parsedJson, {Map<dynamic, dynamic>? predictionJson}) {
    if(predictionJson != null) {
      return TripAdvisorBusinessDetails(
        googlePlaceId: predictionJson['place_id'] ?? null,
        formattedAddressString: predictionJson['description'] ?? null,
        name: predictionJson['structured_formatting'] != null ? predictionJson['structured_formatting']['main_text'] : '',
        secondaryText: predictionJson['structured_formatting'] != null ? predictionJson['structured_formatting']['secondary_text'] : '',
      );
    }

    else {
      TripAdvisorBusinessDetails placeDetails = TripAdvisorBusinessDetails(
        name: parsedJson['name'] ?? null,
        formattedAddressString: parsedJson['formatted_address'] ?? '',
        googlePlaceId: parsedJson['place_id'] ?? null,
        types: parsedJson['types'] != null ? parsedJson['types'] : [],
        rating: parsedJson['rating'] != null ? parsedJson['rating'].toDouble() : 1,
        userRatingCount: (parsedJson['user_ratings_total'] != null) ? parsedJson['user_ratings_total'] : 1,
        vicinity: parsedJson['vicinity'] != null ? parsedJson['vicinity'] : parsedJson['formatted_address'] != null ? parsedJson['formatted_address'] : null,
        phoneNumber: parsedJson['international_phone_number'] != null ? parsedJson['international_phone_number'] : null,
        address: parsedJson['formatted_address'] != null ? parsedJson['formatted_address'] : null,
        isOpenNow: parsedJson['opening_hours'] != null ? parsedJson['opening_hours']['open_now'] != null ? parsedJson['opening_hours']['open_now'] : true : true,
        websiteAddress: parsedJson['website'] != null ? parsedJson['website'] : null,
        imageRefList: parsedJson['photos'] != null ? (parsedJson['photos'] as List).map((photo) => photo['photo_reference']).toList() : [],
        latitude: parsedJson['geometry'] != null ? parsedJson['geometry']['location']['lat']: null,
        longitude: parsedJson['geometry'] != null ? parsedJson['geometry']['location']['lng']: null,
        placeImages: parsedJson['photos'] != null ? (parsedJson['photos'] as List).map((photo) => APIKeys.getGooglePhotoUrl(photo['photo_reference'])).toList() : [],
      );

      if(parsedJson['address_components'] != null) {
        for(var component in parsedJson['address_components']) {
          if((component['types'] as List).contains('street_number')) {
            placeDetails.streetNumber = component['long_name'];
          }

          else if((component['types'] as List).contains('route')) {
            placeDetails.streetName = component['long_name'];
          }

          else if((component['types'] as List).contains('locality')) {
            placeDetails.city = component['long_name'];
          }

          else if((component['types'] as List).contains('administrative_area_level_1')) {
            placeDetails.stateOrProvince = component['long_name'];
            placeDetails.stateOrProvinceCode = component['short_name'];

          }

          else if((component['types'] as List).contains('country')) {
            placeDetails.country = component['long_name'];
            placeDetails.countryCode = component['short_name'];

          }

          else if((component['types'] as List).contains('postal_code')) {
            placeDetails.postalCode = component['long_name'];
          }
        }

      }
//
//
//    photosUrls.add('https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=$url&key=${APIKeys.GOOGLE_API_KEY}');

      placeDetails.ratingsAndReviewsList = [];

      if(parsedJson['reviews'] != null) {
        for(var review in parsedJson['reviews']) {
          placeDetails.ratingsAndReviewsList!.add(RatingAndReview(
              timePosted: review['time'] ?? 0,
              reviewText: review['text'],
              authorName: review['author_name'],
              relativeTime: review['relative_time_description'],
              profileImageUrl: review['profile_photo_url'],
              overallRating: review['rating'] != null ? (review['rating']).toDouble() : 1
          ));
        }

      }

      if(parsedJson['price_level'] != null) {
        placeDetails.priceLevel = parsedJson['price_level'];
      }

      if(parsedJson['opening_hours'] != null) {
        // if(parsedJson['opening_hours']['weekday_text'] != null ) {
        //   placeDetails.openingHoursWeekDayText = parsedJson['opening_hours']['weekday_text'];
        // }


        //
        // int currentDay = DateTime.now().weekday;
        //
        //
        // if(parsedJson['opening_hours']['periods'] != null) {
        //
        //   //handle text for closing time
        //   if(parsedJson['opening_hours']['open_now']) {
        //     if(parsedJson['opening_hours']['weekday_text'] != null ) {
        //       String hours = parsedJson['opening_hours']['weekday_text'][(currentDay - 1) == - 1 ? 6 : currentDay - 1];
        //
        //       if(hours.contains('Open 24 hours')) {
        //         openOrCloseText = 'Open 24 hours';
        //
        //       }
        //       else {
        //        openOrCloseText =  hours.split(': ')[1].split('- ')[1];
        //       }
        //
        //     }
        //   }
        //
        // }


        // if(parsedJson['opening_hours']['periods'] != null) {
        //   for(var period in parsedJson['opening_hours']['periods']) {
        //     if(period['open'] != null && period['close'] == null) {
        //       workPeriods.add(
        //           WorkPeriods(
        //             openPeriod: Period(day: 0, time: period['open']['time']),
        //             closePeriod: null,
        //             isOpenFor24Hours: true
        //       ));
        //     }
        //     else {
        //       workPeriods.add(
        //           WorkPeriods(
        //               openPeriod: Period(day: period['open']['day'], time: period['open']['time']),
        //               closePeriod: Period(day: period['close']['day'], time: period['close']['time']),
        //               isOpenFor24Hours: false
        //           )
        //       );
        //     }
        //   }
        // }
      }

      return placeDetails;
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, latitude, longitude, ];

  @override
  bool get stringify => true;

}