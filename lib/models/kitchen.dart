import 'package:flutter/cupertino.dart';
import 'package:get/utils.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/models/booking_slot.dart';
import 'package:skibble/models/menu_models/menu.dart';
import 'package:skibble/models/reviews_ratings.dart';
import 'package:skibble/models/work_experience_controller_model.dart';

import 'certificationsController.dart';


enum KitchenType {ghostKitchen, restaurant, foodTruck, franchise, cafe}
enum FoodDeliveryOption {delivery, pickup, deliveryAndPickup}
class Kitchen {

  String? kitchenName;
  String? kitchenId;
  String? kitchenUserName;

  String? description;

  String? kitchenProfileImageUrl;
  String? kitchenCoverImageUrl;
  
  bool isKitchenVisible;

  bool agreedBackgroundCheck;

  bool hasBeenBackgroundChecked;

  KitchenType kitchenType;

  //verifying their qualifications
  bool isQualificationsVerified;

  num? averageRatings;
  int? totalRatings;

  //takes in list of reviews
  List<RatingAndReview>? reviewsList = [];
  String? primaryContactFullName;
  List<Menu>? menusList;


  //Cook's specialty- African, Italian, Spanish etc Also Known as Tags
  List<dynamic>? foodSpecialtyList = [];

  //how much does the cook charge
  String? chargeRateString;
  num chargeRate;
  String? chargeRateType;
  bool isChargeNegotiable;
  bool receivePrivateMessages;

  //current country where service is being provided
  Address? serviceLocation;
  List<dynamic>? certificationsList = [];

  //work experience
  List<dynamic>? workExperienceList = [];

  List<BookingSlot> kitchenBookingSlots = [];

  Map<String, dynamic>? kitchenSkillsRating;
  Map<String, dynamic>? ratingGroup;
  FoodDeliveryOption deliveryOption;


  List<WorkExperienceControllerModel>? workExperienceListControllers = [];
  List<CertificationsController>? certificationsListControllers = [];

  //shows that this kitchen's home has been licensed for operations
  bool isLicensed;

  //shows that this kitchen government-issued id has been verified
  bool isVerified;

  //shows that the kitchen has received a food training certification
  bool isFoodSafetyCertified;

  String? foodSafetyCertificationAgency;

  String? foodHandlerCertificationDocUrl;

  String? foodLicenseOrPermitDocUrl;



  Kitchen({
    this.description,
    this.kitchenId,
    this.kitchenCoverImageUrl,
    this.kitchenProfileImageUrl,
    this.isKitchenVisible = true,
    this.isLicensed = false,
    this.isVerified = false,
    this.isFoodSafetyCertified = false,
    this.foodSafetyCertificationAgency,
    this.deliveryOption = FoodDeliveryOption.deliveryAndPickup,
    this.isQualificationsVerified = false,
    this.isChargeNegotiable = true,
    this.receivePrivateMessages = true,
    this.averageRatings = 5.0,
    this.reviewsList,
    this.chargeRateType,
    this.kitchenType = KitchenType.ghostKitchen,
    this.chargeRate = 0,
    this.totalRatings = 1,
    this.chargeRateString,
    this.workExperienceList,
    this.certificationsList,
    this.kitchenSkillsRating,
    this.foodSpecialtyList,
    this.agreedBackgroundCheck = true,
    this.hasBeenBackgroundChecked = false,
    this.certificationsListControllers,
    this.workExperienceListControllers,
    this.serviceLocation,
    this.ratingGroup,
    this.menusList,
    this.foodHandlerCertificationDocUrl,
    this.foodLicenseOrPermitDocUrl,
    this.kitchenName,
    this.kitchenUserName,
    this.primaryContactFullName
  });


