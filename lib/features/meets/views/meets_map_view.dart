import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../config.dart';
import '../../../models/skibble_user.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../shared/circular_profile_image.dart';
import '../controllers/meets_map_controller.dart';


class MeetsMapView extends StatefulWidget {
  const MeetsMapView({Key? key}) : super(key: key);

  @override
  State<MeetsMapView> createState() => _MeetsMapViewState();
}

class _MeetsMapViewState extends State<MeetsMapView> {

  MapboxMap? _mapboxMap;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;


  var isLight = true;


  void createOneAnnotation(Uint8List list) {
    pointAnnotationManager
        ?.create(PointAnnotationOptions(
        geometry: Point(
            coordinates: Position(
              0.381457,
              6.687337,
            )).toJson(),
        textField: "custom-icon",
        textOffset: [0.0, -2.0],
        textColor: Colors.red.value,
        iconSize: 1.3,
        iconOffset: [0.0, -5.0],
        symbolSortKey: 10,
        image: list))
        .then((value) => pointAnnotation = value);
  }


  late final Uint8List _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  Future? imageFuture;
  Future<Uint8List> captureWidget(SkibbleUser user, double pixelRatio) async{
    double pixelRatio = WidgetsBinding.instance.window.devicePixelRatio;

    return await screenshotController.captureFromWidget(
      CircularProfileImage(user: user),
      pixelRatio: pixelRatio,
      delay: Duration(milliseconds: 100),
      // targetSize: ui.Size(90, 90)
    )
        .then((capturedImage) {
      // Handle captured image
      _imageFile = capturedImage;
      return capturedImage;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    // print(pixelRatio);
    var userCurrentLocation = context.read<AppData>().userCurrentLocation;
    var currentUser = context.read<AppData>().skibbleUser!;

    return MapWidget(
      key: ValueKey("mapWidget"),
      resourceOptions: ResourceOptions(
        accessToken: APIKeys.MAPBOX_PUB_KEY,
        // baseURL: 'mapbox://styles/cfmbonu/cldy65g20000o01qtuy436ier'
      ),
      mapOptions: MapOptions(pixelRatio: 1.0),
      onMapCreated: (mapbox) => context.read<MeetsMapController>().onCreateMap(currentUser, mapbox),
      cameraOptions: CameraOptions(
          center: Point(
              coordinates: Position(
                userCurrentLocation!.longitude!,
                userCurrentLocation.latitude!,
              )).toJson(),
          zoom: 13.0),
      // styleUri: MapboxStyles.MAPBOX_STREETS,
      textureView: true,
      // onStyleLoadedListener: _onStyleLoadedCallback,
      onCameraChangeListener: _onCameraChangeListener,
      onMapIdleListener: _onMapIdleListener,
      // onMapLoadedListener: _onMapLoadedListener,
      // onMapLoadErrorListener: _onMapLoadingErrorListener,
      // onRenderFrameStartedListener: _onRenderFrameStartedListener,
      // onRenderFrameFinishedListener: _onRenderFrameFinishedListener,
      // onSourceAddedListener: _onSourceAddedListener,
      // onSourceDataLoadedListener: _onSourceDataLoadedListener,
      // onSourceRemovedListener: _onSourceRemovedListener,
      // onStyleDataLoadedListener: _onStyleDataLoadedListener,
      // onStyleImageMissingListener: _onStyleImageMissingListener,
      // onStyleImageUnusedListener: _onStyleImageUnusedListener,
      onScrollListener: _onScrollListener,
    );
  }

  _eventObserver(Event event) {
    print("Receive event, type: ${event.type}, data: ${event.data}");
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :), begin: ${data.begin}"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    print("CameraChangedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapIdleListener(MapIdleEventData data) {
    print("MapIdleEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadedListener(MapLoadedEventData data) {
    print("MapLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadingErrorListener(MapLoadingErrorEventData data) {
    print("MapLoadingErrorEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameStartedListener(RenderFrameStartedEventData data) {
    print(
        "RenderFrameStartedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {
    print(
        "RenderFrameFinishedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceAddedListener(SourceAddedEventData data) {
    print("SourceAddedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceDataLoadedListener(SourceDataLoadedEventData data) {
    print("SourceDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceRemovedListener(SourceRemovedEventData data) {
    print("SourceRemovedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleDataLoadedListener(StyleDataLoadedEventData data) {
    print("StyleDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageMissingListener(StyleImageMissingEventData data) {
    print("StyleImageMissingEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageUnusedListener(StyleImageUnusedEventData data) {
    print("StyleImageUnusedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onScrollListener(ScreenCoordinate data) {
    print("StyleImageUnusedEventData: begin: ${data.x}, end: ${data.y}");
  }
}
