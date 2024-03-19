import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/feed_controller.dart';
import 'package:skibble/controllers/file_controller.dart';
import 'package:skibble/controllers/loading_controller.dart';
import 'package:skibble/models/recipe.dart';
import 'package:skibble/models/skibble_post.dart';
import 'package:skibble/models/stream_models/followers_stream.dart';
import 'package:skibble/models/stream_models/liked_skibs_stream.dart';
import 'package:skibble/services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/address.dart';
import '../models/feed_post.dart';
import '../models/skib_entity.dart';
import '../models/skibble_file.dart';
import '../models/skibble_user.dart';
import '../models/moment.dart';
import '../services/change_data_notifiers/app_data.dart';
import '../services/change_data_notifiers/custom_feed.dart';
import '../services/change_data_notifiers/feed_data.dart';
import '../services/change_data_notifiers/picker_data/location_picker_data.dart';
import '../services/change_data_notifiers/skibs_data.dart';
import '../services/firebase/custom_collections_references.dart';
import '../services/firebase/database/feed_database.dart';
import '../services/firebase/database/recipe_database.dart';
import '../services/firebase/database/user_database.dart';
import '../services/firebase/skibble_functions_handler.dart';
import '../services/firebase/storage.dart';
import '../shared/custom_file_picker/lib/drishya_picker.dart';
import '../utils/constants.dart';
import '../utils/custom_pickers/custom_pickers.dart';


enum FetchState {fetching, doneFetching, idle, error, noMoreData}
class SkibController with ChangeNotifier{

  static const _pageSize = 20;
  late PagingController<int, SkibbleUser> _skibLikesPagingController;
  ScrollController? userSkibsScrollController;
  late PagingController<int, SkibblePost> _userSkibsPagingController;

  late BuildContext _context;
  SkibblePost? _currentSkibLikesBeingViewed;
  bool _isCurrentLikesDoneFetching = false;

  List<SkibbleFile> _currentSkibMediaFiles = [];
  SkibblePost? _currentSkibBeingViewed;

  int maxSkibFiles = 10;

  Map<String, List<SkibbleUser>> skibLikesUsers = {};

  TextEditingController? captionController;
  TextEditingController? addressController;

  final List<String> customLocation = ['My Kitchen', 'School', 'Work'];
  String? selectedCustomLocation;

  Recipe? createSkibRecipe;
  SkibblePost? editingSkibblePost;
  bool isSkibsFetchingLocked = false;

  List<SkibblePost> currentUserSkibs = [];
  Map<String, List<SkibblePost>> userSkibs = {};
  Map<String, int?> userSkibsNextPageKey = {};

  FetchState fetchState = FetchState.idle;

  PagingController<int, SkibbleUser> get skibLikesPagingController => _skibLikesPagingController;
  PagingController<int, SkibblePost> get userSkibsPagingController => _userSkibsPagingController;

  SkibblePost? get currentSkibLikesBeingViewed => _currentSkibLikesBeingViewed;
  SkibblePost? get currentSkibBeingViewed => _currentSkibBeingViewed;
  List<SkibbleFile> get currentSkibMediaFiles => _currentSkibMediaFiles;

  late List<SkibbleUser> tempLikes;


  initSkibGridPaging(BuildContext context, SkibbleUser user,) {
    _userSkibsPagingController = PagingController(firstPageKey: 0);

    _userSkibsPagingController.value = PagingState(
      nextPageKey: userSkibsNextPageKey[user.userId!],
      error: null,
      itemList: userSkibs[user.userId!],
    );
    userSkibsPagingController.addPageRequestListener((pageKey) {
      fetchSkibs(context, user, pageKey);
    });
  }

  refreshController(SkibbleUser user,) {
    // feedList = [];
    // postsFeedList = [];
    // friendSuggestionsList = [];
    // recipesList = [];
    // communitiesList = [];
    // kitchensList = [];
    // _nextFunction = 0;
    // _lastPostFetched = 0;
    // _lastRecipeFetched = 0;
    // _lastCommunityFetched = 0;
    // _lastSuggestionsFetched = 0;
    userSkibs[user.userId!] = [];
    _userSkibsPagingController.refresh();
  }

