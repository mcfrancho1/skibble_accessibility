
import 'package:hive/hive.dart';
import 'package:skibble/models/skibble_post_comment.dart';
import 'package:skibble/models/skibble_user.dart';

import 'ingredient.dart';
// part 'recipe.g.dart';


// @HiveType(typeId: 1)
class Recipe {
  // @HiveField(0)
  String title;

  // @HiveField(1)
  String? description;

  // @HiveField(2)
  Map<String, dynamic>? recipeSource;

  // @HiveField(3)
  String? recipeImageUrl;

  // @HiveField(4)
  String? recipeVideoUrl;

  // @HiveField(5)
  String? recipeVideoThumbnailUrl;

  // @HiveField(6)
  List<Ingredient>? ingredients;

  List? ingredientsList;

  //type string
  // @HiveField(7)
  List? instructions;

  //type string
  // @HiveField(8)
  List? foodTags;

  // @HiveField(9)
  String? recipeId;

  // @HiveField(10)
  String? creatorId;

  //in hrs
  // @HiveField(11)
  int? prepTimeInHrs;

  //mins
  // @HiveField(12)
  int? prepTimeInMins;

  // @HiveField(13)
  int? servings;

  // @HiveField(14)
  int? timeCreated;

  // @HiveField(15)
  num totalLikes;

  // @HiveField(16)
  num totalViews;

  // @HiveField(17)
  num currentViewsDocTotalViews;

  // @HiveField(18)
  num totalComments;

  // @HiveField(19)
  String? currentViewsDocId;

  // @HiveField(20)
  List<SkibblePostComment>? commentsList;

  // @HiveField(21)
  Set<String>? likesList = {};

  //this will help me keep track of the likes in a document
  // @HiveField(22)
  Map<String, List<String>>? likesDocMap;

  // @HiveField(23)
  Map<String, dynamic>? likesDocMapCount;
  SkibbleUser? creatorUser = SkibbleUser(fullName: '', userName: '');



  Recipe({
    required this.title,
    required this.creatorUser,
    this.recipeSource,
    this.description,
    this.recipeImageUrl,
    this.recipeVideoUrl,
    this.recipeVideoThumbnailUrl,
    this.ingredients,
    this.instructions,
    this.prepTimeInHrs,
    this.prepTimeInMins,
    this.servings,
    this.timeCreated,
    this.creatorId,
    this.recipeId,
    this.foodTags,
    this.totalComments = 0,
    this.totalLikes = 0,
    this.likesList,
    this.ingredientsList,
    this.commentsList,
    this.totalViews = 0,
    this.currentViewsDocId = 'views_1',
    this.currentViewsDocTotalViews = 0,
    this.likesDocMap,
    this.likesDocMapCount
  });


  factory Recipe.fromMap(Map<String, dynamic> data) {
    Recipe recipe = Recipe(
      title: data['title'] ?? '',
      creatorUser: data['creatorUser'] != null ? SkibbleUser.fromMap(Map<String, dynamic>.from(data['creatorUser'])) : SkibbleUser(fullName: '', userName: ''),
      description: data['description'] ,
      recipeImageUrl: data['recipeImageUrl'],
      recipeVideoUrl: data['recipeVideoUrl'],
      recipeVideoThumbnailUrl: data['recipeVideoThumbnailUrl'],
      instructions: data['instructions'] != null ? data['instructions'] : [],
      prepTimeInHrs: data['prepTimeInHrs'] != null ? data['prepTimeInHrs'] : null,
      prepTimeInMins: data['prepTimeInMins'] != null ? data['prepTimeInMins'] : null,
      servings: data['servings'] != null ? data['servings'] : null,
      timeCreated: data['timeCreated'] != null ? DateTime.fromMillisecondsSinceEpoch(data['timeCreated']).toLocal().millisecondsSinceEpoch : null,
      recipeSource: Map<String, dynamic>.from(data['recipeSource'] ?? {}),
      recipeId: data['recipeId'],
      creatorId: data['creatorId'],
      foodTags: data['foodTags'],
      totalLikes: data["totalLikes"] ?? 0,
      totalComments: data["totalComments"] ?? 0,
      // likesDocMap: {},
      likesList: data['likesList'] ?? {},
      commentsList: data["commentsList"],
      totalViews: data['totalViews'] ?? 0,
      currentViewsDocTotalViews: data['currentViewsDocTotalViews'] ?? 0,
      currentViewsDocId: data['currentViewsDocId'] ?? 'views_1',
      // ingredientsList: data['ingredientsList'],
      // likesDocMapCount: data['likesDocMapCount'] != null ? ((Map<String, dynamic>.from(data['likesDocMapCount'])).map((key, value) => MapEntry(key, value))) : {'likes_1': 0},
    );

    if(data['ingredients'] != null) {
      List<Ingredient> ingredients = [];
      data['ingredients'].forEach((e) => ingredients.add(Ingredient.fromMap(Map<String, dynamic>.from(e))));

      recipe.ingredients = ingredients;
    }
    return recipe;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'recipeImageUrl': recipeImageUrl,
      'creatorUser': creatorUser!.toPublicProfileMap(),
      'recipeVideoUrl': recipeVideoUrl,
      'recipeVideoThumbnailUrl': recipeVideoThumbnailUrl,
      'instructions': instructions,
      'ingredients': ingredients != null ? ingredients!.map((e) => e.toMap()).toList() : [],
      'prepTimeInHrs': prepTimeInHrs,
      'prepTimeInMins': prepTimeInMins,
      'servings': servings,
      'timeCreated': DateTime.fromMillisecondsSinceEpoch(timeCreated!).toUtc().millisecondsSinceEpoch,
      'recipeSource': recipeSource,
      'recipeId' :recipeId,
      'creatorId': creatorId,
      'foodTags': foodTags,
      "totalComments": totalComments,
      "totalLikes": totalLikes,
      "commentsList": commentsList,
      'ingredientsList': ingredientsList,
      'totalViews': totalViews,
      'currentViewsDocTotalViews': currentViewsDocTotalViews,
      'currentViewsDocId': currentViewsDocId,
      'likesDocMapCount': likesDocMapCount ?? {'likes_1': 0}
    };
  }
}