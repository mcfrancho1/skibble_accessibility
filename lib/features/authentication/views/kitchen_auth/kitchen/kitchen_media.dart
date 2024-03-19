import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../shared/custom_file_picker/lib/drishya_picker.dart';
import '../../../../../../shared/custom_gmo_picker/lib/media_picker.dart';
import '../../../../../../utils/constants.dart';
import 'kitchen_register_page.dart';

class ChefRegisterMedia extends StatefulWidget {
  const ChefRegisterMedia({Key? key}) : super(key: key);

  @override
  State<ChefRegisterMedia> createState() => _ChefRegisterMediaState();
}

class _ChefRegisterMediaState extends State<ChefRegisterMedia> {

  File? profileImageFile;
  List<File?> files = List.filled(6, null);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var profileFile = Provider.of<AppData>(context, listen: false).profileImageFile;
    profileImageFile = profileFile;

    var filesProvider = Provider.of<AppData>(context, listen: false).galleryFiles;
    files = filesProvider!;
  }
  // List<Map<String, dynamic>?> filesInfo = List.filled(6, null);

  @override
  Widget build(BuildContext context) {
    var profileFile = Provider.of<AppData>(context).profileImageFile;
    var filesProvider = Provider.of<AppData>(context).galleryFiles;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile Photo', style: TextStyle(fontSize: 16),),
                  SizedBox(height: 5,),
                  Text(
                    'Add a profile photo that your patrons can easily identify you.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Center(
                    child:Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: 150,
                      width: 150,
                      decoration: profileImageFile != null ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(profileImageFile!),
                          fit: BoxFit.cover
                        )
                      ) : null,
                      child: InkWell(
                        onTap: () async{
                          await showPhotoSelectionDialog(RequestType.image, true, index: 0);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: profileImageFile == null ? DottedBorder(
                          radius: Radius.circular(10),
                          color: kPrimaryColor,
                          dashPattern: [5, 3],

                          borderType: BorderType.RRect,
                          child: Center(
                              child: Icon(
                                Iconsax.camera, size: 30, color: kPrimaryColor,)),
                        ) : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Text('Food Gallery', style: TextStyle(fontSize: 16),),
                  SizedBox(height: 5,),
                  Text(
                    'Add at least 1 photo of the meals you have made. Click the boxes to select from gallery.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  SizedBox(height: 10,),

                  Divider(),

                  SizedBox(height: 10,),


                  GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(6, (index) =>
                        Container(
                          // margin: EdgeInsets.symmetric(vertical: 20),
                          // height: 150,
                          // width: 150,
                          decoration: files[index] != null ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: FileImage( files[index]!),
                                  // image: filesInfo[index]!['type'] == AssetType.image ? FileImage( files[index]!) : MemoryImage(filesInfo[index]!['thumbnail']) as ImageProvider,
                                  fit: BoxFit.cover
                              )
                          ) : null,
                          child: InkWell(
                            onTap: () async{
                              await showPhotoSelectionDialog(RequestType.image, false, index: index);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: files[index] == null ? DottedBorder(
                              radius: Radius.circular(10),
                              color: kPrimaryColor,
                              dashPattern: [5, 3],

                              borderType: BorderType.RRect,
                              child: Center(
                                  child: Icon(
                                    Iconsax.camera, size: 30, color: kPrimaryColor,)),
                            )
                                :
                            // filesInfo[index]!['type'] == AssetType.video ?
                            // Align(
                            //   alignment: Alignment.bottomRight,
                            //   child: Container(
                            //     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            //
                            //     child: ClipRRect(
                            //       borderRadius: BorderRadius.circular(20),
                            //       child: BackdropFilter(
                            //         filter: ImageFilter.blur(
                            //             sigmaY: 19.2,sigmaX: 19.2
                            //         ),
                            //         child: Padding(
                            //           // height: 36,
                            //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            //           // alignment: Alignment.centerLeft,
                            //           child: Text(
                            //             filesInfo[index]!['duration'].toString(),
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.w700,
                            //                 color: kPrimaryColor,
                            //                 fontSize: 13
                            //             ),
                            //             maxLines: 1,
                            //             overflow: TextOverflow.ellipsis,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )
                            //     :
                            null,
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),

        ControlButtons(
          onBackPressed: () {

          },
          onNextPressed: () async{
            return '';
          },
        )
      ],
    );
  }


  picker(RequestType type, int index, bool isProfilePhoto) async{
    File? file;

    GmoMediaPicker.picker(
      context,
      isMulti: false,
      type: type,
      isReview: false,
      mulCallback: (List<AssetEntity> assets) {
        //return list if isMulti true
      },
      singleCallback: (AssetEntity asset) async{
        File? file = await asset.file;

        Map<String, dynamic> map =  {
          'duration': asset.videoDuration,
          'type': asset.type,
          'thumbnail': await asset.thumbnailData
        };
        if(isProfilePhoto) {
          profileImageFile = file;
          Provider.of<AppData>(context, listen: false).updateProfileImageFileUrl(file!);
        }

        else {
        files[index] = file;
        Provider.of<AppData>(context, listen: false).updateGalleryFilesUrls(file!, index);
          // filesInfo[index] = map;
        }

      },
    );

  }

  selectImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? xFile = await _picker.pickImage(source: ImageSource.camera);

    File file = File(xFile!.path);
    return file;
  }

  Future<File?> showPhotoSelectionDialog(RequestType type, bool isProfilePhoto, {index}) async{
    return await showDialog<File>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        title: Text('Select an Option'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              ListTile(
                leading: Icon(Iconsax.camera),
                title: Text('Camera'),
                onTap: () async{
                  File? file = await selectImageFromCamera();

                  if(isProfilePhoto) {
                    profileImageFile = file;
                    Provider.of<AppData>(context, listen: false).updateProfileImageFileUrl(file!);

                  }
                  else {
                    files[index] = file;
                    Provider.of<AppData>(context, listen: false).updateGalleryFilesUrls(file!, index);

                    // filesInfo[index] = {'type': AssetType.image};
                  }
                  Navigator.of(context).pop();
                  // await addFileToList(file);
                },
              ),

              ListTile(
                leading: Icon(Iconsax.gallery),
                title: Text('Select from Gallery'),
                onTap: () async{
                  await picker(type, index, isProfilePhoto);
                  Navigator.of(context).pop();
                },
              ),

              isProfilePhoto ? Container() : files[index] != null ? ListTile(
                leading: Icon(Iconsax.trash),
                title: Text('Remove Media'),
                onTap: () async{
                  setState(() {
                    files[index] = null;
                    // filesInfo[index] = null;
                  });
                  Navigator.pop(context);
                },
              ) : Container(),
            ],
          ),
        ),
      );
    });
  }
}
