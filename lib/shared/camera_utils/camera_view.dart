import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:skibble/models/skib_entity.dart';
import 'package:skibble/shared/camera_utils/video_view.dart';

import '../../features/skibs/post_views/edit_post_view.dart';
import '../custom_file_picker/lib/drishya_picker.dart';
import 'custom_cropper.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  late final CameraController _cameraController;
  Future<void>? cameraValue;
  bool isRecording = false;
  bool flash = false;
  bool isCameraFront = true;
  double transform = 0;

  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
     cameraValue = setupCamera();

  }

  Future<CameraController> setupCamera() async{
    List<CameraDescription>? availableCams = await availableCameras();

    cameras = availableCams;
    _cameraController = CameraController(availableCams[0], ResolutionPreset.high);
    await _cameraController.initialize();

    return _cameraController;
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        setupCamera();
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_cameraController));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              flash = !flash;
                            });
                            flash
                                ? _cameraController
                                .setFlashMode(FlashMode.torch)
                                : _cameraController.setFlashMode(FlashMode.off);
                          }),
                      GestureDetector(
                        onLongPress: () async {
                          await _cameraController.startVideoRecording();
                          setState(() {
                            isRecording = true;
                          });
                        },
                        onLongPressUp: () async {
                          XFile videopath = await _cameraController.stopVideoRecording();
                          setState(() {
                            isRecording = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => VideoViewPage(
                                    path: videopath.path,
                                    onDone: () {},
                                  )));
                        },
                        onTap: () async {
                          if (!isRecording) {
                            XFile? file = await _cameraController.takePicture();

                            var result = await CustomCropper.cropImage(file.path);

                            if(result != null) {
                              // final AssetEntity? imageEntityWithPath = await PhotoManager.editor.saveImageWithPath(
                              //   result.path, // Use the absolute path of your source file, it's more like a copy method.
                              //   title: 'imgskib_${DateTime.now().millisecondsSinceEpoch}.jpg',
                              // );
                              
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EditPostView(skibEntities: [SkibEntity(file: File(result.path), fileType: AssetType.image, isRecentlyCreated: true)])), ModalRoute.withName('/'));

                            }

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (builder) => CustomImageCropper(
                            //           file: File(file.path),
                            //         )));
                          }
                        },
                        child: isRecording
                            ? Icon(
                          Icons.radio_button_on,
                          color: Colors.red,
                          size: 80,
                        )
                            : Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                      IconButton(
                          icon: Transform.rotate(
                            angle: transform,
                            child: Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isCameraFront = !isCameraFront;
                              transform = transform + pi;
                            });
                            int cameraPos = isCameraFront ? 0 : 1;
                            _cameraController = CameraController(
                                cameras![cameraPos], ResolutionPreset.high);
                            cameraValue = _cameraController.initialize();
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Hold for Video, tap for photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void takePhoto(BuildContext context) async {

  }
}