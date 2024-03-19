import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/services/maps_services/geo_locator_service.dart';
import 'package:skibble/services/maps_services/map_requests.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_models/chat_message.dart';
import '../models/skibble_user.dart';
import '../services/change_data_notifiers/app_data.dart';
import '../services/firebase/database/chats_database.dart';
import '../utils/scrollers.dart';
import 'dialogs.dart';

class CustomMap extends StatefulWidget {
  final Address address;
  final SkibbleUser skibbleFriend;
  final ChatMessage? swipedMessage;
  final VoidCallback? onCancelReply;
  final String conversationId;
  final ScrollController listScrollController;
  final EdgeInsets? padding;
  // final bool isDarkMode;

  CustomMap({
    required this.address, this.padding,
    required this.skibbleFriend,
    required this.conversationId,
    required this.onCancelReply,
    required this.swipedMessage,
    required this.listScrollController,
  });
  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {

  //GoogleMapController mapController;
  GoogleMapsService mapsService = GoogleMapsService();
  GeoLocatorService geoService = GeoLocatorService();
  Completer<GoogleMapController> _controller  = Completer();

  GoogleMapController? newMapController;

  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();




  var uuid = Uuid();

  @override
  void dispose() {
    // TODO: implement dispose
    newMapController!.dispose();
    super.dispose();
  }
  late String _darkMapStyle;
  late String _lightMapStyle;

  @override
  void initState() {
    // TODO: implement initState

    _loadMapStyles();
    setCustomMapPin();

    super.initState();
    // getUserLocation(widget.userGeoDetails.initialPosition);
    // geoService.currentLocation.listen((position) {
    //   //centerScreen(position);
    //
    //
    // });
  }


  Future _loadMapStyles() async {
    _darkMapStyle  = await rootBundle.loadString('assets/map_styles/dark_theme_mode.json');
    _lightMapStyle = await rootBundle.loadString('assets/map_styles/light_theme_mode.json');
  }

  // Future _setMapStyle() async {
  //   final controller = await _controller.future;
  //   final theme = WidgetsBinding.instance.window.platformBrightness;
  //   if (theme == Brightness.dark)
  //     controller.setMapStyle(_darkMapStyle);
  //   else
  //     controller.setMapStyle(_lightMapStyle);
  // }
  //
  // @override
  // void didChangePlatformBrightness() {
  //   setState(() {
  //     _setMapStyle();
  //   });
  // }

  void getUserLocation(Position position) async{
    //Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
    //_initialPosition = LatLng(position.latitude, position.longitude);
    locationController.text = placeMark[0].street!;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  final Set<Marker> _markersSet = {};
  LatLng? firstPoint;
  BitmapDescriptor? locationPin;

  void setCustomMapPin() async {

    final Uint8List destinationIcon = await getBytesFromAsset('assets/images/marker_1_106x106.png', 150);

    locationPin = BitmapDescriptor.fromBytes(destinationIcon);

  }

  reDrawMap(Address newAddress, String userId) {
    newMapController?.animateCamera(CameraUpdate.newLatLng(LatLng(newAddress.latitude!, newAddress.longitude!)));

    Marker locationMarker = Marker(
      icon: locationPin!,
      infoWindow: InfoWindow(
        title: newAddress.placeName,
        snippet: 'Tap to share this location',
        onTap: () async{
          sendLocationMessage(userId, newAddress);
        }
      ),
      position: LatLng(newAddress.latitude!, newAddress.longitude!),
      markerId: MarkerId(Uuid().v4()),

    );
    //
    // setState(() {
      _markersSet.add(locationMarker);
    // });

    // Provider.of<AppData>(context,listen: false).updateLocationAddress(null);

  }
  @override
  Widget build(BuildContext context) {
    var address = Provider.of<AppData>(context, listen: false).locationAddress;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;


    Size size = MediaQuery.of(context).size;
    if(newMapController != null) {
      newMapController!.setMapStyle(CurrentTheme(context).isDarkMode ? _darkMapStyle : _lightMapStyle);

    }

    if(address != null) {
      reDrawMap(address, currentUser.userId!);
    }
    return Scaffold(
      body: GoogleMap(
        padding: widget.padding != null ? widget.padding! : EdgeInsets.all(0),

        initialCameraPosition: CameraPosition(
            target: LatLng(
                widget.address.latitude!,
                widget.address.longitude!),
            zoom: 14
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType:  MapType.normal,
        markers: _markersSet,
        //onCameraMove: _onCameraMove,
        // circles: _circlesSet,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    try{
      _controller.complete(controller);
      newMapController = controller;
      newMapController!.setMapStyle(CurrentTheme(context).isDarkMode ? _darkMapStyle : _lightMapStyle);
      // locatePosition();
    }
    catch(e) {

    }

  }

  sendLocationMessage(String userId, Address address) async {
    int timestampSent = DateTime.now().millisecondsSinceEpoch;

    ChatMessage message = ChatMessage(
        content: "",
        idFrom: userId,
        idTo: widget.skibbleFriend.userId!,
        timestamp: timestampSent,
        messageType: ChatMessageType.location,
        locationMessage: address,
        repliedMessage: widget.swipedMessage != null ? widget.swipedMessage! : null
    );

    CustomDialog(context).showProgressDialog(context, 'Sending Location...');


    var result = await ChatsDatabaseService(userId: userId).sendLocationMessage(message, widget.conversationId);


    if(result != null) {
      Navigator.of(context).pop();
      Navigator.of(context).pop(true);
    }
    else {
      CustomDialog(context).showErrorDialog('Error Sending Location', 'Unable to send location at the moment. Try again later');
    }

    AutoScrollers(widget.listScrollController).scrollToBottomOfChatPage();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}


class ChatMap extends StatelessWidget {
  ChatMap({Key? key, required this.address, this.padding, this.zoomLevel = 10}) : super(key: key);

  final Address address;
  final EdgeInsets? padding;
  final double zoomLevel;

  final GoogleMapsService mapsService = GoogleMapsService();
  final GeoLocatorService geoService = GeoLocatorService();
  final Completer<GoogleMapController> _controller  = Completer();

  final TextEditingController locationController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final Uuid uuid = Uuid();


  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: padding != null ? padding! : EdgeInsets.all(0),

      initialCameraPosition: CameraPosition(
          target: LatLng(
              address.latitude!,
                  address.longitude!),
          zoom: zoomLevel
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
      ].toSet(),
      // onTap: (l) {},
      onMapCreated: (controller) => _onMapCreated(controller, context),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType:  MapType.normal,
      markers: {Marker(
        position: LatLng(address.latitude!, address.longitude!),
        markerId: MarkerId(Uuid().v4()),

      )},
      //onCameraMove: _onCameraMove,
      // circles: _circlesSet,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
    );
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  final Set<Marker> _markersSet = {};
  LatLng? firstPoint;
  BitmapDescriptor? locationPin;

  void setCustomMapPin() async {

    final Uint8List destinationIcon = await getBytesFromAsset('assets/images/marker_1_106x106.png', 150);

    locationPin = BitmapDescriptor.fromBytes(destinationIcon);

  }

  void _onMapCreated(GoogleMapController controller, context) async{
    try{
     var _darkMapStyle  = await rootBundle.loadString('assets/map_styles/dark_theme_mode.json');
      var _lightMapStyle = await rootBundle.loadString('assets/map_styles/light_theme_mode.json');

      _controller.complete(controller);
      GoogleMapController newMapController = controller;
      newMapController.setMapStyle(CurrentTheme(context).isDarkMode ? _darkMapStyle : _lightMapStyle);
      // locatePosition();
    }
    catch(e) {

    }

  }
}
