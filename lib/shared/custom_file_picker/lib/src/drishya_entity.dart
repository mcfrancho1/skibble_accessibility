import 'dart:io';
import 'dart:typed_data';

import '../drishya_picker.dart';


///
class SkibbleEntity extends AssetEntity {
  ///
  SkibbleEntity( {
    required String id,
    required int height,
    required int width,
    required int typeInt,
    this.pickedThumbData,
    this.pickedFile,
    int duration = 0,
    int orientation = 0,
    bool isFavorite = false,
    String? title,
    int? createDtSecond,
    int? modifiedDateSecond,
    this.isRecentlyCreated,
    String? relativePath,
    double? latitude,
    double? longitude,
    String? mimeType,
  }) : super(
          id: id,
          height: height,
          width: width,
          typeInt: typeInt,
          duration: duration,
          orientation: orientation,
          isFavorite: isFavorite,
          title: title,
          createDateSecond: createDtSecond,
          modifiedDateSecond: modifiedDateSecond,
          relativePath: relativePath,
          latitude: latitude,
          longitude: longitude,
          mimeType: mimeType,
        );

  /// Thumb bytes of image and video. Dont use this for other asset types.
  /// This
  final Uint8List? pickedThumbData;

  /// Field where asset is stored
  final File? pickedFile;

  final bool? isRecentlyCreated;

  ///
  ///
  SkibbleEntity copy({
    Uint8List? pickedThumbData,
    File? pickedFile,
    bool? isRecentlyCreated
  }) =>
      SkibbleEntity(
        id: id,
        width: width,
        height: height,
        typeInt: typeInt,
        duration: duration,
        orientation: orientation,
        isFavorite: isFavorite,
        title: title,
        createDtSecond: createDateSecond,
        modifiedDateSecond: modifiedDateSecond,
        relativePath: relativePath,
        latitude: latitude,
        longitude: longitude,
        mimeType: mimeType,
        isRecentlyCreated: isRecentlyCreated ?? this.isRecentlyCreated,
        pickedThumbData: pickedThumbData ?? this.pickedThumbData,
        pickedFile: pickedFile ?? this.pickedFile,
      );
}

/// AssetEntity extension
extension AssetEntityX on AssetEntity {
  /// Convert [AssetEntity] to [SkibbleEntity]
  SkibbleEntity get toSkibble => SkibbleEntity(
        id: id,
        width: width,
        height: height,
        typeInt: typeInt,
        duration: duration,
        orientation: orientation,
        isFavorite: isFavorite,
        title: title,
        createDtSecond: createDateSecond,
        modifiedDateSecond: modifiedDateSecond,
        relativePath: relativePath,
        latitude: latitude,
        longitude: longitude,
        mimeType: mimeType,
      );
}
