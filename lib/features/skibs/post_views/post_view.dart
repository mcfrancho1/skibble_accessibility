// import 'dart:io';
// import 'dart:ui';
//
// import 'package:cropperx/cropperx.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper_view/flutter_swiper_view.dart';
// import 'package:fluttericon/entypo_icons.dart';
// import 'package:fluttericon/font_awesome5_icons.dart';
// import 'package:fluttericon/linearicons_free_icons.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:iconsax/iconsax.dart';
// // import 'package:image_editor_plus/image_editor_plus.dart';
// import 'package:skibble/shared/camera_utils/camera_view.dart';
// import 'package:skibble/shared/custom_app_bar.dart';
// import 'package:skibble/shared/custom_file_picker/lib/src/gallery/src/widgets/gallery_view_field.dart';
// import 'package:skibble/shared/custom_file_picker/lib/src/slidable_panel/src/slidable_panel.dart';
// import 'package:skibble/utils/constants.dart';
// import 'package:skibble/utils/current_theme.dart';
//
//
// import '../../../shared/custom_video_player.dart';
// import 'package:path/path.dart' as path;
//
//
// class PostView extends StatefulWidget {
//   const PostView({Key? key}) : super(key: key);
//
//   @override
//   State<PostView> createState() => _PostViewState();
// }
//
// class _PostViewState extends State<PostView> {
//   late final GalleryController _controller;
//   late final ValueNotifier<Data> _notifier;
//   late final SwiperController swiperController;
//
//   List<SkibbleEntity> entityList = [];
//
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = GalleryController();
//     _notifier = ValueNotifier(Data());
//     swiperController = SwiperController();
//
//
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _notifier.dispose();
//     _controller.dispose();
//   }
//
// //   onPressed: () async {
// //   final entities = await controller.pick();
// // }
//   @override
//   Widget build(BuildContext context) {
//     return SlidableGallery(
//       controller: _controller,
//       setting: PanelSetting(),
//       child: Scaffold(
//           appBar: CustomAppBar(
//             title:  'Post Content',
//             actions: [
//               ValueListenableBuilder<Data>(
//                   valueListenable: _notifier,
//                   builder: (context, data, child) {
//                     if (data.entities.isEmpty) {
//                       return Container();
//                     }
//                     return TextButton(
//                         // onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPostView(skibEntities: data.entities,))),
//                         child: Text('Next', style: TextStyle(fontSize: 15),),
//                       onPressed: () {},
//                     );
//                   })
//             ] ,
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child:
//                 SwiperViewWidget(
//                   controller: _controller,
//                   setting: gallerySetting,
//                   notifier: _notifier,
//                   swiperController: swiperController,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
//
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     // Textfield
//                     // Expanded(child: TextFieldView(notifier: _notifier)),
//
//                     //camera
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
//                       child: GestureDetector(
//                         onTap: ()  async{
//                           // _notifier.value = _notifier.value.copyWith(
//                           //   entities: [..._notifier.value.entities, ...entities],
//                           // );
//
//                           // final drishyaEntity;
//                           // var file = await HelperMethods().getImageFromCamera();
//                           // if(file != null) {
//                           //     final entity = await PhotoManager.editor.saveImageWithPath(
//                           //       file.path,
//                           //       title: path.basename(file.path),
//                           //     );
//                           //     if (file.existsSync()) {
//                           //       file.deleteSync();
//                           //     }
//                           //
//                           //     if (entity != null) {
//                           //        drishyaEntity = entity.toDrishya.copy(
//                           //         pickedFile: file,
//                           //       );
//                           //
//                           //     }
//                           //
//                           //
//                           // }
//                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraScreen()));
//
//                           // final AssetEntity? entity = await CameraPicker.pickFromCamera(
//                           //   context,
//                           //   pickerConfig: const CameraPickerConfig(
//                           //     enableAudio: true,
//                           //     enablePinchToZoom: true,
//                           //     enableRecording: true,
//                           //     maximumRecordingDuration: Duration(seconds: 10),
//                           //     shouldDeletePreviewFile: true,
//                           //     // foregroundBuilder: (BuildContext context, CamController cam) => Container()
//                           //   ),
//                           // );
//                           //
//                           // if(entity != null) {
//                           //   final entities = List<DrishyaEntity>.from(_notifier.value.entities);
//                           //   DrishyaEntity drishyaEntity = entity.toDrishya;
//                           //   entities.add(drishyaEntity);
//                           //   _notifier.value =
//                           //       _notifier.value.copyWith(entities: entities);
//                           //
//                           //   if(_notifier.value.entities.length > 1) {
//                           //     if(_notifier.value.entities.indexOf(drishyaEntity) > 0) {
//                           //       await swiperController.previous();
//                           //     }
//                           //     else {
//                           //       await swiperController.next();
//                           //     }
//                           //   }
//                           // }
//                           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CameraScreen()));
//                         },
//                         child: CircleAvatar(
//                           backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kPrimaryColor,
//                           radius: 23,
//                           child: const Icon(
//                             Entypo.camera,
//                             color: kLightSecondaryColor,
//
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Camera field..
//                     // Padding(
//                     //   padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
//                     //   child: CameraViewField(
//                     //     // editorSetting: EditorSetting(
//                     //     //   colors: _defaultBackgrounds
//                     //     //       .map((e) => e.colors!)
//                     //     //       .expand((e) => e)
//                     //     //       .toList(),
//                     //     //   stickers: _stickers1,
//                     //     // ),
//                     //     // photoEditorSetting: EditorSetting(
//                     //     //   colors: _colors.skip(4).toList(),
//                     //     //   stickers: _stickers3,
//                     //     // ),
//                     //     onCapture: (entities) {
//                     //       _notifier.value = _notifier.value.copyWith(
//                     //         entities: [..._notifier.value.entities, ...entities],
//                     //       );
//                     //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPostView(assetEntities: _notifier.value.entities,)));
//                     //     },
//                     //     child: const Icon(Iconsax.camera),
//                     //   ),
//                     // ),
//
//                     // Gallery field
//                     ValueListenableBuilder<Data>(
//                       valueListenable: _notifier,
//                       builder: (context, data, child) {
//                         return GalleryViewField(
//                           controller: _controller,
//                           setting: gallerySetting.copyWith(
//                             maximumCount: data.maxLimit,
//                             albumSubtitle: 'Image only',
//                             requestType: data.requestType,
//                             selectedEntities: data.entities,
//                           ),
//                           onChanged: (entity, remove) async {
//
//                             final entities = _notifier.value.entities.toList();
//                             setState(() {
//                               remove
//                                   ? entities.remove(entity)
//                                   : entities.add(entity);
//                               _notifier.value =
//                                   _notifier.value.copyWith(entities: entities);
//                             });
//
//                             if(data.entities.length > 1) {
//                               if(data.entities.indexOf(entity) > 0) {
//                                 await swiperController.previous();
//                               }
//                               else {
//                                 await swiperController.next();
//                               }
//                             }
//                           },
//                           onSubmitted: (list) {
//                             _notifier.value =
//                                 _notifier.value.copyWith(entities: list);
//                           },
//                           child: child,
//                         );
//                       },
//                       child: GestureDetector(
//                         onTap: () {},
//                         child: CircleAvatar(
//                           backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kPrimaryColor,
//                           radius: 23,
//                           child: const Icon(
//                             FontAwesome5.images,
//                             color: kLightSecondaryColor,
//
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     //
//                   ],
//                 ),
//               ),
//               // SafeArea(child: RecentEntities(controller: _controller, notifier: _notifier, swiperController:  swiperController,)),
//
//             ],
//           )
//       )
//       ,
//     );
//   }
// }
//
//
// class SwiperViewWidget extends StatefulWidget {
//   ///
//   const SwiperViewWidget({
//     Key? key,
//     required this.controller,
//     required this.setting,
//     required this.notifier,
//     required this.swiperController
//   }) : super(key: key);
//
//   ///
//   final GalleryController controller;
//
//   ///
//   final GallerySetting setting;
//   final SwiperController swiperController;
//
//   ///
//   final ValueNotifier<Data> notifier;
//
//   @override
//   State<SwiperViewWidget> createState() => _SwiperViewWidgetState();
// }
//
// class _SwiperViewWidgetState extends State<SwiperViewWidget> {
//
//   int _swiperIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       margin: const EdgeInsets.symmetric(vertical: 16),
//       // padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//          color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
//       ),
//       child: ValueListenableBuilder<Data>(
//         valueListenable: widget.notifier,
//         builder: (context, data, child) {
//           if (data.entities.isEmpty) {
//             return ValueListenableBuilder<PanelValue>(
//               valueListenable: widget.controller.panelController,
//               builder: (context, value, child) {
//                 if (value.state == PanelState.close) {
//                   return child!;
//                 }
//                 return Container(child:  Text('Tap to close', style: TextStyle(color: Colors.grey, fontSize: 18),),);
//               },
//               child: Center(
//                 child: InkWell(
//                   onTap: () async {
//                     final entities = await widget.controller.pick(
//                       context,
//                       setting: widget.setting.copyWith(
//                         maximumCount: widget.notifier.value.maxLimit,
//                         albumSubtitle: 'All',
//                         requestType: widget.notifier.value.requestType,
//                         selectedEntities: widget.notifier.value.entities,
//                       ),
//                     );
//                     widget.notifier.value =
//                         widget.notifier.value.copyWith(entities: entities);
//                   },
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // CircleAvatar(
//                       //   backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kPrimaryColor,
//                       //   radius: 30,
//                       //   child: Icon(FontAwesome5.image, color: kLightSecondaryColor, size: 30,),
//                       // ),
//                       // SizedBox(height: 10,),
//
//                       Text('Tap to select', style: TextStyle(color: Colors.grey, fontSize: 18),),
//
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//           return Container(
//             child: Swiper(
//               loop: false,
//               // index: _swiperIndex,
//               controller: widget.swiperController,
//               // onIndexChanged: (index){
//               //   setState(() => _swiperIndex = index);
//               // },
//               itemBuilder: (context, index) {
//                 var entity = data.entities[index];
//                 return Stack(
//                   children: [
//                     DisplayEntityAsset(entity: entity, margin: const EdgeInsets.symmetric(horizontal: 15),),
//                     Positioned(
//                       right: 10,
//                       top: 5,
//                       child: GestureDetector(
//                         onTap: () async{
//                           // final entities =
//                           // List<DrishyaEntity>.from(data.entities);
//                             data.entities.remove(entity);
//                             widget.notifier.value =
//                                 data.copyWith(entities: data.entities);
//
//                             if(data.entities.length > 1) {
//                               if(index > 0) {
//                                 await widget.swiperController.previous();
//                               }
//                               else {
//                                 await widget.swiperController.next();
//                               }
//                             }
//
//                           // notifier.notifyListeners();
//                         },
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(
//                                 sigmaY: 5.2,
//                                 sigmaX: 5.2
//                             ),
//
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Icon(Iconsax.trash, color: kLightSecondaryColor,),
//                             )),
//
//                         ),
//                         // Container(
//                         //   padding: EdgeInsets.all(8),
//                         //   decoration: BoxDecoration(
//                         //     shape: BoxShape.circle,
//                         //     color: kErrorColor
//                         //   ),
//                         //     child:
//                       ),
//                     )
//                   ],
//                 );
//               },
//               itemCount: data.entities.length,
//               // itemWidth: 300.0,
//               // itemHeight: 400.0,
//               layout: SwiperLayout.DEFAULT,
//               viewportFraction: 1.0,
//               scale: 0.9,
//               outer: true,
//               pagination: SwiperPagination(
//                   margin: new EdgeInsets.only(top: 10),
//                   builder: DotSwiperPaginationBuilder(
//                       activeColor: kPrimaryColor,
//                       color: Colors.grey.shade300,
//                       activeSize: 15
//                   )
//               ),
//             ),
//           );
//
//           // return GridView.builder(
//           //   padding: const EdgeInsets.all(4.0),
//           //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           //     crossAxisCount: 3,
//           //     crossAxisSpacing: 1.0,
//           //     mainAxisSpacing: 1.0,
//           //   ),
//           //   itemCount: data.entities.length,
//           //   itemBuilder: (context, index) {
//           //     final entity = data.entities[index];
//           //     return EntityThumbnail(entity: entity);
//           //   },
//           // );
//         },
//       ),
//     );
//   }
// }
//
// class DisplayEntityAsset extends StatefulWidget {
//   const DisplayEntityAsset({Key? key, this.margin = const EdgeInsets.symmetric(horizontal: 10), this.borderRadius = 10, required this.entity}) : super(key: key);
//   final SkibbleEntity entity;
//   final double? borderRadius;
//   final EdgeInsetsGeometry? margin;
//
//   @override
//   State<DisplayEntityAsset> createState() => _DisplayEntityAssetState();
// }
//
// class _DisplayEntityAssetState extends State<DisplayEntityAsset> {
//
//   Future? future;
//   void initState() {
//     future = widget.entity.file;
//     super.initState();
//   }
//
//   final _cropperKey = GlobalKey(debugLabel: 'cropperKey');
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: future,
//       builder: (context, snapshot) {
//         switch(snapshot.connectionState) {
//
//           case ConnectionState.none:
//
//           case ConnectionState.waiting:
//             return Container(
//               // margin: widget.margin,
//               decoration: BoxDecoration(
//                   // borderRadius: BorderRadius.circular(widget.borderRadius!),
//                   color: Colors.grey.shade300
//               ),
//             );
//           case ConnectionState.active:
//           case ConnectionState.done:
//             if(snapshot.hasData) {
//               File file = snapshot.data as File;
//
//               return widget.entity.type == AssetType.image? Container(
//                 // margin: widget.margin,
//                 // decoration: BoxDecoration(
//                 //   // borderRadius: BorderRadius.circular(widget.borderRadius!),
//                 //     image: DecorationImage(
//                 //         image: FileImage(file ),
//                 //       fit: BoxFit.cover
//                 //     )
//                 // ),
//                 // alignment: Alignment.center,
//
//                 child: Cropper(
//                   image: Image.file(file, fit: BoxFit.cover,),
//                   overlayType: OverlayType.grid,
//                   cropperKey: _cropperKey, // <-- Uint8List of image
//                 ),
//               )
//                   :
//               widget.entity.type == AssetType.video ? Container(
//                   // margin: widget.margin,
//
//                   // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   // margin: EdgeInsets.symmetric(vertical: 50),
//                   decoration: BoxDecoration(
//                       color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : Colors.transparent,
//                       // borderRadius: BorderRadius.circular(10),
//                       image: DecorationImage(
//                           image: MediaThumbnailProvider(entity: widget.entity),
//                           fit: BoxFit.cover
//                       )
//                   ),
//
//                   child: Center(
//                     child: InkWell(
//                       onTap: () {
//                         // VideoPlayerController videoController = VideoPlayerController.file(videoFile!);
//
//                         Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
//                             CustomVideoPlayer(
//                               urlType: 'file',
//                               videoUrl: file.path,
//                               isFullScreen: true,
//                             )
//                         )
//                         );
//                       },
//
//                       child: CircleAvatar(
//                           radius: 25,
//                           backgroundColor: kPrimaryColor,
//                           child: Center(
//                             child: Icon(
//                               Iconsax.play,
//                               color: Colors.white,
//                               size: 25,
//                             ),
//                           )),
//                     ),
//                   )
//               ) : Container();
//             }
//             else {
//               return Container();
//             }
//         }
//       }
//     );
//   }
// }
//
//
// class RecentEntities extends StatefulWidget {
//   ///
//   const RecentEntities({
//     Key? key,
//     required this.controller,
//     required this.notifier,
//     required this.swiperController
//   }) : super(key: key);
//
//   ///
//   final GalleryController controller;
//   final SwiperController swiperController;
//
//   ///
//   final ValueNotifier<Data> notifier;
//
//   @override
//   State<RecentEntities> createState() => _RecentEntitiesState();
// }
//
// class _RecentEntitiesState extends State<RecentEntities> {
//   late final Future<List<SkibbleEntity?>> _future;
//
//   @override
//   void initState() {
//     super.initState();
//     _future = widget.controller.recentEntities();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             'Recent',
//             style: Theme.of(context).textTheme.headline6,
//           ),
//         ),
//         SizedBox(
//           height: 100.0,
//           width: MediaQuery.of(context).size.width,
//           child: FutureBuilder<List<SkibbleEntity?>>(
//             future: _future,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState != ConnectionState.done ||
//                   (snapshot.data?.isEmpty ?? true)) {
//                 return const SizedBox();
//               }
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.only(right: 4.0),
//                 itemBuilder: (c, i) {
//                   final entity = snapshot.data![i];
//                   if (entity == null) return const SizedBox();
//                   return ValueListenableBuilder<Data>(
//                     valueListenable: widget.notifier,
//                     builder: (context, data, child) {
//                       final selected = data.entities.contains(entity);
//
//                       return Padding(
//                         padding: const EdgeInsets.only(left: 4.0),
//                         child: InkWell(
//                           onTap: () async{
//                             final entities =
//                             List<SkibbleEntity>.from(data.entities);
//                             if (selected) {
//                               entities.remove(entity);
//                             } else {
//                               entities.add(entity);
//                             }
//                             widget.notifier.value =
//                                 data.copyWith(entities: entities);
//
//                             if(data.entities.length > 1) {
//                               if(data.entities.indexOf(entity) > 0) {
//                                 await widget.swiperController.previous();
//                               }
//                               else {
//                                 await widget.swiperController.next();
//                               }
//                             }
//                           },
//                           child: Stack(
//                             children: [
//                               SizedBox(
//                                 height: 100.0,
//                                 width: 100.0,
//                                 child: DisplayEntityAsset(entity: entity, borderRadius: 0, margin: const EdgeInsets.symmetric(horizontal: 2),),
//                               ),
//                               if (selected)
//                                 Positioned.fill(
//                                   child: ColoredBox(
//                                     color: Theme.of(context)
//                                         .colorScheme
//                                         .primary
//                                         .withOpacity(0.5),
//
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
// ///
// class Data {
//   ///
//   Data({
//     this.entities = const [],
//     this.maxLimit = 10,
//     this.requestType = RequestType.all,
//   });
//
//   ///
//   final List<SkibbleEntity> entities;
//
//   ///
//   final int maxLimit;
//
//   ///
//   final RequestType requestType;
//
//   ///
//   Data copyWith({
//     List<SkibbleEntity>? entities,
//     int? maxLimit,
//     RequestType? requestType,
//   }) {
//     return Data(
//       entities: entities ?? this.entities,
//       maxLimit: maxLimit ?? this.maxLimit,
//       requestType: requestType ?? this.requestType,
//     );
//   }
// }
//
//
// GallerySetting get gallerySetting => GallerySetting(
//   enableCamera: true,
//   maximumCount: 10,
//   requestType: RequestType.all,
//   cameraSetting: const CameraSetting(videoDuration: Duration(seconds: 15)),
//
// );
//
//
// ///
//
// ///
//
