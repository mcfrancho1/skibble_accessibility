import 'package:skibble/models/address.dart';
import 'package:skibble/models/reviews_ratings.dart';

import 'menu_models/menu.dart';

class Restaurant {
  String? name;
  Address? address;
  String? emailAddress;
  String? phoneNumber;
  String? description;
  String? restaurantId;
  String? restaurantLogo;
  String? restaurantCoverImage;
  int? restaurantColorTheme;
  List<Menu>? menusList;
  num? averageRatings;
  RatingAndReview? ratingsAndReviews;
  num? deliveryTime;
  num? deliveryCost;
  String? currencyType;
  List? tags;
  List? foodSpecialty;

  List? orderOptions;

  Restaurant({
    this.name,
    this.address,
    this.emailAddress,
    this.phoneNumber,
    this.restaurantId,
    this.restaurantLogo,
    this.restaurantCoverImage,
    this.restaurantColorTheme,
    this.menusList,
    this.averageRatings,
    this.ratingsAndReviews,
    this.deliveryTime,
    this.description,
    this.tags,
    this.deliveryCost,
    this.foodSpecialty,
    this.currencyType,
    this.orderOptions
  });

  factory Restaurant.fromMap(Map<String, dynamic> data, {List<Menu>? menuList}) {
    return Restaurant(
      name: data['name'],
      address: Address.fromMap(data['address']),
      emailAddress: data['emailAddress'],
      phoneNumber: data['phoneNumber'],
      restaurantId: data['restaurantId'],
      restaurantLogo: data['restaurantLogo'],
      restaurantCoverImage: data['restaurantCoverImage'],
      restaurantColorTheme: data['restaurantColorTheme'] ?? 0,
      menusList: menuList ?? [],
      averageRatings: data['averageRatings'],
      ratingsAndReviews: data['ratingsAndReviews'],
      deliveryTime: data['deliveryTime'],
      deliveryCost: data['deliveryCost'],
      description: data['description'],
      tags: data['tags'],
      foodSpecialty: data['foodSpecialty'],
      currencyType: data['currencyType'],
      orderOptions: data['orderOptions']
    );
  }
}