  Future<void> fetchSkibs(BuildContext context, SkibbleUser user, int pageKey) async {
    try {
      var resList;
      // fetchState = FetchState.fetching;

      if(userSkibs[user.userId] == null) {
        resList = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: null);
        userSkibs[user.userId!] = [];
        userSkibsNextPageKey[user.userId!] = 0;
      }

      else {
        if(userSkibs[user.userId!]!.isEmpty) {

          resList = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: null);
        }

        else {

          //last page had been fetched
          if(userSkibsNextPageKey[user.userId!] != null) {

            resList = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: userSkibs[user.userId]!.last.postId);

          }

        }
      }

      final isLastPage = resList.length < _pageSize;

      if (isLastPage) {
        userSkibsNextPageKey[user.userId!] = null;

        _userSkibsPagingController.appendLastPage(resList);
      }

      else {
        final nextPageKey =  (pageKey + resList.length) as int;
        userSkibsNextPageKey[user.userId!] = nextPageKey;
        _userSkibsPagingController.appendPage(resList, nextPageKey);
      }


      // fetchState = FetchState.doneFetching;
      // for(var item in resList){
      //   debugPrint(item.postId);
      // }
      userSkibs[user.userId!]!.addAll(resList);
    }

    catch(e) {
      _userSkibsPagingController.error = e;
    }
  }


  // Future<void> fetchSkibs(BuildContext context, SkibbleUser user,) async {
  //   var resList;
  //   fetchState = FetchState.fetching;
  //
  //   if(!isSkibsFetchingLocked) {
  //     if(userSkibs[user.userId] == null) {
  //       resList = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: null);
  //       userSkibs[user.userId!] = [];
  //     }
  //
  //     else {
  //       if(userSkibs[user.userId!]!.isEmpty) {
  //
  //         resList = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: null);
  //
  //       }
  //
  //       else {
  //         resList = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: userSkibs[user.userId]!.last.postId);
  //       }
  //     }
  //   }
  //   else {
  //     resList = <SkibblePost>[];
  //   }
  //
  //
  //   print(resList.length);
  //
  //   fetchState = FetchState.doneFetching;
  //   for(var item in resList){
  //     debugPrint(item.postId);
  //   }
  //
  //
  //   userSkibs[user.userId!]!.addAll(resList);
  //   notifyListeners();
  // }



  initCreateSkib(BuildContext context) {
    captionController = TextEditingController();
    addressController = TextEditingController();
    _context = context;
    // _context.read<LocationPickerData>().pickedLocation = null;
  }

  initEditSkib(BuildContext context, SkibblePost skibblePost, SkibbleUser currentUser) async{
    captionController = TextEditingController();
    addressController = TextEditingController();
    _context = context;
    editingSkibblePost = skibblePost;

    // fileFutures =  processEntities();
    captionController!.text = editingSkibblePost!.caption;
    currentSkibMediaFiles.addAll(editingSkibblePost!.postContentList ?? []);
    if(editingSkibblePost!.postTags != null) {
      _context.read<FoodOptionsPickerData>().userChoices.addAll(List<String>.from(editingSkibblePost!.postTags!));
    }

    if(editingSkibblePost!.postAddress != null) {
      addressController!.text = editingSkibblePost!.postAddress!.placeName! + ", " + editingSkibblePost!.postAddress!.formattedAddress!;
      _context.read<LocationPickerData>().pickedLocation = editingSkibblePost!.postAddress;

    }

    if(editingSkibblePost!.attachedRecipeId != null) {
      // figure out the recipe here
      createSkibRecipe = await RecipeDatabaseService().getRecipeInfo(editingSkibblePost!.attachedRecipeId!);
          // Recipe(title: '', recipeId: editingSkibblePost!.attachedRecipeId, creatorId: currentUser.userId, creatorUser: currentUser);
    }

    if(skibblePost.customLocation != null) {
      selectedCustomLocation = skibblePost.customLocation;
    }

    // _context.read<LocationPickerData>().pickedLocation = null;

  }

  cancelSkibEditOrCreate(BuildContext context) {
    context.read<LocationPickerData>().pickedLocation = null;
    clearSkibMediaFiles();
    context.read<FoodOptionsPickerData>().reset();
    createSkibRecipe = null;
  }

  disposeCreateSkibControllers(){
    captionController?.dispose();
    addressController?.dispose();
  }

  insertNewCreatedSkibInUserSkibsList(SkibblePost post, String userId) {
    if(userSkibs[userId] == null) {
      userSkibs[userId] = [];
    }
    userSkibs[userId]!.insert(0, post);
  }

  changeEditedSkibInUserSkibsList(SkibblePost post, String userId) {

    //make sure the user has skibs
    if(userSkibs[userId] != null) {
      var foundSkibIndex = userSkibs[userId]!.indexWhere((element) => element.postId == post.postId,);

      if(foundSkibIndex != -1) {
        userSkibs[userId]![foundSkibIndex] = post;
        notifyListeners();
      }
    }
  }

  deleteSkibInUserSkibsList(SkibblePost post, String userId) {
    if(userSkibs[userId] != null) {
      var foundSkibIndex = userSkibs[userId]!.indexWhere((element) => element.postId == post.postId,);

      if(foundSkibIndex != -1) {
        userSkibs[userId]!.removeAt(foundSkibIndex);
      }

      notifyListeners();
    }

  }


  initSkibLikesPageController(CollectionReference reference, BuildContext context) {
    _skibLikesPagingController = PagingController(firstPageKey: 0);
    // _isCurrentLikesDoneFetching = false;
    _context = context;
    tempLikes = [];
    _skibLikesPagingController.addPageRequestListener((pageKey) {
      _fetchLikesPage(pageKey, reference);
    });
  }


  setLocation(BuildContext context, bool unSelect, {int? index, Address? address}) async{
    if(index != null) {
      if(unSelect) {
        selectedCustomLocation = null;
      }

      else {
        selectedCustomLocation = customLocation[index];
      }
      addressController?.text = '';
      context.read<LocationPickerData>().pickedLocation = null;
    }

    else {
      addressController?.text = address!.placeName!;
      selectedCustomLocation = address!.placeName!;
    }
    notifyListeners();
  }


  void set currentSkibMediaFiles(List<SkibbleFile> files) {
    _currentSkibMediaFiles = files;
    notifyListeners();
  }

  void set setCreateRecipe(Recipe? recipe) {
    createSkibRecipe = recipe;
    notifyListeners();
  }

  void addSkibMediaFile(SkibbleFile file) {
    _currentSkibMediaFiles.add(file);
    notifyListeners();
  }

  void clearSkibMediaFiles() {
    _currentSkibMediaFiles.clear();
    notifyListeners();
  }

  void addAllSkibMediaFiles(List<SkibbleFile> files) {
    _currentSkibMediaFiles.addAll(files);
    notifyListeners();
  }

  // Future<void> addAllSkibMediaAssetEntities(List<AssetEntity> assets) async{
  //   for(var asset in assets) {
  //     var file = await asset.file;
  //     if(file != null) {
  //       _currentSkibMediaFiles.add(file);
  //     }
  //   }
  //   notifyListeners();
  // }


  void removeSkibMediaFileAtIndex(int index) {
    _currentSkibMediaFiles.removeAt(index);
    notifyListeners();
  }

  Future<void> editImage(int index) async{
    var path = await FilePickerController().openPhotoEditor(_currentSkibMediaFiles[index].file!);

    if(path != null) {

      var compressedFile = await FilePickerController().compressFile(File(path));
      if(compressedFile != null) {
        _currentSkibMediaFiles[index].file = compressedFile;
      }
      notifyListeners();
    }
  }


  Future<void> editVideo(int index) async{
    var path = await FilePickerController().openVideoEditor(_currentSkibMediaFiles[index].file!);

    if(path != null) {
      _currentSkibMediaFiles[index].file = File(path);
      notifyListeners();
    }
  }

  Future<void> selectSkibFilesFromCamera(BuildContext context, ) async{
    var entities = await FilePickerController().pickImageFromCamera(context,);

    if(entities != null) {
      _context.read<LoadingController>().isLoading = true;
      var skibbleFiles = await FilePickerController().processPickedAssetEntities(context, entities);
      _currentSkibMediaFiles.addAll(skibbleFiles);
      _context.read<LoadingController>().isLoading = false;
      notifyListeners();
    }
  }
  Future<void> selectSkibFilesFromGallery(BuildContext context, ) async{
    var entities = await FilePickerController().pickImageOrVideoFilesFromGallery(context, count: maxSkibFiles - currentSkibMediaFiles.length);

    if(entities != null) {
      _context.read<LoadingController>().isLoading = true;
      var skibbleFiles = await FilePickerController().processPickedAssetEntities(context, entities);
      _currentSkibMediaFiles.addAll(skibbleFiles);
      _context.read<LoadingController>().isLoading = false;
      notifyListeners();
    }
  }

  void set currentSkibLikesBeingViewed(SkibblePost? post) {
    _currentSkibLikesBeingViewed = post;
    notifyListeners();
  }


  void set currentSkibBeingViewed(SkibblePost? post) {
    _currentSkibBeingViewed = post;
    notifyListeners();
  }

  void addUserLikesForSkibs (String postId, List<SkibbleUser> users) {
    if(skibLikesUsers[postId] == null) {
      skibLikesUsers[postId] = [];
    }

    skibLikesUsers[postId]?.addAll(users);
    notifyListeners();
  }

  //gets a list of likes based on the page size
  List<SkibbleUser> getLikesForPost(String postId, {int? nextPageKey}) {
    if(nextPageKey == null) {
      return [];
    }
    else if(skibLikesUsers[postId] != null) {
      return skibLikesUsers[postId]!;
      // .sublist(nextPageKey, (nextPageKey + _pageSize) > skibLikesUsers[postId]!.length ? skibLikesUsers[postId]!.length : (nextPageKey + _pageSize));
    }
    else {

      return [];
    }
  }

  void disposeController() {
    _skibLikesPagingController.dispose();
  }

  Future<void> _fetchLikesPage(int pageKey, CollectionReference reference) async {
    try {
      var post = _context.read<SkibsData>().currentSkibLikesBeingViewed != null ? _context.read<SkibsData>().currentSkibLikesBeingViewed : null;

      var storedLikes = getLikesForPost(post != null ? post.postId! : '', nextPageKey: pageKey);
      List<SkibbleUser> likes = [];

      if(pageKey == 0 && storedLikes.isEmpty) {
        likes =  await UserDatabaseService().getUsersInfoWithCollectionRef(reference, _pageSize);
        tempLikes.addAll(likes);
        addUserLikesForSkibs(post!.postId!, likes);
      }

      //this runs because storedLikes is empty at first
      else {

        likes =  await UserDatabaseService().getOlderUsersInfoWithCollectionRef(reference, storedLikes.last.userId!, _pageSize);
        if(likes.isNotEmpty) {
          if(likes.last.userId != storedLikes.last.userId) {
            addUserLikesForSkibs(post!.postId!, likes);
          }
        }
        likes = skibLikesUsers[post!.postId]!.sublist(pageKey, (pageKey + _pageSize) > skibLikesUsers[post.postId]!.length ? skibLikesUsers[post.postId]!.length : (pageKey + _pageSize));;
        tempLikes.addAll(likes);
      }

      //make the database call
      // if(storedLikes.isEmpty) {
      //   debugPrint('here');
      //   if(pageKey == 0) {
      //     likes =  await UserDatabaseService().getUsersInfoWithCollectionRef(reference, _pageSize);
      //     tempLikes.addAll(likes);
      //   }
      //
      //   //this runs because storedLikes is empty at first
      //   else {
      //     likes =  await UserDatabaseService().getOlderUsersInfoWithCollectionRef(reference, tempLikes.last.userId!, _pageSize);
      //     tempLikes.addAll(likes);
      //     debugPrint('ran here');
      //   }
      //   if(post != null) {
      //     if (storedLikes.isEmpty) {
      //       addUserLikesForSkibs(post.postId!, likes);
      //     }
      //   }
      //
      // }
      // else {
      //   likes =  await UserDatabaseService().getOlderUsersInfoWithCollectionRef(reference, storedLikes.last.userId!, _pageSize);
      //   debugPrint('likes length: ${likes.length}');
      //
      //   if(likes.isNotEmpty ) {
      //
      //     if(likes.last.userId != storedLikes.last.userId) {
      //       addUserLikesForSkibs(post.postId!, likes);
      //       storedLikes.addAll(likes);
      //     }
      //
      //   }
      //   likes = storedLikes;
      //
      // }

      final isLastPage = likes.length < _pageSize;

      if (isLastPage) {
        _skibLikesPagingController.appendLastPage(likes);
        _isCurrentLikesDoneFetching = true;

      }

      else {
        final nextPageKey = (pageKey + likes.length).toInt();
        _skibLikesPagingController.appendPage(likes, nextPageKey);
      }

    } catch (error) {
      debugPrint(error.toString());
      _skibLikesPagingController.error = error;
    }
  }

  /**
   * Helper function to process the entities and upload the files to cloud storage
   */
  Future<Map<String, dynamic>?> processEntitiesToFiles(SkibblePost post, List<SkibEntity> skibEntities) async{

    try {
      post.postContentList = [];
      post.timePosted = DateTime.now().millisecondsSinceEpoch;
      List<File> files = [];
      List<File>? thumbnailFiles = [];
      //process asset entities
      for(SkibEntity skibEntity in skibEntities) {
        // File? file = await skibEntity.assetEntity.file;
        files.add(skibEntity.file!);

        if(skibEntity.fileType == AssetType.video) {

          var thumbnail = await VideoThumbnail.thumbnailData(
            video: skibEntity.file!.path,
            imageFormat: ImageFormat.JPEG,
            // maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
            quality: 90,
          );

          var tempDir = (await getTemporaryDirectory()).path + "/";
          File thumbnailFile = await File(tempDir + 'video_thumbnail${DateTime.now().millisecondsSinceEpoch}.jpeg').create();
          thumbnailFile = await thumbnailFile.writeAsBytes(thumbnail!);
          thumbnailFiles.add(thumbnailFile);
        }

        post.postContentList!.add(
            SkibbleFile(fileType: SkibbleFileType.values.firstWhere((element) => element.name == skibEntity.fileType!.name), isContentSafetyVerified: false)
        );
      }

      final DocumentReference documentReference = FirebaseCollectionReferences.postsCollection.doc();

      Map<String, List<String?>?>? listDownloadUrlsMap = await StorageService().uploadPost(post, files, documentReference.id, thumbnailFiles: thumbnailFiles);

      post.postId = documentReference.id;
      //store the urls
      int i = 0;
      int tCount = 0;
      post.postContentList!.forEach((map) {
        map.mediaUrl = listDownloadUrlsMap!['contents']![i];

        if(map.fileType == SkibbleFileType.video) {
          map.videoThumbnailUrl = listDownloadUrlsMap['thumbnails']![tCount];
          tCount++;
        }
        i++;
      });

      return {
        'post': post,
        "files": files,
        'thumbnailFiles': thumbnailFiles,
      };
    }
    catch(e) {
      return null;
    }
  }

  /// NEW
  Future<SkibblePost?> createNewSkib(BuildContext context, SkibbleUser currentUser) async{
    try {
      //check if content is safe
      // var isSafe =
      var unsafeIndex = currentSkibMediaFiles.indexWhere((element) => !element.isContentSafetyVerified, );

      if(unsafeIndex == -1) {
        SkibblePost post = SkibblePost(
            caption: captionController!.text,
            postAddress: context.read<LocationPickerData>().pickedLocation,
            postAuthorId: currentUser.userId!,
            creatorUser: currentUser,
            customLocation: selectedCustomLocation,
            attachedRecipeId: createSkibRecipe != null ? createSkibRecipe!.recipeId! : null,
            // recipeList: recipeController.text,
            postTags: [],
            likesDocMap: {},
            timePosted: DateTime.now().millisecondsSinceEpoch,
            likesDocMapCount: {'likes_1': 0}
        );

        post.postTags?.addAll(context.read<FoodOptionsPickerData>().userChoices);

        var res = await FeedDatabaseService().uploadSkib(context, post, currentSkibMediaFiles, currentUser);

        if(res != null) {
          post = res;
        }

        insertNewCreatedSkibInUserSkibsList(post, currentUser.userId!);
        // context.read<FeedController>().refreshController();
        context.read<LocationPickerData>().pickedLocation = null;
        context.read<FoodOptionsPickerData>().reset();
        createSkibRecipe = null;
        return res;
      }
      else {
        String value = unsafeIndex == 0 ? '1st': unsafeIndex == 1 ? '2nd': unsafeIndex == 2 ? '3rd' : '${unsafeIndex + 1}th';
        Fluttertoast.showToast(
            msg: "Please change your $value content",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM_LEFT,
            // timeInSecForIosWeb: 1,
            backgroundColor: kDarkSecondaryColor,
            textColor: Colors.white,
            fontSize: 14.0
        );
        return null;
      }

    }
    catch(e) {
      debugPrint(e.toString());
      return null;
    }
  }


  Future<SkibblePost?> updateSkibblePost(SkibbleUser currentUser, BuildContext context) async {

    CustomDialog(context).showProgressDialog(context, 'Updating skib...');
    editingSkibblePost!.postTags = [];
    editingSkibblePost!.caption = captionController!.text;
    editingSkibblePost!.postAddress = context.read<LocationPickerData>().pickedLocation;
    editingSkibblePost!.customLocation = selectedCustomLocation;
    editingSkibblePost!.attachedRecipeId = createSkibRecipe != null ? createSkibRecipe!.recipeId! : null;
    editingSkibblePost!.postTags?.addAll(context.read<FoodOptionsPickerData>().userChoices);
    editingSkibblePost!.creatorUser = currentUser;
    // await FeedDatabaseService().createTags();
    var result = await FeedDatabaseService().updateSkibblePost(editingSkibblePost!, context);

    // debugPrint(editingSkibblePost!.postContentList);
    Navigator.pop(context);
    if(result != null) {
      // context.read<FeedController>().refreshController();
      changeEditedSkibInUserSkibsList(editingSkibblePost!, result.postAuthorId);

      context.read<LocationPickerData>().pickedLocation = null;

      context.read<FoodOptionsPickerData>().reset();
      createSkibRecipe = null;
      // Provider.of<FeedData>(context, listen: false).updateSkibInUserFeed(editingSkibblePost!);
      // Provider.of<FeedData>(context, listen: false).updatePostInCurrentUserPosts(editingSkibblePost!);
    }
    return result;

  }


  /**
   * Uploads the new post to cloud firestore after getting the url to the files in storage
   */
  Future<void> postContent(SkibblePost post, Map<String, dynamic> map, context, SkibbleUser currentUser) async{

    try {
      // CustomDialog(context).showProgressDialog('Adding final touches...');

      CustomBottomSheetDialog.showProgressSheet(context);

      //TODO: Write a cloud function to add user recent posts to user doc
      SkibblePost? result = await FeedDatabaseService().uploadSkibblePostWithUrls(context, post, currentUser, thumbnailFiles: (map['thumbnailFiles']).isNotEmpty ? map['thumbnailFiles'] : null);


      if(result == null) {
        Navigator.pop(context);

        CustomDialog(context).showErrorDialog('Error', 'Unable to upload your skib at the moment.');
      }
      else {
        Provider.of<AppData>(context, listen: false).addToUserSkib(result.postId!, result.timePosted!);
        Provider.of<FeedData>(context, listen: false).addNewPostsToUserPosts(result);
        Provider.of<FeedData>(context, listen: false).addNewPostsToUserFeed([FeedPost(feedPostType: FeedPostType.skib, feedPostId: result.postId!, timeCreated: result.timePosted,post: result)]);
        // var pageController = Provider.of<FeedData>(context, listen: false).pagingController;
        // pageController.refresh();



        // Provider.of<CustomFeedData>(context, listen: false).addNewPostsToUserFeed([FeedPost(feedPostType: FeedPostType.skib, feedPostId: post.postId!, timeCreated: post.timePosted!)]);

        // Provider.of<FeedData>(context, listen: false).addNewPostsToUserPosts(result);
        // Provider.of<FeedData>(context, listen: false).addNewPostsToUserFeed([FeedPost(feedPostType: FeedPostType.skib, feedPostId: result.postId!, post: result, timeCreated: result.timePosted)]);

        // for(var skibEntity in skibEntities) {
        //   if(skibEntity.isRecentlyCreated && Platform.isAndroid) {
        //     // final List<String> result =
        //     await PhotoManager.editor.deleteWithIds(
        //       <String>[skibEntity.assetEntity.id],
        //     );
        //   }
        // }
        Navigator.pop(context);

        CustomBottomSheetDialog.showSuccessSheet(context, 'Your skib has been posted!', onButtonPressed: () {
          Navigator.pop(context);
          if(Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          if(Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    }
    catch(e) {
      debugPrint(e.toString());
    }
    // CustomDialog(context).showCustomMessage('Success', 'Your post has been uploaded successfully');
  }

  /**
   * Uploads the post by storing in cloud storage first and then uploading to cloud firestore
   */
  Future<void> postContentWithEntities(SkibblePost post, List<SkibEntity> skibEntities, context, SkibbleUser currentUser) async{

    try {
      CustomDialog(context).showProgressDialog(context, 'Almost Done...');

      post.postContentList = [];
      post.timePosted = DateTime.now().millisecondsSinceEpoch;
      List<File> files = [];
      List<File>? thumbnailFiles = [];
      //process asset entities
      for(SkibEntity skibEntity in skibEntities) {
        // File? file = await skibEntity.assetEntity.file;
        files.add(skibEntity.file!);

        if(skibEntity.fileType == AssetType.video) {

          var thumbnail = await VideoThumbnail.thumbnailData(
            video: skibEntity.file!.path,
            imageFormat: ImageFormat.JPEG,
            // maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
            quality: 90,
          );

          var tempDir = (await getTemporaryDirectory()).path + "/";
          File thumbnailFile = await File(tempDir + 'video_thumbnail${DateTime.now().millisecondsSinceEpoch}.jpeg').create();
          thumbnailFile = await thumbnailFile.writeAsBytes(thumbnail!);
          thumbnailFiles.add(thumbnailFile);
        }
        post.postContentList!.add(
            SkibbleFile(fileType: SkibbleFileType.values.firstWhere((element) => element.name == skibEntity.fileType!.name), isContentSafetyVerified: false)

        );
      }


      //TODO: Write a cloud function to add user recent posts to user doc
      SkibblePost? result = await FeedDatabaseService().uploadSkibblePost(post, files, currentUser, thumbnailFiles: thumbnailFiles.isNotEmpty ? thumbnailFiles : null);


      if(result == null) {
        Navigator.pop(context);

        CustomDialog(context).showErrorDialog('Error', 'Unable to upload your skib at the moment.');
      }
      else {
        Provider.of<AppData>(context, listen: false).addToUserSkib(result.postId!, result.timePosted!);
        Provider.of<FeedData>(context, listen: false).addNewPostsToUserPosts(result);
        Provider.of<FeedData>(context, listen: false).addNewPostsToUserFeed([FeedPost(feedPostType: FeedPostType.skib, feedPostId: result.postId!, timeCreated: result.timePosted,post: result)]);


        Navigator.pop(context);
        if(Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    }
    catch(e) {
    }

    // CustomDialog(context).showCustomMessage('Success', 'Your post has been uploaded successfully');
  }

  Future<bool> deletePost(SkibblePost post, context) async{
    try {
      var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
      var followersList = Provider.of<FollowersStream>(context, listen: false).getIds();

      await CustomDialog(context).showConfirmationDialog(
          'Delete Skib',
          'Are you sure you want to delete this skib?',
          onConfirm: () async {
            Navigator.pop(context);

            CustomDialog(context).showProgressDialog(context, 'Deleting skib');

            var result = await SkibbleFirebaseFunctions().callFunction('deleteUserSkib',
                data: {
                  'postId': post.postId,
                  'timePosted': post.timePosted,
                  'postAuthorId': post.postAuthorId,
                  'followers': followersList
                }
            );
            if(result == 'success') {
              deleteSkibInUserSkibsList(post, currentUser.userId!);
              // Provider.of<FeedController>(context, listen: false).deleteSkibInFeed(post);


              // Provider.of<AppData>(context, listen: false).deleteFromUserRecentSkibs(post.postId!);
              // Provider.of<FeedData>(context, listen:  false).deleteSkibPost(post);
              // Provider.of<FeedData>(context, listen:  false).deleteCurrentUserSkibPost(post);

              Navigator.pop(context);

              // CustomDialog(context).showCustomMessage('Skib Deleted Successfully', 'Your skib has been deleted.\nRefresh the screen to see the changes.');
              // if(Navigator.canPop(context))
              //   Navigator.of(context).maybePop();

            }
            else {
              Navigator.pop(context);
              CustomDialog(context).showErrorDialog('Error', 'Unable to delete this skib at the moment. Try again later');
            }

          }
      );

      return true;
    }
    catch(e) {return false;}
  }
  Future<bool> handleLikeAndDislikePost(context, SkibbleUser user, SkibblePost skibblePost) async {

    // var likedSkibs = Provider.of<FeedData>(context, listen: false).likedSkibsList;
    var likedSkibs = Provider.of<LikedSkibsStream>(context, listen: false).getIds();
    //dislike post
      if(likedSkibs.contains(skibblePost.postId)) {
         await FeedDatabaseService().disLikePost(skibblePost, user, context );
        // Provider.of<FeedData>(context, listen: false).deleteFromLikedSkibsList(skibblePost.postId!);

        Provider.of<FeedData>(context, listen: false).dislikeSkibInUserFeed(skibblePost, user.userId!);
        // Provider.of<FeedData>(context, listen: false).dislikeSkibInUserExploreFeed(skibblePost, user.userId!);
        // Provider.of<FeedData>(context, listen: false).dislikeSkibInCurrentUserPosts(skibblePost, user.userId!);


        return false;
      }

      //like  post
      else {
        await FeedDatabaseService().likePost(skibblePost, user, context );
        // Provider.of<FeedData>(context, listen: false).addToLikedSkibsList(skibblePost.postId!);
        Provider.of<FeedData>(context, listen: false).likeSkibInUserFeed(skibblePost, user.userId!);
        // Provider.of<FeedData>(context, listen: false).likeSkibInUserExploreFeed(skibblePost, user.userId!);
        // Provider.of<FeedData>(context, listen: false).likeSkibInCurrentUserPosts(skibblePost, user.userId!);

        return true;

      }

  }

  Future<void> postMoment(String momentFileUri, SkibbleUser currentUser, BuildContext context, {List<int>? colors}) async{
    int timePosted = DateTime.now().millisecondsSinceEpoch;
    File file = File(momentFileUri);
    Moment moment = Moment(
      momentType: MomentType.image,
      momentContent: momentFileUri,
      momentAuthorId: currentUser.userId,
      timePosted: timePosted,
      caption: '',
      momentColors: colors
    );
    // CustomDialog(context).showProgressDialog('Uploading your moment...');
    var result = await FeedDatabaseService().uploadSkibbleMoment(moment, file, currentUser);

    if(result != null) {
      // Navigator.pop(context);
      Provider.of<AppData>(context, listen: false).addMomentToUserMoments(result);
      // CustomDialog(context).showCustomMessage('Success', 'Your moment has been uploaded', onOkayPressed: () async {
      //
      // });

      // Navigator.pop(context);

      if(Navigator.canPop(context)) {
        Navigator.maybePop(context);
      }
    }

    else {
      Navigator.pop(context);

      CustomDialog(context).showErrorDialog('Error', 'Unable to upload your moment. Try again.');
    }
  }

  Future<List<SkibblePost>> fetchCurrentUserPosts(SkibbleUser user,context, {String? lastPostId}) async {
    var isPostFetchedBefore = Provider.of<FeedData>(context, listen: false).isCurrentUserPostsFetchedBefore;
    var currentUserPosts = Provider.of<FeedData>(context, listen: false).currentUserPosts;


    if(!isPostFetchedBefore) {
      var posts = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: null);

      Provider.of<FeedData>(context, listen: false).updateIsCurrentUserPostFetchedBefore(true);
      Provider.of<FeedData>(context, listen: false).initialiseCurrentUserPosts(posts ?? []);

      return posts ?? [];
    }

    else if(isPostFetchedBefore && currentUserPosts.isNotEmpty) {
      var posts = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: lastPostId);
      Provider.of<FeedData>(context, listen: false).addOldPostsToCurrentUserPosts(posts ?? []);

      return posts ?? [];
    }

    return currentUserPosts;
  }

  Future<List<SkibblePost>> fetchCurrentUserOlderPosts(SkibbleUser user, String lastPostId, context) async {
    var posts = await FeedDatabaseService().getUserPosts(user, context, _pageSize, lastDocId: lastPostId);
    Provider.of<FeedData>(context, listen: false).updateIsCurrentUserPostFetchedBefore(true);
    Provider.of<FeedData>(context, listen: false).addOldPostsToCurrentUserPosts(posts ?? []);

    return posts ?? [];
  }

  // /**
  //  * Fetches the posts for the user that is not the current user
  //  */
  // Future<List<SkibblePost>> fetchOtherUserPosts(SkibbleUser user, String lastPostId ,context) async {
  //   var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
  //   var posts = await FeedDatabaseService().getUserPosts(user, context, lastDocId: lastPostId);
  //
  // }
  //
  //
  // /**
  //  * Fetches the posts for the user that is not the current user
  //  */
  // Future<List<SkibblePost>> fetchOtherUserOlderPosts(SkibbleUser user, String lastPostId ,context) async {
  //   var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
  //   var posts = await FeedDatabaseService().getUserPosts(user, context, lastDocId: lastPostId);
  //
  // }
}