  factory Kitchen.fromMap(Map<String, dynamic> data) {
    Kitchen kitchen = Kitchen(
      isKitchenVisible: data['isKitchenVisible'] ?? true,
      kitchenId: data['kitchenId'],
      isLicensed: data['isLicensed'] ?? true,
      isVerified: data['isVerified'] ?? true,
      isFoodSafetyCertified: data['isFoodSafetyCertified'] ?? true,
      foodSafetyCertificationAgency: data['foodSafetyCertificationAgency'] ?? null,
      isQualificationsVerified: data['isQualificationsVerified'] ?? false,
      isChargeNegotiable: data['isChargeNegotiable'] ?? false,
      receivePrivateMessages: data['receivePrivateMessages'] ?? false,
      agreedBackgroundCheck: data['agreedBackgroundCheck'] ?? false,
      hasBeenBackgroundChecked: data['hasBeenBackgroundChecked'] ?? false,
      averageRatings: data['averageRatings'],
      // reviewsList: data['reviewsList'],
      chargeRate: data['chargeRate'],

      chargeRateString: data['chargeRateString'],
      chargeRateType: data['chargeRateType'],
      certificationsList: data['certificationsList'],
      workExperienceList: data['workExperienceList'],
      kitchenSkillsRating: data['kitchenSkillsRating'] ?? null,
      ratingGroup: data['ratingGroup'] ?? null,
      foodSpecialtyList: data['foodSpecialtyList'] != null ? data['foodSpecialtyList'].map((e) => e.toLowerCase()).toList() : null,
      description: data['description'],
      kitchenProfileImageUrl: data['kitchenProfileImageUrl'],
      kitchenCoverImageUrl: data['kitchenCoverImageUrl'],
      totalRatings: data['totalRatings'],
      kitchenName: data['kitchenName'],
      kitchenUserName: data['kitchenName'] != null ? (data['kitchenName'] as String).toLowerCase().replaceAll(' ', '-').replaceAll("'", '') : '',
      serviceLocation: data['serviceLocation'] != null ? Address.fromMap(data['serviceLocation']) : null,
      foodHandlerCertificationDocUrl: data['foodHandlerCertificationDocUrl'],
      foodLicenseOrPermitDocUrl: data['foodLicenseOrPermitDocUrl'],
      primaryContactFullName: data['primaryContactFullName'],
      deliveryOption: data['deliveryOption'] !=  null ? FoodDeliveryOption.values.firstWhere((e) => e.name == (data['deliveryOption']).toString(), orElse: () => FoodDeliveryOption.deliveryAndPickup) : FoodDeliveryOption.deliveryAndPickup,
      kitchenType: data['kitchenType'] !=  null ? KitchenType.values.firstWhere((e) => e.name == (data['kitchenType']).toString(), orElse: () => KitchenType.ghostKitchen) : KitchenType.ghostKitchen,

    );
    

    return kitchen;
  }


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'isKitchenVisible': this.isKitchenVisible,
      'kitchenId': this.kitchenId,
      'isQualificationsVerified': this.isQualificationsVerified,
      'isLicensed': this.isLicensed,
      'isVerified': this.isVerified,
      'isFoodSafetyCertified': this.isFoodSafetyCertified,
      'foodSafetyCertificationAgency': this.foodSafetyCertificationAgency,
      'averageRatings': this.averageRatings,
      'totalRatings': this.totalRatings,
      'kitchenName': this.kitchenName,
      'primaryContactFullName': this.primaryContactFullName,
      // 'reviewsList': this.reviewsList,
      'chargeRate': this.chargeRate,
      'chargeRateString': this.chargeRateString,
      'chargeRateType': this.chargeRateType,
      'certificationsList': this.certificationsList,
      'workExperienceList': this.workExperienceList,
      'kitchenSkillsRating': this.kitchenSkillsRating,
      'ratingGroup': this.ratingGroup,
      'foodSpecialtyList': this.foodSpecialtyList,
      'description': this.description,
      'kitchenCoverImageUrl': this.kitchenCoverImageUrl,
      'kitchenProfileImageUrl': this.kitchenProfileImageUrl,
      'receivePrivateMessages': this.receivePrivateMessages,
      'agreedBackgroundCheck': this.agreedBackgroundCheck,
      'hasBeenBackgroundChecked': this.hasBeenBackgroundChecked,
      'deliveryOption':this.deliveryOption.name,
      'kitchenType':this.kitchenType.name,

    };
    if(serviceLocation != null) {
      map['serviceLocation'] = serviceLocation!.toMap();
    }
    else {
      map['serviceLocation'] = null;
    }
    return map;

  }


  Map<String, dynamic> updateKitchenToMap(List<Map<String, dynamic>> workExperience, List<Map<String, dynamic>> certifications, ) {
    Map<String, dynamic> map = {
      'isQualificationsVerified': this.isQualificationsVerified,
      'isKitchenVisible': this.isKitchenVisible,
      'isLicensed': this.isLicensed,
      'isVerified': this.isVerified,
      'isFoodSafetyCertified': this.isFoodSafetyCertified,
      'foodSafetyCertificationAgency': this.foodSafetyCertificationAgency,
      'chargeRate': this.chargeRate,
      'chargeRateString': this.chargeRateString,
      'chargeRateType': this.chargeRateType,
      'certificationsList': this.certificationsList,
      'workExperienceList': this.workExperienceList,
      'kitchenSkillsRating': this.kitchenSkillsRating,
      'foodSpecialtyList': this.foodSpecialtyList,
      'description': this.description,
      'kitchenProfileImageUrl': this.kitchenProfileImageUrl,
      'kitchenCoverImageUrl': this.kitchenCoverImageUrl,
      'deliveryOption':this.deliveryOption.name,
      'isChargeNegotiable': this.isChargeNegotiable,
      'receivePrivateMessages': this.receivePrivateMessages,
      'agreedBackgroundCheck': this.agreedBackgroundCheck,
      'hasBeenBackgroundChecked': this.hasBeenBackgroundChecked,
      'kitchenName': this.kitchenName,
      'primaryContactFullName': this.primaryContactFullName
    };

    if(serviceLocation != null) {
      map['serviceLocation'] = serviceLocation!.toMap();
    }
    else {
      map['serviceLocation'] = null;
    }
    return map;
  }
}
