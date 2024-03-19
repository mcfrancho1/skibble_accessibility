
import 'package:equatable/equatable.dart';
import 'package:skibble/config.dart';
import 'package:skibble/models/reviews_ratings.dart';

class YelpBusinessDetails {
  final String? name;
  final String? alias;
  final double? rating;
  final String? yelpBusinessId;
  final String? imageUrl;
  final int? userRatingCount;
  String? formattedAddressString;
  final String? secondaryText;
  final double? distance;
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
  String? priceLevel;
  List? openingHoursWeekDayText;
  String? openOrCloseText;
  List<RatingAndReview> ? ratingsAndReviewsList;

  YelpBusinessDetails({
    this.name,
    this.alias,
    this.rating,
    this.imageUrl,
    this.userRatingCount,
    this.vicinity,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.yelpBusinessId,
    this.address,
    this.types,
    this.priceLevel,
    this.distance,
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

  factory YelpBusinessDetails.fromJson(Map<dynamic, dynamic> parsedJson, {Map<dynamic, dynamic>? predictionJson}) {
    if(predictionJson != null) {
      return YelpBusinessDetails(
        yelpBusinessId: predictionJson['id'] ?? null,
        formattedAddressString: predictionJson['description'] ?? null,
        name: predictionJson['structured_formatting'] != null ? predictionJson['structured_formatting']['main_text'] : '',
        secondaryText: predictionJson['structured_formatting'] != null ? predictionJson['structured_formatting']['secondary_text'] : '',
      );
    }

    else {
      YelpBusinessDetails placeDetails = YelpBusinessDetails(
        name: parsedJson['name'] ?? null,
        alias: parsedJson['alias'] ?? null,
        yelpBusinessId: parsedJson['id'] ?? null,
        imageUrl: parsedJson['image_url'] ?? null,
        isOpenNow: parsedJson['is_closed'] != null ? !parsedJson['is_closed'] : false,
        websiteAddress: parsedJson['url'] != null ? parsedJson['url'] : null,
        phoneNumber: parsedJson['phone'] != null ? parsedJson['phone'] : null,
        latitude: parsedJson['coordinates'] != null ? parsedJson['coordinates']['latitude']: null,
        longitude: parsedJson['coordinates'] != null ? parsedJson['coordinates']['longitude']: null,
        rating: parsedJson['rating'] != null ? parsedJson['rating'].toDouble() : 0,
        userRatingCount: (parsedJson['review_count'] != null) ? parsedJson['review_count'] : 0,
        priceLevel: parsedJson['price'] != null ?  parsedJson['price'] : null,
        distance: parsedJson['distance'] != null ?  parsedJson['distance'] : null,
        types: parsedJson['categories'] != null ? (parsedJson['categories'] as List<dynamic>).map((e) => e['title']).toList() : [],
      );


      if(parsedJson['location'] != null) {
        var location  = parsedJson['location'];
        placeDetails.formattedAddressString = location['display_address'] != null ? (location['display_address'] as List).join(", ") : null;


    var list = (location['address1'] as String ).split(" ");
          placeDetails.streetNumber = list[0];
          placeDetails.streetName = list.length > 1 ? list.sublist(1).join(" ") : (location['address1'] as String );
          placeDetails.city = location['city'];
          placeDetails.stateOrProvinceCode = location['state'];
          placeDetails.countryCode = location['country'];
          placeDetails.postalCode = location['zip_code'];
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